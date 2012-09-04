package gameObj.building 
{
	import gameObj.UnitTypes;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Arsenal extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of Arsenal
		 */
		public function Arsenal() 
		{
			super();
			
			m_type = UnitTypes.TYPE_ARSENAL;
		}
		
		
		/**
		 * @desc	update 
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			//TODO
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			m_display.addChild( new mcFactory01() );
			m_display.addChild( m_lifeBar );
		}
		
		
		/**
		 * @desc	callback when remove from map
		 */
		override public function onRemove():void
		{
			//TODO 
			
			super.onRemove();
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}