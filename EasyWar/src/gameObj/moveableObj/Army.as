package gameObj.moveableObj 
{
	import flash.geom.Point;
	import gameComponent.Command;
	import gameComponent.LifeBar;
	import gameObj.Unit;
	import map.GridInfo;
	import mapItem.MapItem;
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Army extends MoveableItem 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const STATE_ARMY_IDLE:int = 0;
		static protected const STATE_ARMY_MOVE:int = 1;
		static protected const STATE_ARMY_ATTACK:int = 2;
		static protected const STATE_ARMY_ALERT:int = 3;
		
		static protected const BLOCK_WAIT_TIME:int = 13;				// magic number
		
		//------------------------------ private member ------------------------------------
		
		protected var m_lifeBar:LifeBar = null;
		
		protected var m_destGrid:Point = null;
		protected var m_enemyUnit:MapItem = null;
		
		protected var m_pathBlocked:Boolean = false;
		protected var m_waitCounter:int = 0;
		
		protected var m_armyState:int = 0;
		
		protected var m_firingRange:Number = 100;
		protected var m_fireColdDownTime:int = 30;
		protected var m_fireColdDownCounter:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Army
		 */
		public function Army() 
		{
			super();
			
			// initial the lifebar
			m_lifeBar = new LifeBar();
			m_lifeBar.x = 0;
			m_lifeBar.y = 0;
			
			// initial state
			m_armyState = STATE_ARMY_IDLE;
		}
		
		
		/**
		 * @desc	select
		 */
		override public function set SELECTED( value:Boolean ):void
		{ 
			super.SELECTED = value;
			
			m_lifeBar.visible = this.SELECTED;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			var i:int;
			
			// process the order
			if ( m_command != null )
			{
				// move to a dest
				if ( m_command._type == Command.CMD_MOVE )
				{
					m_pathBlocked = false;
					this.stopMove();
					
					var orgPath:Array = this.findPath( new Point( m_command._destGrid._x, m_command._destGrid._y ) );
					
					if ( orgPath != null )
					{
						m_destGrid = new Point( m_command._destGrid._x, m_command._destGrid._y );
						
						var path:Vector.<GridInfo> = new Vector.<GridInfo>();
						for ( i = 1; i < orgPath.length; i++ )					// exclude self
						{
							path.push( m_map.GetGridInfo( orgPath[i].x, orgPath[i].y ) );
						}
						
						this.PATH = path;
						
						m_armyState = STATE_ARMY_MOVE;
					}
					else
					{
						//TODO
						
						trace( "[Army]: can not find the path" );
					}
				}
				
				// attack an enemy
				if ( m_command._type == Command.CMD_ATTACK )
				{
					m_pathBlocked = false;
					this.stopMove();
					
					m_enemyUnit = m_command._aim;
					
					//TODO 
					
					m_armyState = STATE_ARMY_ATTACK;
				}
				
				m_command = null;
			}
			
			// attack behavior
			if ( m_armyState == STATE_ARMY_ATTACK )
			{
				if ( m_enemyUnit.STATE == Unit.STATE_DEAD || m_enemyUnit.STATE == Unit.STATE_REMOVE )
				{
					m_enemyUnit = null;
					
					m_pathBlocked = false;
					this.stopMove();
					m_armyState = STATE_ARMY_IDLE;
				}
				else
				{
					if ( isUnitInFiringRange( m_enemyUnit ) == true )
					{
						if ( m_fireColdDownCounter == 0 )
						{
							onFire( m_enemyUnit );
							m_fireColdDownCounter = m_fireColdDownTime;
						}
					}
					else
					{
						//TODO 
					}
				}
			}
			
			// fire colddown
			if ( m_fireColdDownCounter > 0 )
			{
				m_fireColdDownCounter--;
			}
			
			// move block 
			if ( m_pathBlocked == true )
			{
				m_waitCounter++;
				
				if ( m_waitCounter > BLOCK_WAIT_TIME )
				{
					m_pathBlocked = false;
					
					followPath();
				}
			}
			
			// 
		}
		
		
		/**
		 * @desc	some callback functions ( should be override )
		 */
		override public function onDirectionChanged( newDir:Point ):void 
		{ 
		}
		
		
		override public function onPathBeBlock():void 
		{
			m_pathBlocked = true;
			m_waitCounter = 0;
		}
		
		
		override public function onArriveDest():void 
		{
			//TODO 
		}
		
		
		/**
		 * @desc	behavior callback functions
		 * @param	unit
		 * @return
		 */
		public function onFire( unit:Unit ):void { }
		
		
		//------------------------------ private function ----------------------------------
		
		// judge if the unit is in firing range
		protected function isUnitInFiringRange( unit:Unit ):Boolean
		{
			var xOffset:Number = unit.POSITION.x - m_position.x;
			var yOffset:Number = unit.POSITION.y - m_position.y;
			var distance:Number = Math.sqrt( ( xOffset * xOffset ) + ( yOffset * yOffset ) );
			
			if ( distance <= m_firingRange )
			{
				return true;
			}
			
			return false;
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}