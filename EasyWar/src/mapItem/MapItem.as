package mapItem 
{
	import flash.geom.Point;
	import map.GridMap;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_gridPos:Point = null;			// the pos on grid
		protected var m_gridSize:Point = null;			// the size on grid
		
		protected var m_pos:Point = null;
		protected var m_size:Point = null;
		
		protected var m_map:GridMap = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_gridPos = new Point();
			m_gridSize = new Point();
			
			m_pos = new Point();
			m_size = new Point();
		}
		
		
		/**
		 * @desc	set the item owner map
		 * @param	map
		 */
		public function SetMap( map:GridMap ):void
		{
			m_map = map;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}