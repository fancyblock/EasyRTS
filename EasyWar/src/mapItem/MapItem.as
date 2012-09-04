package mapItem 
{
	import flash.geom.Point;
	import gameComponent.LifeBar;
	import gameObj.Unit;
	import map.GridInfo;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MapItem extends Unit
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_gridCoordinate:Point = null;
		
		protected var m_lifeBar:LifeBar = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MapItem
		 */
		public function MapItem() 
		{
			m_gridCoordinate = new Point();
			
			// initial the lifebar
			m_lifeBar = new LifeBar();
			m_lifeBar.x = 0;
			m_lifeBar.y = 0;
			m_lifeBar.visible = false;
		}
		
		
		/**
		 * @desc	getter of the grid coordinate
		 */
		public function get GRID_COORDINATE():Point
		{
			return m_gridCoordinate;
		}
		
		
		/**
		 * @desc	getter & setter of the life
		 */
		override public function set LIFE( value:Number ):void 
		{
			super.LIFE = value;
			
			m_lifeBar.SetLife( m_lifeValue / m_maxLifeValue );
		}
		
		
		/**
		 * @desc	select
		 */
		override public function set SELECTED( value:Boolean ):void
		{ 
			super.SELECTED = value;
			
			m_lifeBar.visible = this.SELECTED;
		}
		
		
		/**
		 * @desc	set the map item pos
		 * @param	xPos
		 * @param	yPos
		 * @return	success or fail
		 */
		override public function SetPosition( xPos:Number, yPos:Number ):void
		{
			if ( m_map == null )
			{
				throw new Error( "[MapItem]: can not set the position, owner map doesn't exist" );
			}
			
			var gridInfo:GridInfo = null;
			
			// judge if can set this position or not ( only for cling item )
			gridInfo = m_map.GetGridInfo( m_gridCoordinate.x, m_gridCoordinate.y );
			
			// set the new position
			m_position.x = xPos;
			m_position.y = yPos;
			
			// set the map flag & update the grid position
			var newGridPosX:int = m_position.x / m_map.GRID_SIZE;
			var newGridPosY:int = m_position.y / m_map.GRID_SIZE;
			
			m_gridCoordinate.x = newGridPosX;
			m_gridCoordinate.y = newGridPosY;
			
			// set the new item info
			gridInfo = m_map.GetGridInfo( newGridPosX, newGridPosY );
			if ( gridInfo._coverItem != null && gridInfo._coverItem != this )
			{
				throw new Error( "[MapItem]: Error Can not put on an anti-blank grid" );
			}
			gridInfo.SetMapItem( this );
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void 
		{
			super.onAdd();
			
			//TODO 
		}
		
		
		/**
		 * @desc	callback when remove from map
		 */
		override public function onRemove():void 
		{	
			// remove from map
			m_map.GetGridInfo( m_gridCoordinate.x, m_gridCoordinate.y ).SetBlank();
			
			super.onRemove();
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}