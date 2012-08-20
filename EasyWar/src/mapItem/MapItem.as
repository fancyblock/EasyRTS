package mapItem 
{
	import flash.geom.Point;
	import map.GridInfo;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_pos:Point = null;			// the pos on grid
		protected var m_size:Point = null;			// the size on grid
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_pos = new Point();
			m_size = new Point();
			
			//TODO 
			
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			//TODO 
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}