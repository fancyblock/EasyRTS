package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Tank extends Army 
	{
		//------------------------------ static member -------------------------------------
		
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
			m_display = new Sprite();
			m_imgBody = new mcTankBody();
			m_imgGun = new mcTankGun();
			
			m_display.addChild( m_imgBody );
			m_display.addChild( m_imgGun );
			m_display.addChild( m_lifeBar );
			
			this.m_canvas.addChild( m_display );
			
			m_display.x = this.POSITION.x;
			m_display.y = this.POSITION.y;
			
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
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}