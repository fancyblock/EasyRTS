package mapItem 
{
	import flash.geom.Point;
	import map.GridInfo;
	import map.pathFinding.AStar;
	import map.pathFinding.IPathFinder;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MoveableItem extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const STATE_IDLE:int = 0;
		static protected const STATE_MOVE:int = 1;
		
		static protected var PATH_FINDING:IPathFinder = null;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_velocity:Number = 0;
		protected var m_moveVector:Point = null;
		
		protected var m_path:Vector.<GridInfo> = null;
		protected var m_curDestPosition:Point = null;
		protected var m_moveState:int = 0;
		
		protected var m_curGrid:GridInfo = null;
		protected var m_nextGrid:GridInfo = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MoveableItem
		 */
		public function MoveableItem() 
		{
			super();
			
			m_moveVector = new Point();
			m_path = new Vector.<GridInfo>();
			m_curDestPosition = new Point();
			
			// inital the path finding component
			if ( PATH_FINDING == null )
			{
				PATH_FINDING = new AStar();
			}
		}
		
		
		/**
		 * @desc	getter & setter of the velocity
		 */
		public function set VELOCITY( value:Number ):void { m_velocity = value; }
		public function get VELOCITY():Number { return m_velocity; }
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			if ( m_moveState == STATE_MOVE )
			{
				//TODO 
			}
			
		}
		
		
		/**
		 * @desc	set the path
		 * @param	path
		 */
		public function SetPath( path:Vector.<GridInfo> ):void
		{
			m_path = path;
			
			// stop move
			if ( m_path == null )
			{
				m_moveState = STATE_IDLE; 
			}
			
			if ( m_path != null )
			{
				if ( m_path.length == 0 )
				{
					throw new Error( "[MoveableItem]: error, the path length is 0" );
				}
				
				followPath();
			}
		}
		
		
		/**
		 * @desc	some callback functions ( should be override )
		 */
		public function onDirectionChanged( newDir:Point ):void { }
		public function onPathBeBlock():void {}
		
		
		//------------------------------ private function ---------------------------------- 
		
		// follow the path to move the unit
		protected function followPath():void
		{
			var gridInfo:GridInfo = m_path[0];
			
			var moveSuccess:Boolean = moveToNext( gridInfo );
			
			if ( moveSuccess == true )
			{
				m_path.shift();
			}
			
			if ( moveSuccess == false )
			{
				onPathBeBlock();
			}
		}
		
		// move to next grid
		protected function moveToNext( gridInfo:GridInfo ):Boolean
		{
			if ( gridInfo._type != GridInfo.BLANK )
			{	
				return false;
			}
			
			// lock the next grid ( other unit can not move to )
			m_curGrid = m_map.GetGridInfo( this.GRID_COORDINATE.x, this.GRID_COORDINATE.y );
			m_nextGrid = gridInfo;
			m_nextGrid.SetHold( this );
			
			m_curDestPosition.x = ( gridInfo._x + 0.5 ) * m_map.GRID_SIZE;
			m_curDestPosition.y = ( gridInfo._y + 0.5 ) * m_map.GRID_SIZE;
			
			m_moveVector.x = m_curDestPosition.x - this.POSITION.x;
			m_moveVector.y = m_curDestPosition.y - this.POSITION.y;
			
			m_moveVector.normalize( 1 );
			
			onDirectionChanged( m_moveVector );
			
			m_moveState = STATE_MOVE;
			
			return true;
		}
		
		// find the path
		protected function findPath( dest:Point ):Array
		{
			if ( this.m_map == null )
			{
				throw new Error( "[MoveableItem]: Error, doesn't have owner map" );
			}
			
			var path:Array = null;
			
			path = PATH_FINDING.GetPath( m_map, m_gridCoordinate, dest );
			
			return path;
		}
		
		
		//------------------------------- event callback -----------------------------------
		
	}

}