package mapItem 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
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
		static public var STATE_SLEEP:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_gridPos:Point = null;			// the pos on grid
		
		protected var m_pos:Point = null;
		
		protected var m_map:GridMap = null;
		protected var m_isClingToGrid:Boolean = true;
		protected var m_group:int = 0;
		protected var m_type:int = 0;
		protected var m_state:int = 0;
		protected var m_isSelected:Boolean = false;
		
		protected var m_canvas:DisplayObjectContainer = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_gridPos = new Point();
			
			m_pos = new Point();
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
		 * @desc	setter & getter of the cling property
		 */
		public function set CLING_TO_GRID( value:Boolean ):void { m_isClingToGrid = value; }
		public function get CLING_TO_GRID():Boolean { return m_isClingToGrid; }
		
		
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
		 * @desc	set the grid position 
		 * @param	xPos
		 * @param	yPos
		 * @param	sizeWid
		 * @param	sizeHei
		 */
		public function SetGridPosition( xPos:int, yPos:int ):void
		{
			m_gridPos.x = xPos;
			m_gridPos.y = yPos;
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
			if ( m_isClingToGrid == true )
			{
				gridInfo = m_map.GetGridInfo( m_gridPos.x, m_gridPos.y );
				
				// the grid already be occupy
				if ( gridInfo._type != GridInfo.BLANK )
				{
					return false;
				}
			}
			
			// set the new position
			m_pos.x = xPos;
			m_pos.y = yPos;
			
			// set the map flag & update the grid position
			if ( m_isClingToGrid == true )
			{	
				var newGridPosX:int = m_pos.x / m_map.GRID_SIZE;
				var newGridPosY:int = m_pos.y / m_map.GRID_SIZE;
				
				if ( newGridPosX != (int)(m_gridPos.x) || newGridPosY != (int)(m_gridPos.y) )
				{
					// clean the map first
					gridInfo = m_map.GetGridInfo( m_gridPos.x, m_gridPos.y );
					gridInfo.SetBlank();
					
					// set the new item info
					gridInfo = m_map.GetGridInfo( newGridPosX, newGridPosY );
					gridInfo.SetMapItem( this );
					
					m_gridPos.x = newGridPosX;
					m_gridPos.y = newGridPosY;
				}
			}
			
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