package map 
{
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MapLoader 
	{
		//--------------------------------------------- static member -------------------------------------------------
		
		static private var s_flag:Boolean = false;
		static private var s_instance:MapLoader = null;
		
		//-------------------------------------------- static function ------------------------------------------------
		
		/**
		* @desc	return the singleton of MapLoader
		*/
		static public function get SINGLETON():MapLoader
		{
			if ( s_instance == null )
			{
				s_flag = true;
				s_instance = new MapLoader();
				s_flag = false;
			}
			
			return s_instance;
		}
		
		//-------------------------------------------- public function ------------------------------------------------
		
		/**
		 * @desc	constructor of MapLoader
		 */
		public function MapLoader() 
		{
			if ( s_flag == false )
			{
				throw new Error( "[Error] singleton can not be new directly" );
			}
		}
		
		
		/**
		 * @desc	load the map info from xml and then return the GridMap object
		 * @param	xml
		 * @return
		 */
		public function LoadFromXML( xml:XML ):GridMap
		{
			var gridMap:GridMap = null;
			
			//TODO 
			
			return gridMap;
		}
		
		
		/**
		 * @desc	generate a random map
		 * @param	wid
		 * @param	hei
		 * @return
		 */
		public function GenRandomMap( wid:int, hei:int ):GridMap
		{
			var gridMap:GridMap = new GridMap( wid, hei );
			
			var gridCnt:int = wid * hei;
			var blockCnt:int = gridCnt / 50;
			
			for ( var i:int = 0; i < blockCnt; i++ )
			{
				var randX:int = Math.random() * wid;
				var randY:int = Math.random() * hei;
				
				//[hack]
				if ( randX == 5 && randY == 5 )
				{
					continue;
				}
				//[hack]
				
				addBlock( gridMap, randX, randY, Math.random() * 5 + 3 );
			}
			
			return gridMap;
		}
		
		
		//-------------------------- private functions -------------------------
		
		// add block on map
		protected function addBlock( theMap:GridMap, posX:int, posY:int, cnt:int ):void
		{
			theMap.GetGridInfo( posX, posY ).SetBlock();
			
			//TODO 
		}
		
	}

}