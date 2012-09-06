package gameObj.building 
{
	import map.GridInfo;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Building extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_myGrid:GridInfo = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Building
		 */
		public function Building() 
		{
			super();
			
		}
		
		
		/**
		 * @desc	hide on map in logic
		 */
		public function HideOnMap( hide:Boolean ):void
		{
			if ( hide == true )
			{
				m_myGrid.SetBlank();
			}
			
			if ( hide == false )
			{
				m_myGrid.SetMapItem( this );
			}
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			m_myGrid = m_map.GetGridInfo( m_gridCoordinate.x, m_gridCoordinate.y );
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}