package mapItem 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import gameComponent.Command;
	import gameObj.IGameObject;
	import map.GridInfo;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MapItem implements IGameObject
	{
		//------------------------------ static member -------------------------------------
		
		static public var STATE_NROMAL:int = 0;
		static public var STATE_DEAD:int = 1;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_gridCoordinate:Point = null;
		
		protected var m_position:Point = null;
		
		protected var m_map:GridMap = null;
		protected var m_group:int = 0;
		protected var m_type:int = 0;
		protected var m_state:int = 0;
		protected var m_isSelected:Boolean = false;
		protected var m_command:Command = null;
		
		protected var m_canvas:DisplayObjectContainer = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_gridCoordinate = new Point();
			
			m_position = new Point();
			m_state = STATE_NROMAL;
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
		 * @desc	setter & getter of the group property
		 */
		public function get GROUP():int { return m_group; }
		public function set GROUP( value:int ):void { m_group = value; }
		
		
		/**
		 * @desc	setter & getter of the type property
		 */
		public function get TYPE():int { return m_type; }
		public function set TYPE( value:int ):void { m_type = value; }
		
		
		/**
		 * @desc	getter & setter of the state property
		 */
		public function set STATE( value:int ):void { m_state = value; }
		public function get STATE():int { return m_state; }
		
		
		/**
		 * @desc	getter & setter of the selected property
		 */
		public function set SELECTED( value:Boolean ):void { m_isSelected = value; }
		public function get SELECTED():Boolean { return m_isSelected; }
		
		
		/**
		 * @desc	set the command of this object
		 * @param	command
		 */
		public function SendCommand( command:Command ):void
		{
			m_command = command;
		}
		
		
		/**
		 * @desc	getter of the position property
		 */
		public function get POSITION():Point
		{
			return m_position;
		}
		
		
		/**
		 * @desc	getter of the grid coordinate
		 */
		public function get GRID_COORDINATE():Point
		{
			return m_gridCoordinate;
		}
		
		
		/**
		 * @desc	set the map item pos
		 * @param	xPos
		 * @param	yPos
		 * @return	success or fail
		 */
		public function SetPosition( xPos:Number, yPos:Number ):Boolean
		{
			if ( m_map == null )
			{
				throw new Error( "[MapItem]: can not set the position, owner map doesn't exist" );
				return;
			}
			
			var i:int;
			var j:int;
			var gridInfo:GridInfo = null;
			
			// judge if can set this position or not ( only for cling item )
			gridInfo = m_map.GetGridInfo( m_gridCoordinate.x, m_gridCoordinate.y );
			
			// the grid already be occupy
			if ( gridInfo._type != GridInfo.BLANK )
			{
				return false;
			}
			
			// set the new position
			m_position.x = xPos;
			m_position.y = yPos;
			
			// set the map flag & update the grid position
			var newGridPosX:int = m_position.x / m_map.GRID_SIZE;
			var newGridPosY:int = m_position.y / m_map.GRID_SIZE;
			
			/*
			if ( newGridPosX != (int)(m_gridCoordinate.x) || newGridPosY != (int)(m_gridCoordinate.y) )
			{
				// clean the map first
				gridInfo = m_map.GetGridInfo( m_gridCoordinate.x, m_gridCoordinate.y );
				gridInfo.SetBlank();
				
				// set the new item info
				gridInfo = m_map.GetGridInfo( newGridPosX, newGridPosY );
				gridInfo.SetMapItem( this );
				
				m_gridCoordinate.x = newGridPosX;
				m_gridCoordinate.y = newGridPosY;
			}
			*/
			
			m_gridCoordinate.x = newGridPosX;
			m_gridCoordinate.y = newGridPosY;
			
			// set the new item info
			gridInfo = m_map.GetGridInfo( newGridPosX, newGridPosY );
			gridInfo.SetMapItem( this );
			
			return true;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		public function onAdd():void
		{
			//TODO
		}
		
		
		/**
		 * @desc	callback when object be removed
		 */
		public function onRemove():void
		{
			//TODO
		}
		
		
		/**
		 * @desc	set canvas
		 * @param	canvas
		 */
		public function SetCanvas( canvas:DisplayObjectContainer ):void
		{
			m_canvas = canvas;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}