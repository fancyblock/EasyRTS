package map 
{
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class GridMap 
	{
		//------------------------------ static member -------------------------------------
		
		static public const MAX_SIZE:int = 160;
		static public const DEFAULT_GRID_SIZE:Number = 32;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_width:int = 0;
		protected var m_height:int = 0;
		protected var m_gridSize:Number = DEFAULT_GRID_SIZE;
		
		protected var m_mapData:Vector.<Vector.<GridInfo>> = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of GridMap
		 */
		public function GridMap( wid:int, hei:int )
		{
			// judge if the size if out of range
			if ( wid > MAX_SIZE || hei > MAX_SIZE || wid <= 0 || hei <= 0 )
			{
				throw new Error( "[Error]: Size of grid map is out of range" );
				return;
			}
			
			m_width = wid;
			m_height = hei;
			
			// initial the map data
			m_mapData = new Vector.<Vector.<GridInfo>>();
			for ( var i:int = 0; i < wid; i++ )
			{
				m_mapData[i] = new Vector.<GridInfo>();
				
				for ( var j:int = 0; j < hei; j++ )
				{
					m_mapData[i][j] = new GridInfo();
					m_mapData[i][j]._x = i;
					m_mapData[i][j]._y = j;
				}
			}
			
		}
		
		
		/**
		 * @desc	getter of the map size
		 */
		public function get WIDTH():int	{ return m_width; }
		public function get HEIGHT():int { return m_height; }
		
		
		/**
		 * @desc	return the GridInfo struct in map
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function GetGridInfo( x:int, y:int ):GridInfo
		{
			var gridInfo:GridInfo = null;
			
			if ( x >= 0 && y >= 0 && x < m_width && y < m_height )
			{
				gridInfo = m_mapData[x][y];
			}
			
			return gridInfo;
		}
		
		
		/**
		 * @desc	getter & setter of the grid size
		 */
		public function get GRID_SIZE():Number { return m_gridSize; }
		public function set GRID_SIZE( gridSize:Number ):void 
		{
			if ( gridSize <= 0 )
			{
				throw new Error( "[Error]: GridMap  grid size must be bigger than 0" );
			}
			
			m_gridSize = gridSize;
		}
		
		
		/**
		 * @desc	return the gridInfo of the specific position 
		 * @param	xPos
		 * @param	yPos
		 * @return
		 */
		public function GetPositionGrid( xPos:Number, yPos:Number ):GridInfo
		{
			var gridInfo:GridInfo = null;
			
			var posWid:Number = this.m_width * this.m_gridSize;
			var posHei:Number = this.m_height * this.m_gridSize;
			
			if ( xPos >= 0 && yPos >= 0 && xPos < posWid && yPos < posHei )
			{
				gridInfo = this.GetGridInfo( xPos / m_gridSize, yPos / m_gridSize );
			}
			
			return gridInfo;
		}
		
		
		/**
		 * @desc	return the mapItem of the specific position
		 * @param	xPos
		 * @param	yPos
		 * @return
		 */
		public function GetPositionItem( xPos:Number, yPos:Number ):MapItem
		{
			var mapItem:MapItem = null;
			
			var gridInfo:GridInfo = this.GetPositionGrid( xPos, yPos );
			
			if ( gridInfo != null )
			{
				mapItem = gridInfo._coverItem;
			}
			
			return mapItem;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback ----------------------------------- 
		
	}

}