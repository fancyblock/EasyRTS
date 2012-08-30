package map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
		protected var m_mapSize:Point = new Point();
		
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
			
			m_mapSize.x = wid * m_gridSize;
			m_mapSize.y = hei * m_gridSize;
			
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
			
			m_mapSize.x = m_width * m_gridSize;
			m_mapSize.y = m_height * m_gridSize;
		}
		
		
		/**
		 * @desc	return the map size
		 */
		public function get MAP_SIZE_WIDTH():Number { return m_mapSize.x; }
		public function get MAP_SIZE_HEIGHT():Number { return m_mapSize.y; }
		
		
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
		
		
		/**
		 * @desc	return the map bitmap
		 * @return
		 */
		public function GetMapBitmap():Bitmap
		{
			var bmp:Bitmap = new Bitmap();
			
			var wid:Number = m_width * GRID_SIZE;
			var hei:Number = m_height * GRID_SIZE;
			
			var bitmapData:BitmapData = new BitmapData( wid, hei, true, 0xffffff );
			var blockTile:Sprite = new mcBlockTile();
			var translate:Matrix = new Matrix();
			
			for ( var i:int = 0; i < m_width; i++ )
			{
				for ( var j:int = 0; j < m_height; j++ )
				{
					if ( m_mapData[i][j]._type == GridInfo.BLOCK )
					{
						translate.tx = i * GRID_SIZE;
						translate.ty = j * GRID_SIZE;
						
						bitmapData.draw( blockTile, translate );
					}
				}
			}
			
			bmp.bitmapData = bitmapData;
			
			return bmp;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback ----------------------------------- 
		
	}

}