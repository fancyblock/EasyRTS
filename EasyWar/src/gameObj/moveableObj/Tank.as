package gameObj.moveableObj 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import gameComponent.LifeBar;
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
		
		protected var m_lifeBar:LifeBar = null;
		
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
			
			// initial the display stuff
			m_lifeBar = new LifeBar();
			m_lifeBar.x = 0;
			m_lifeBar.y = 0;
			
			m_display = new Sprite();
			m_imgBody = new mcTankBody();
			m_imgGun = new mcTankGun();
			
			m_display.addChild( m_imgBody );
			m_display.addChild( m_imgGun );
			m_display.addChild( m_lifeBar );
			
			this.m_canvas.addChild( m_display );
			
			m_display.x = this.m_pos.x;
			m_display.y = this.m_pos.y;
			
			m_lifeBar.visible = false;
			
			//TODO 
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
		
		
		override public function set SELECTED( value:Boolean ):void
		{ 
			super.SELECTED = value;
			
			m_lifeBar.visible = this.SELECTED;
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}