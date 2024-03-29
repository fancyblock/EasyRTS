package map 
{
	import flash.display.ActionScriptVersion;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class GridMap 
	{
		//------------------------------ static member -------------------------------------
		
		static public const MAX_SIZE:int = 120;
		static public const DEFAULT_GRID_SIZE:Number = 32;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_width:int = 0;
		protected var m_height:int = 0;
		protected var m_gridSize:Number = DEFAULT_GRID_SIZE;
		protected var m_mapSize:Point = new Point();
		
		protected var m_mapData:Vector.<Vector.<GridInfo>> = null;
		
		protected var m_offsets:Array = new Array( new Point(0, 0), new Point(1, 0), new Point(1, 1), 
													new Point(0, 1), new Point( -1, 1), new Point( -1, 0), 
													new Point( -1, -1), new Point(0, -1), new Point(1, -1) );
													
		protected var m_miniMap:MiniMap = null;
		
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
					m_mapData[i][j]._map = this;
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
		 * @desc	getter & setter of the minimap
		 */
		public function get MINI_MAP():MiniMap { return m_miniMap; }
		public function set MINI_MAP( value:MiniMap ):void 
		{ 
			m_miniMap = value;
			
			if ( m_miniMap != null )
			{
				m_miniMap.CreateMapBG( this );
			}
		}
		
		
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
			
			var gridPosX:int = xPos / m_gridSize;
			var gridPosY:int = yPos / m_gridSize;
			
			var i:int;
			var unitList:Array = new Array();
			
			// get the grid unit in closed 9 grids
			for ( i = 0; i < m_offsets.length; i++ )
			{
				var gridInfo:GridInfo = this.GetGridInfo( gridPosX + m_offsets[i].x, gridPosY + m_offsets[i].y );
				
				if ( gridInfo != null )
				{
					if ( gridInfo._coverItem != null )
					{
						unitList.push( gridInfo._coverItem );
					}
				}
			}
			
			var radius:Number = this.GRID_SIZE * 0.5;
			var lenVec:Point = new Point();
			
			// get the close unit
			for ( i = 0; i < unitList.length; i++ )
			{
				var unit:MapItem = unitList[i];
				
				lenVec.x = unit.POSITION.x - xPos;
				lenVec.y = unit.POSITION.y - yPos;
				
				if ( lenVec.length <= radius )
				{
					mapItem = unit;
					break;
				}
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
			var blankTile:Sprite = new mcBlankTile();
			var translate:Matrix = new Matrix();
			
			for ( var i:int = 0; i < m_width; i++ )
			{
				for ( var j:int = 0; j < m_height; j++ )
				{
					translate.tx = i * GRID_SIZE;
					translate.ty = j * GRID_SIZE;
						
					if ( m_mapData[i][j]._type == GridInfo.BLOCK )
					{
						bitmapData.draw( blockTile, translate );
					}
					else
					{
						bitmapData.draw( blankTile, translate );
					}
				}
			}
			
			bmp.bitmapData = bitmapData;
			
			return bmp;
		}
		
		
		/**
		 * @desc	[For Debug]
		 * @param	bmp
		 * @param	region
		 */
		public function UpdateMapBitmap( bmp:Bitmap, region:Rectangle ):void
		{
			var bitmapData:BitmapData = bmp.bitmapData;
			
			var translate:Matrix = new Matrix();
			
			var startPosX:int = region.x / m_gridSize;
			var startPosY:int = region.y / m_gridSize;
			var endPosX:int = region.right / m_gridSize;
			var endPosY:int = region.bottom / m_gridSize;
			
			var blockTile:Sprite = new mcBlockTile();
			var blankTile:Sprite = new mcBlankTile();
			var holdTile:Sprite = new mcHoldTile();
			var unitTile:Sprite = new mcUnitTile();
			
			for ( var i:int = startPosX; i <= endPosX; i++ )
			{
				for ( var j:int = startPosY; j <= endPosY; j++ )
				{
					translate.tx = i * GRID_SIZE;
					translate.ty = j * GRID_SIZE;
					
					if ( m_mapData[i][j]._type == GridInfo.BLOCK )
					{
						bitmapData.draw( blockTile, translate );
					}
					
					if( m_mapData[i][j]._type == GridInfo.BLANK )
					{
						bitmapData.draw( blankTile, translate );
					}
					
					if ( m_mapData[i][j]._type == GridInfo.HOLD )
					{
						bitmapData.draw( holdTile, translate );
					}
					
					if ( m_mapData[i][j]._type == GridInfo.UNIT )
					{
						bitmapData.draw( unitTile, translate );
					}
				}
			}
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback ----------------------------------- 
		
	}

}