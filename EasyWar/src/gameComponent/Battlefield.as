package gameComponent 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameObj.IGameObject;
	import map.GridInfo;
	import map.GridMap;
	import map.MapLoader;
	import mapItem.MapItem;
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Battlefield 
	{
		//------------------------------ static member -------------------------------------
		
		static public const UNIT_TROOP:int = 1;
		static public const UNIT_BUILDING:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_canvas:DisplayObjectContainer = null;
		protected var m_map:GridMap = null;
		protected var m_unitList:Array = null;
		protected var m_selectedUnit:Array = null;
		
		protected var m_mapCanvas:Sprite = null;
		protected var m_mapBG:Bitmap = null;
		protected var m_mapOffset:Point = new Point();
		protected var m_viewportSize:Point = new Point();
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Battlefield
		 */
		public function Battlefield() 
		{
			m_unitList = new Array();
			m_selectedUnit = new Array();
		}
		
		
		/**
		 * @desc	load the battlefield from a xml file
		 * @param	settingFile
		 */
		public function LoadFromXML( settingFile:XML ):void
		{
			//TODO 
		}
		
		
		/**
		 * @desc	set the canvas of the battlefield
		 */
		public function set CANVAS( value:DisplayObjectContainer ):void 
		{
			m_canvas = value;
		}
		
		
		/**
		 * @desc	return the selected unit type
		 */
		public function get SELECTED_UNIT():Array
		{ 
			return m_selectedUnit;
		}
		
		
		/**
		 * @desc	create a blank battlefield
		 * @param	wid
		 * @param	hei
		 */
		public function Create( wid:int, hei:int ):void
		{
			if ( wid <= 0 || hei <= 0 )
			{
				throw new Error( "[Battlefield]: create battlefield error, size is illegal" );
			}
			
			m_mapCanvas = new Sprite();
			m_canvas.addChild( m_mapCanvas );
			
			m_map = new GridMap( wid, hei );
			m_mapBG = m_map.GetMapBitmap();
			
			m_mapCanvas.addChild( m_mapBG );
		}
		
		
		/**
		 * @desc	create a random map 
		 * @param	wid
		 * @param	hei
		 */
		public function RandomCreate( wid:int, hei:int ):void
		{
			if ( wid <= 0 || hei <= 0 )
			{
				throw new Error( "[Battlefield]: create battlefield error, size is illegal" );
			}
			
			m_mapCanvas = new Sprite();
			m_canvas.addChild( m_mapCanvas );
			
			m_map = new GridMap( wid, hei );
			m_mapBG = m_map.GetMapBitmap();
			
			m_mapCanvas.addChild( m_mapBG );
		}
		
		
		/**
		 * @desc	set the viewport size
		 * @param	wid
		 * @param	hei
		 */
		public function SetViewport( wid:Number, hei:Number ):void
		{
			m_viewportSize.x = wid;
			m_viewportSize.y = hei;
		}
		
		
		/**
		 * @desc	move map
		 * @param	offsetX
		 * @param	offsetY
		 */
		public function MoveMap( offsetX:Number, offsetY:Number ):void
		{
			m_mapOffset.x += offsetX;
			m_mapOffset.y += offsetY;
			
			if ( m_mapOffset.x > 0 )
			{
				m_mapOffset.x = 0;
			}
			
			if ( m_mapOffset.y > 0 )
			{
				m_mapOffset.y = 0;
			}
			
			if ( m_mapOffset.x < ( m_viewportSize.x - m_map.MAP_SIZE_WIDTH ) )
			{
				m_mapOffset.x = m_viewportSize.x - m_map.MAP_SIZE_WIDTH;
			}
			
			if ( m_mapOffset.y < ( m_viewportSize.y - m_map.MAP_SIZE_HEIGHT ) )
			{
				m_mapOffset.y = m_viewportSize.y - m_map.MAP_SIZE_HEIGHT;
			}
			
			m_mapCanvas.x = m_mapOffset.x;
			m_mapCanvas.y = m_mapOffset.y;
		}
		
		
		/**
		 * @desc	add game object	to the map ( grid coordinate )
		 * @param	gameObj
		 */
		public function AddGameObject( unit:MapItem, xPos:int, yPos:int ):void
		{
			unit.SetMap( m_map );
			unit.SetCanvas( m_mapCanvas );
			unit.SetPosition( xPos * m_map.GRID_SIZE, yPos * m_map.GRID_SIZE );
			unit.onAdd();
			
			m_unitList.push( unit );
		}
		
		
		/**
		 * @desc	update
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			for ( var i:int = 0; i < m_unitList.length; i++ )
			{
				m_unitList[i].Update( elapsed );
			}
			
			//TODO 
		}
		
		
		/**
		 * @desc	return the grid map
		 */
		public function get MAP():GridMap { return m_map; }
		
		
		/**
		 * @desc	select the army or building
		 * @param	rect
		 * @return
		 */
		public function SelectUnit( rect:Rectangle ):int
		{
			var selectCnt:int = 0;
			
			cleanCurrentSelect();
			
			var i:int;
			var j:int;
			
			var startGridX:int = rect.left / m_map.GRID_SIZE;
			var startGridY:int = rect.top / m_map.GRID_SIZE;
			
			var endGridX:int = ( rect.left + rect.width ) / m_map.GRID_SIZE;
			var endGridY:int = ( rect.top + rect.height ) / m_map.GRID_SIZE;
			
			for ( i = startGridX; i <= endGridX; i++ )
			{
				for ( j = startGridY; j <= endGridY; j++ )
				{
					var gridInfo:GridInfo = m_map.GetGridInfo( i, j );
					
					if ( gridInfo._type == GridInfo.UNIT )
					{
						gridInfo._coverItem.SELECTED = true;
						m_selectedUnit.push( gridInfo._coverItem );
						
						selectCnt++;
					}
				}
			}
			
			return selectCnt;
		}
		
		//------------------------------ private function ----------------------------------
		
		// clean the current selected unit
		protected function cleanCurrentSelect():void
		{
			for ( var i:int = 0; i < m_selectedUnit.length; i++ )
			{
				( m_selectedUnit[i] as MapItem ).SELECTED = false;
			}
			
			m_selectedUnit = new Array();
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}