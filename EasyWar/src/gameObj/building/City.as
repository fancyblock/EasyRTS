package gameObj.building 
{
	import gameObj.UnitTypes;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class City extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of City
		 */
		public function City() 
		{
			super();
			
			m_type = UnitTypes.TYPE_CITY;
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			m_display.addChild( new mcCity01() );
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}