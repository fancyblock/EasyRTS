package gameComponent 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameObj.building.Arsenal;
	import gameObj.building.City;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	import map.GridInfo;
	import map.GridMap;
	import map.MiniMap;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Battlefield implements IUnitHost
	{
		//------------------------------ static member -------------------------------------
		
		static public const UNIT_TROOP:int = 1;
		static public const UNIT_BUILDING:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_canvas:DisplayObjectContainer = null;
		protected var m_map:GridMap = null;
		protected var m_miniMap:MiniMap = null;
		protected var m_unitList:Array = null;
		protected var m_selectedUnits:Array = null;
		
		protected var m_mapCanvas:Sprite = null;
		protected var m_mapBG:Bitmap = null;
		protected var m_mapOffset:Point = new Point();
		protected var m_viewportSize:Point = new Point();
		
		protected var m_playerCommand:Command = null;
		
		protected var m_currentBuilding:Arsenal = null;
		
		protected var m_selfCityCnt:int = 0;
		protected var m_enemyCityCnt:int = 0;
		protected var m_selfTroopCnt:int = 0;
		protected var m_enemyTroopCnt:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Battlefield
		 */
		public function Battlefield() 
		{
			m_unitList = new Array();
			m_selectedUnits = new Array();
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
			return m_selectedUnits;
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
		 * @desc	getter of the mini map
		 */
		public function get MINI_MAP():MiniMap { return m_miniMap; }
		
		
		/**
		 * @desc	create a random map
		 * @param	wid
		 * @param	hei
		 */
		public function CreateRandomMap( wid:int, hei:int ):void
		{
			if ( wid <= 0 || hei <= 0 )
			{
				throw new Error( "[Battlefield]: create battlefield error, size is illegal" );
			}
			
			m_miniMap = new MiniMap( wid, hei );
			
			m_mapCanvas = new Sprite();
			m_canvas.addChild( m_mapCanvas );
			
			m_map = new GridMap( wid, hei );
			
			//add city & block
			var gridCnt:int = wid * hei;
			var blockCnt:int = gridCnt / 50;
			var cityList:Array = new Array();
			var i:int;
			
			for ( i = 0; i < blockCnt; i++ )
			{
				var randX:int = Math.random() * wid;
				var randY:int = Math.random() * hei;
				var gridInfo:GridInfo = m_map.GetGridInfo( randX, randY );
				
				if ( gridInfo._type == GridInfo.BLANK )
				{
					if ( Math.random() < 0.3 )
					{
						cityList.push( new Point( (Number)(randX + 0.5) * MAP.GRID_SIZE, (Number)(randY + 0.5) * MAP.GRID_SIZE ) );
					}
					else
					{
						gridInfo.SetBlock();
					}
				}
			}
			
			m_map.MINI_MAP = m_miniMap;
			
			m_mapBG = m_map.GetMapBitmap();
			m_mapCanvas.addChild( m_mapBG );
			
			// add citys
			for ( i = 0; i < cityList.length; i++ )
			{
				AddGameObject( new City, cityList[i].x, cityList[i].y, UnitTypes.NEUTRAL_GROUP );
			}
			
			AddGameObject( new Arsenal(), 5.5 * MAP.GRID_SIZE, 5.5 * MAP.GRID_SIZE, UnitTypes.SELF_GROUP );
			AddGameObject( new Arsenal(), (Number)(wid - 5.5) * MAP.GRID_SIZE, (Number)(hei - 5.5) * MAP.GRID_SIZE, UnitTypes.ENEMY_GROUP );
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
		public function AddGameObject( unit:Unit, xPos:Number, yPos:Number, group:int ):void
		{
			unit.SetUnitHost( this );
			unit.SetMap( m_map );
			unit.SetCanvas( m_mapCanvas );
			unit.GROUP = group;
			unit.SetPosition( xPos, yPos );
			unit.onAdd();
			
			m_unitList.push( unit );
		}
		
		
		/**
		 * @desc	getter of the self info
		 */
		public function get SELF_CITY_CNT():int { return m_selfCityCnt; }
		public function get SELF_TROOP_CNT():int { return m_selfTroopCnt; }
		
		
		/**
		 * @desc	update
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			m_selfCityCnt = 0;
			m_enemyCityCnt = 0;
			m_selfTroopCnt = 0;
			m_enemyTroopCnt = 0;
			
			var i:int;
			var removeList:Array = new Array();
			
			for ( i = 0; i < m_unitList.length; i++ )
			{
				var unit:Unit = m_unitList[i];
				
				if ( unit.GROUP == UnitTypes.SELF_GROUP )
				{
					if ( unit.IsTroop() )
					{
						m_selfTroopCnt++;
					}
					if ( unit.TYPE == UnitTypes.TYPE_CITY )
					{
						m_selfCityCnt++;
					}
				}
				if ( unit.GROUP == UnitTypes.ENEMY_GROUP )
				{
					if ( unit.IsTroop() )
					{
						m_enemyTroopCnt++;
					}
					if ( unit.TYPE == UnitTypes.TYPE_CITY )
					{
						m_enemyCityCnt++;
					}
				}
				
				unit.Update( elapsed );
				
				if ( unit.STATE == Unit.STATE_DEAD )
				{
					unit.STATE = Unit.STATE_REMOVE;
				}
				else if ( unit.STATE == Unit.STATE_REMOVE )
				{
					removeList.push( unit );
				}
				
			}
			
			// remove the unit
			for ( i = 0; i < removeList.length; i++ )
			{
				removeList[i].onRemove();
				m_unitList.splice( m_unitList.indexOf( removeList[i] ), 1 );
			}
			
			
			//----------------- debug code -------------------
			
			if ( GlobalWork.DEBUG_MODE == true )
			{
				m_map.UpdateMapBitmap( m_mapBG, new Rectangle( -m_mapOffset.x, -m_mapOffset.y, m_viewportSize.x, m_viewportSize.y ) );
			}
			
			//----------------- debug code -------------------
			
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
			
			var selectedBuilding:Array = new Array();
			
			for ( i = startGridX; i <= endGridX; i++ )
			{
				for ( j = startGridY; j <= endGridY; j++ )
				{
					var gridInfo:GridInfo = m_map.GetGridInfo( i, j );
					
					if ( gridInfo._type == GridInfo.UNIT )
					{
						if ( gridInfo._coverItem.GROUP == group )
						{
							if ( gridInfo._coverItem.IsTroop() == false )
							{
								selectedBuilding.push( gridInfo._coverItem );
							}
							
							unitList.push( gridInfo._coverItem );
						}
					}
				}
			}
			
			if ( unitList.length > 0 )
			{
				if ( selectedBuilding.length > 0 )
				{
					// contain troops
					if ( unitList.length > selectedBuilding.length )
					{
						// remove all the building item from the selected list
						for ( i = 0; i < selectedBuilding.length; i++ )
						{
							unitList.splice( unitList.indexOf( selectedBuilding[i] ), 1 );
						}
					}
					// more than one buildings be selected
					else if ( selectedBuilding.length > 1 )
					{
						return 0;
					}
				}
				
				cleanCurrentSelect();
				m_selectedUnits = unitList;
				
				for ( i = 0; i < m_selectedUnits.length; i++ )
				{
					m_selectedUnits[i].SELECTED = true;
				}
				
				updateSelectState();
				
				return m_selectedUnits.length;
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
			m_selectedUnits.push( unit );
			
			updateSelectState();
			
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
			if ( m_selectedUnits.length == 0 )
			{
				return;
			}
			
			var mapX:Number = xPos - m_mapOffset.x;
			var mapY:Number = yPos - m_mapOffset.y;
			
			var mapItem:mapItem.MapItem = m_map.GetPositionItem( mapX, mapY );
			var gridInfo:GridInfo = m_map.GetPositionGrid( mapX, mapY );
			
			sendOrderByClickGrid( mapItem, gridInfo );
		}
		
		
		/**
		 * @desc	send the command by grid coordinate
		 * @param	xPos
		 * @param	yPos
		 */
		public function OrderSpotGrid( xPos:int, yPos:int ):void
		{
			// judge if the any unit be selected 
			if ( m_selectedUnits.length == 0 )
			{
				return;
			}
			
			var gridInfo:GridInfo = m_map.GetGridInfo( xPos, yPos );
			var mapItem:MapItem = gridInfo._coverItem;
			
			sendOrderByClickGrid( mapItem, gridInfo );
		}
		
		
		/**
		 * @desc	return the current selected building ( for manufacture the troop )
		 */
		public function get SELECTED_BUILDING():Arsenal
		{
			return m_currentBuilding;
		}
		
		
		//------------------------------ private function ----------------------------------
		
		
		// update the select state
		protected function updateSelectState():void
		{
			m_currentBuilding = null;
			
			if ( m_selectedUnits.length == 1 )
			{
				if ( ( m_selectedUnits[0] as Unit ).TYPE == UnitTypes.TYPE_ARSENAL )
				{
					m_currentBuilding = m_selectedUnits[0];
				}
			}
		}
		
		// send order
		protected function sendOrderByClickGrid( mapUnit:MapItem, gridInfo:GridInfo ):void
		{
			var command:Command = new Command();
			
			// move to that position
			if ( gridInfo._type == GridInfo.BLANK )
			{
				command._type = Command.CMD_MOVE;
				command._destGrid = gridInfo;
			}
			else if ( gridInfo._type == GridInfo.BLOCK )
			{
				//TODO 
				
				return;
			}
			else if ( mapUnit != null )
			{
				// attack the enemy
				if ( mapUnit.GROUP == UnitTypes.ENEMY_GROUP && mapUnit.TYPE != UnitTypes.TYPE_CITY )
				{
					command._type = Command.CMD_ATTACK;
					command._aim = mapUnit;
				}
				// occupy the city ( )
				else if ( mapUnit.GROUP != UnitTypes.SELF_GROUP && mapUnit.TYPE == UnitTypes.TYPE_CITY )
				{
					command._type = Command.CMD_OCCUPY;
					command._aim = mapUnit;
				}
			}
			else
			{
				return;			// dont need to send the order in this situation
			}
			
			// send the command to all selected unit
			for ( var i:int = 0; i < m_selectedUnits.length; i++ )
			{
				( m_selectedUnits[i] as MapItem ).SendCommand( command );
			}
		}
		
		// clean the current selected unit
		protected function cleanCurrentSelect():void
		{
			for ( var i:int = 0; i < m_selectedUnits.length; i++ )
			{
				( m_selectedUnits[i] as MapItem ).SELECTED = false;
			}
			
			m_selectedUnits = new Array();
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}