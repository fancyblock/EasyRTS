package mapItem 
{
	import flash.geom.Point;
	import map.GridInfo;
	import map.pathFinding.AStar;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MoveableItem extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const STATE_IDLE:int = 0;
		static protected const STATE_MOVE:int = 1;
		
		//------------------------------ private member ------------------------------------
		
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
			
			m_moveState = STATE_IDLE;
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
				var distance:Point = m_curDestPosition.subtract( m_position );
				
				// arrive the dest
				if ( distance.length <= ( m_velocity * 0.5 ) )
				{
					setToPosition();
					
					if ( m_path.length == 0 )
					{
						m_moveState = STATE_IDLE;
						onArriveDest();
					}
					else 
					{
						followPath();
					}
				}
				// not arrive 
				else
				{
					var offsetX:Number = m_velocity * m_moveVector.x;
					var offsetY:Number = m_velocity * m_moveVector.y;
					
					m_position.x += offsetX;
					m_position.y += offsetY;
				}
			}
			
		}
		
		
		/**
		 * @desc	getter & setter of the PATH
		 */
		public function get PATH():Vector.<GridInfo> { return m_path; }
		public function set PATH( path:Vector.<GridInfo> ):void
		{
			m_path = path;
			
			// error
			if ( m_path == null )
			{
				throw new Error( "[MoveableItem]: the path can not be null" );
			}
			
			if ( m_path != null )
			{
				if ( m_path.length == 0 )
				{
					throw new Error( "[MoveableItem]: error, the path length is 0" );
				}
				
				if ( m_moveState == STATE_MOVE )
				{
					setToPosition();
				}
				
				followPath();
			}
		}
		
		
		/**
		 * @desc	some callback functions ( should be override )
		 */
		public function onDirectionChanged( newDir:Point ):void { }
		public function onPathBeBlock():void { }
		public function onArriveDest():void { }
		
		
		//------------------------------ private function ---------------------------------- 
		
		// set to position
		protected function setToPosition():void
		{
			if ( m_curGrid != null )
			{
				m_curGrid.SetBlank();
				m_curGrid = null;
			}
			
			if ( m_nextGrid != null )
			{
				m_nextGrid.SetBlank();
				m_nextGrid = null;
			}
			
			SetPosition( m_position.x, m_position.y );
		}
		
		// stop move
		protected function stopMove():void
		{
			setToPosition();
			m_moveState = STATE_IDLE;
		}
		
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
				stopMove();
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
			
			path = AStar.SINGLETON.GetPath( m_map, m_gridCoordinate, dest );
			
			return path;
		}
		
		
		//------------------------------- event callback -----------------------------------
		
	}

}