package gameComponent 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class LifeBar extends Sprite
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_lifeInc:Sprite = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of LifeBar
		 */
		public function LifeBar() 
		{
			var lifeBarRes:Sprite = new mcLifeBar();
			
			m_lifeInc = lifeBarRes.getChildByName( "mcLifeInc" ) as Sprite;
			
			lifeBarRes.x = 0;
			lifeBarRes.y = 0;
			this.addChild( lifeBarRes );
		}
		
		
		/**
		 * @desc	set the life
		 * @param	percent
		 */
		public function SetLife( percent:Number ):void
		{
			m_lifeInc.scaleX = percent;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}