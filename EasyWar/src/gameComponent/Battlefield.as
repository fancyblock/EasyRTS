package gameComponent 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import map.GridInfo;
	import map.GridMap;
	import map.MapLoader;
	import mapItem.MapItem;
	
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
		
		protected var m_playerCommand:Command = null;
		
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
		 * @desc	return the map offset
		 */
		public function get MAP_OFFSET():Point
		{
			return m_mapOffset;
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
			
			m_map = MapLoader.SINGLETON.GenRandomMap( wid, hei );
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
		public function AddGameObject( unit:MapItem, xPos:int, yPos:int, group:int = 0 ):void
		{
			unit.SetMap( m_map );
			unit.SetCanvas( m_mapCanvas );
			unit.GROUP = group;
			unit.SetPosition( ( xPos + 0.5 ) * m_map.GRID_SIZE, ( yPos + 0.5 ) * m_map.GRID_SIZE );
			unit.onAdd();
			
			m_unitList.push( unit );
		}
		
		
		/**
		 * @desc	update
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			var deadList:Array = new Array();
			
			for ( var i:int = 0; i < m_unitList.length; i++ )
			{
				m_unitList[i].Update( elapsed );
				
				if ( ( m_unitList[i] as MapItem ).STATE == MapItem.STATE_DEAD )
				{
					deadList.push( m_unitList[i] );
				}
			}
			
			// clean the dead item
			//TODO 
		}
		
		
		/**
		 * @desc	return the grid map
		 */
		public function get MAP():GridMap { return m_map; }
		
		
		/**
		 * @desc	select the army or building
		 * @param	rect
		 * @param	group
		 * @return
		 */
		public function SelectUnits( rect:Rectangle, group:int ):int
		{
			var i:int;
			var j:int;
			var unitList:Array = new Array();
			
			var startGridX:int = ( rect.left - m_mapOffset.x ) / m_map.GRID_SIZE;
			var startGridY:int = ( rect.top - m_mapOffset.y ) / m_map.GRID_SIZE;
			
			var endGridX:int = ( rect.left + rect.width - m_mapOffset.x ) / m_map.GRID_SIZE;
			var endGridY:int = ( rect.top + rect.height - m_mapOffset.y ) / m_map.GRID_SIZE;
			
			for ( i = startGridX; i <= endGridX; i++ )
			{
				for ( j = startGridY; j <= endGridY; j++ )
				{
					var gridInfo:GridInfo = m_map.GetGridInfo( i, j );
					
					if ( gridInfo._type == GridInfo.UNIT )
					{
						if ( gridInfo._coverItem.GROUP == group )
						{
							unitList.push( gridInfo._coverItem );
						}
					}
				}
			}
			
			if ( unitList.length > 0 )
			{
				cleanCurrentSelect();
				m_selectedUnit = unitList;
				
				for ( i = 0; i < m_selectedUnit.length; i++ )
				{
					m_selectedUnit[i].SELECTED = true;
				}
				
				return m_selectedUnit.length;
			}
			
			return 0;
		}
		
		
		/**
		 * @desc	select single unit
		 * @param	xPos
		 * @param	yPos
		 * @param	group
		 * @return
		 */
		public function SelectUnit( xPos:Number, yPos:Number, group:int ):Boolean
		{
			var mapX:Number = xPos - m_mapOffset.x;
			var mapY:Number = yPos - m_mapOffset.y;
			
			var unit:MapItem = m_map.GetPositionItem( mapX, mapY );
			
			if ( unit == null )
			{
				return false;
			}
			
			if ( unit.GROUP != group )
			{
				return false;
			}
			
			cleanCurrentSelect();
			
			unit.SELECTED = true;
			m_selectedUnit.push( unit );
			
			return true;
		}
		
		
		/**
		 * @desc	send the command
		 * @param	xPos
		 * @param	yPos
		 */
		public function OrderSpot( xPos:Number, yPos:Number ):void
		{
			// judge if the any unit be selected 
			if ( m_selectedUnit.length == 0 )
			{
				return;
			}
			
			var mapX:Number = xPos - m_mapOffset.x;
			var mapY:Number = yPos - m_mapOffset.y;
			
			var mapItem:mapItem.MapItem = m_map.GetPositionItem( mapX, mapY );
			var gridInfo:GridInfo = m_map.GetPositionGrid( mapX, mapY );
			
			var command:Command = new Command();
			
			if ( mapItem != null )
			{
				command._type = Command.CMD_ATTACK;
				command._aim = mapItem;
			}
			else if ( gridInfo._type == GridInfo.BLANK )
			{
				command._type = Command.CMD_MOVE;
				command._destGrid = gridInfo;
			}
			
			// send the command to all selected unit
			for ( var i:int = 0; i < m_selectedUnit.length; i++ )
			{
				( m_selectedUnit[i] as MapItem ).SendCommand( command );
			}
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