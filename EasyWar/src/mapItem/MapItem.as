package mapItem 
{
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
		
		
		//------------------------------ private member ------------------------------------
		
		protected var m_gridPos:Point = null;			// the pos on grid
		protected var m_gridSize:Point = null;			// the size on grid
		
		protected var m_pos:Point = null;
		protected var m_size:Point = null;
		
		protected var m_map:GridMap = null;
		protected var m_isClingToGrid:Boolean = false;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_gridPos = new Point();
			m_gridSize = new Point();
			
			m_pos = new Point();
			m_size = new Point();
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
		 * @desc	set the grid position 
		 * @param	xPos
		 * @param	yPos
		 * @param	sizeWid
		 * @param	sizeHei
		 */
		public function SetGridPosition( xPos:int, yPos:int, sizeWid:int, sizeHei:int ):void
		{
			m_gridPos.x = xPos;
			m_gridPos.y = yPos;
			
			m_gridSize.x = sizeWid;
			m_gridSize.y = sizeHei;
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
				for ( i = m_gridPos.x; i < ( m_gridPos.x + m_gridSize.x ); i ++ )
				{
					for ( j = m_gridPos.y; j < ( m_gridPos.y + m_gridSize.y ); j++ )
					{
						gridInfo = m_map.GetGridInfo( i, j );
						
						// the grid already be occupy
						if ( gridInfo._type != GridInfo.BLANK )
						{
							return false;
						}
					}
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
					for ( i = m_gridPos.x; i < ( m_gridPos.x + m_gridSize.x ); i ++ )
					{
						for ( j = m_gridPos.y; j < ( m_gridPos.y + m_gridSize.y ); j++ )
						{
							gridInfo = m_map.GetGridInfo( i, j );
							gridInfo.SetBlank();
						}
					}
					
					// set the new item info
					for ( i = newGridPosX; i < ( newGridPosX + m_gridSize.x ); i ++ )
					{
						for ( j = newGridPosY; j < ( newGridPosY + m_gridSize.y ); j++ )
						{
							gridInfo = m_map.GetGridInfo( i, j );
							gridInfo.SetMapItem( this );
						}
					}
					
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
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}