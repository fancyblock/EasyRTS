package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameObj.Unit;
	import gameObj.weapons.Cannonball;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Tank extends Army 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const TANK_SPEED:Number = 6.0;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_imgBody:MovieClip = null;
		protected var m_imgGun:Sprite = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Tank
		 */
		public function Tank() 
		{
			super();
			
			this.VELOCITY = TANK_SPEED;
			m_firingRange = 180;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			//TODO 
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			// initial the display stuff
			setTankDisplay();
			
			m_display.addChild( m_imgBody );
			m_display.addChild( m_imgGun );
			m_display.addChild( m_lifeBar );
			
			m_display.x = this.POSITION.x;
			m_display.y = this.POSITION.y;
			
			m_imgGun.rotation = 10;
			
			m_lifeBar.visible = false;
		}
		
		
		/**
		 * @desc	callback when object be removed
		 */
		override public function onRemove():void
		{
			super.onRemove();
			
			//TODO
		}
		
		
		/**
		 * @desc	unit changed the direction
		 * @param	newDir
		 */
		override public function onDirectionChanged( newDir:Point ):void
		{
			super.onDirectionChanged( newDir );
			
			// update the tank body rotation
			m_imgBody.rotation = MathCalculator.VectorToAngle( newDir );
		}
		
		
		/**
		 * @desc	fire to the enemy
		 * @param	unit
		 */
		override public function onFire( unit:Unit ):void 
		{
			super.onFire( unit );
			
			// set the tank gun angle
			m_imgGun.rotation = MathCalculator.VectorToAngle( new Point( unit.POSITION.x - m_position.x, unit.POSITION.y - m_position.y ) );
			
			// shoot to the enemy
			var cannonBall:Cannonball = new Cannonball();
			cannonBall.SetDest( unit.POSITION.x, unit.POSITION.y );
			
			m_unitHost.AddGameObject( cannonBall, m_position.x, m_position.y, this.GROUP );
		}
		
		
		//------------------------------ private function ----------------------------------
		
		
		// set tank display
		protected function setTankDisplay():void
		{
			if ( m_group == 0 )
			{
				m_imgBody = new mcTankBody();
				m_imgGun = new mcTankGun();
			}
			else
			{
				m_imgBody = new mcTankBody02();
				m_imgGun = new mcTankGun02();
			}
		}
		
		
		//------------------------------- event callback -----------------------------------
		
	}

}