package gameObj.moveableObj 
{
	import gameComponent.LifeBar;
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Army extends MoveableItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_lifeBar:LifeBar = null;
		
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
			
			// process the order
			if ( m_command != null )
			{
				//TODO 
				
				m_command = null;
			}
			
			//TODO 
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}