package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameObj.Unit;
	import gameObj.UnitTypes;
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
		static protected const TANK_LIFE_VALUE:Number = 160.0;
		static protected const TANK_FIRINGRANGE:Number = 180;
		
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
			m_firingRange = TANK_FIRINGRANGE;
			m_maxLifeValue = TANK_LIFE_VALUE;
			m_lifeValue = m_maxLifeValue;
			
			m_type = UnitTypes.TYPE_TANK;
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
			
			m_imgGun.rotation = 10;
			
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
		
		
		/**
		 * @desc	return a display present this unit
		 * @return
		 */
		override public function GetDisplay( group:int ):Sprite
		{
			var spr:Sprite = new Sprite();
			
			if ( m_group == UnitTypes.SELF_GROUP )
			{
				spr.addChild( new mcTankBody() );
				spr.addChild( new mcTankGun() );
			}
			else
			{
				spr.addChild( new mcTankBody02() );
				spr.addChild( new mcTankGun02() );
			}
			
			return spr;
		}
		
		
		//------------------------------ private function ----------------------------------
		
		
		// set tank display
		protected function setTankDisplay():void
		{
			if ( m_group == UnitTypes.SELF_GROUP )
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