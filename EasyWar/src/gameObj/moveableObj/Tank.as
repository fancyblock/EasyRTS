package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Tank extends Army 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const TANK_SPEED:Number = 5.0;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_display:Sprite = null;
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
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			// update the display stuff
			m_display.x = this.POSITION.x;
			m_display.y = this.POSITION.y;
			
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
			
			this.m_canvas.addChild( m_display );
			
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
			
			this.m_canvas.removeChild( m_display );
			
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
		
		
		//------------------------------ private function ----------------------------------
		
		
		// set tank display
		protected function setTankDisplay():void
		{
			m_display = new Sprite();
			
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