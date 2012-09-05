package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import gameComponent.Command;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	import gameObj.weapons.Cannonball;
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
					//TODO 
					
					m_command = null;
				}
			}
			
			//TODO 
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			// initial the display stuff
			m_imgSoldier = new mcSoldier();
			
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
			
			// shoot to the enemy
			var cannonBall:Cannonball = new Cannonball();
			cannonBall.SetForce( INFANTRY_FORCE );
			cannonBall.SetDest( unit.POSITION.x, unit.POSITION.y );
			
			m_unitHost.AddGameObject( cannonBall, m_position.x, m_position.y, this.GROUP );
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}