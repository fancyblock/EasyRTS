package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameComponent.Command;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	import gameObj.weapons.Cannonball;
	import gameObj.weapons.OccupyPoint;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Infantry extends Army 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const INFANTRY_SPEED:Number = 2.5;
		static protected const INFANTRY_LIFE_VALUE:Number = 100.0;
		static protected const INFANTRY_FIRINGRANGE:Number = 90;
		
		static protected const INFANTRY_FORCE:Number = 3;
		static protected const OCCUPY_RANGE:Number = 70;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_imgSoldier:MovieClip = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Infantry
		 */
		public function Infantry() 
		{
			super();
			
			this.VELOCITY = INFANTRY_SPEED;
			m_firingRange = INFANTRY_FIRINGRANGE;
			m_maxLifeValue = INFANTRY_LIFE_VALUE;
			m_lifeValue = m_maxLifeValue;
			
			m_type = UnitTypes.TYPE_INFANTRY;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			if ( m_command != null )
			{
				if ( m_command._type == Command.CMD_OCCUPY )
				{
					if ( m_command._aim.GROUP != this.GROUP )
					{
						m_pathBlocked = false;
						this.stopMove();
						
						m_enemyUnit = m_command._aim;
						m_currentTraceDest.x = -100;
						m_currentTraceDest.y = -100;
						
						m_armyState = STATE_ARMY_OCCUPY;
						
						traceTo( m_enemyUnit );
						
						m_command = null;
					}
				}
			}
			
			if ( m_armyState == STATE_ARMY_OCCUPY )
			{
				// city already be occupy
				if ( m_enemyUnit.GROUP == this.GROUP )
				{
					m_enemyUnit = null;
					
					m_pathBlocked = false;
					this.stopMove();
					
					m_armyState = STATE_ARMY_IDLE;
				}
				else
				{
					// stop for occupy
					if ( isUnitInRange( m_enemyUnit, OCCUPY_RANGE ) == true )
					{
						m_pathBlocked = false;
						this.stopMove();
						
						if ( m_fireColdDownCounter == 0 )
						{
							onOccupy( m_enemyUnit );
							m_fireColdDownCounter = m_fireColdDownTime;
						}
					}
					// trace the enemy
					else
					{
						//TODO 
					}
				}
			}
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			// initial the display stuff
			if ( m_group == UnitTypes.SELF_GROUP )
			{
				m_imgSoldier = new mcSoldier();
			}
			else
			{
				m_imgSoldier = new mcSoldier02();
			}
			
			m_display.addChild( m_imgSoldier );
			m_display.addChild( m_lifeBar );
			
			m_imgSoldier.rotation = 0;
			
			// enemy always show the life bar
			if ( this.GROUP != UnitTypes.SELF_GROUP )
			{
				m_lifeBar.visible = true;
			}
		}
		
		
		/**
		 * @desc	callback when object be removed
		 */
		override public function onRemove():void
		{	
			// play a boost animation on the map
			var boostAni:MovieClip = new mcBoost();
			boostAni.x = m_position.x;
			boostAni.y = m_position.y;
			m_canvas.addChild( boostAni );
			boostAni.play();
			
			super.onRemove();
		}
		
		
		/**
		 * @desc	unit changed the direction
		 * @param	newDir
		 */
		override public function onDirectionChanged( newDir:Point ):void
		{
			super.onDirectionChanged( newDir );
			
			// update the tank body rotation
			m_imgSoldier.rotation = MathCalculator.VectorToAngle( newDir );
		}
		 
		
		/**
		 * @desc	fire to the enemy
		 * @param	unit
		 */
		override public function onFire( unit:Unit ):void 
		{
			super.onFire( unit );
			
			// set the fire angle
			m_imgSoldier.rotation = MathCalculator.VectorToAngle( new Point( unit.POSITION.x - m_position.x, unit.POSITION.y - m_position.y ) );
			
			// shoot to the enemy
			var cannonBall:Cannonball = new Cannonball();
			cannonBall.SetForce( INFANTRY_FORCE );
			cannonBall.SetDest( unit.POSITION.x, unit.POSITION.y );
			
			m_unitHost.AddGameObject( cannonBall, m_position.x, m_position.y, this.GROUP );
		}
		
		
		/**
		 * @desc	occupy the city
		 * @param	unit
		 */
		public function onOccupy( unit:Unit ):void
		{
			// set the angle
			m_imgSoldier.rotation = MathCalculator.VectorToAngle( new Point( unit.POSITION.x - m_position.x, unit.POSITION.y - m_position.y ) );
			
			// shoot to occupy the city
			var occupyPoint:OccupyPoint = new OccupyPoint();
			occupyPoint.SetForce( INFANTRY_FORCE );
			occupyPoint.SetDest( unit.POSITION.x, unit.POSITION.y );
			
			m_unitHost.AddGameObject( occupyPoint, m_position.x, m_position.y , this.GROUP );
		}
		
		
		/**
		 * @desc	return a display present this unit
		 * @return
		 */
		override public function GetDisplay( group:int ):Sprite
		{
			var spr:Sprite = new Sprite();
			
			if ( m_group == UnitTypes.SELF_GROUP )
			{
				spr.addChild( new mcSoldier() );
			}
			else
			{
				spr.addChild( new mcSoldier02() );
			}
			
			return spr;
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}