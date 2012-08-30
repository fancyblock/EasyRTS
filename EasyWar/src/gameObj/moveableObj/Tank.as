package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Tank extends MoveableItem 
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
			
			//TODO 
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			m_display = new Sprite();
			m_imgBody = new mcTankBody();
			m_imgGun = new mcTankGun();
			
			m_display.addChild( m_imgBody );
			m_display.addChild( m_imgGun );
			
			this.m_canvas.addChild( m_display );
			
			m_display.x = this.m_pos.x;
			m_display.y = this.m_pos.y;
		}
		
		
		/**
		 * @desc	callback when object be removed
		 */
		override public function onRemove():void
		{
			super.onRemove();
			
			//TODO
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}