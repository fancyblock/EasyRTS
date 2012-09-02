package gameObj.moveableObj 
{
	import flash.geom.Point;
	import gameComponent.Command;
	import gameComponent.LifeBar;
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
		
		static protected const BLOCK_WAIT_TIME:int = 13;				// magic number
		
		//------------------------------ private member ------------------------------------
		
		protected var m_lifeBar:LifeBar = null;
		
		protected var m_destGrid:Point = null;
		protected var m_enemyUnit:MapItem = null;
		
		protected var m_pathBlocked:Boolean = false;
		protected var m_waitCounter:int = 0;
		
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
					if ( m_moveState == STATE_MOVE || m_moveState == STATE_BLOCK )
					{
						m_pathBlocked = false;
						this.stopMove();
					}
					
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
					}
					else
					{
						//TODO [maybe bug]
					}
				}
				
				// attack an enemy
				if ( m_command._type == Command.CMD_ATTACK )
				{
					m_enemyUnit = m_command._aim;
					
					//TODO 
				}
				
				m_command = null;
			}
			
			if ( m_pathBlocked == true )
			{
				m_waitCounter++;
				
				if ( m_waitCounter > BLOCK_WAIT_TIME )
				{
					m_pathBlocked = false;
					
					followPath();
				}
			}
			
			//TODO 
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
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}