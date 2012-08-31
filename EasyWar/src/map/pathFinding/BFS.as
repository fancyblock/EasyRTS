package map.pathFinding
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class BFS implements IPathFinder 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_arriveList:Vector.<GridInfo> = null;
		protected var m_searchList:Vector.<GridInfo> = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of BFS
		 */
		public function BFS() 
		{
		}
		
		/* INTERFACE IPathFinder */
		
		public function GetPath(map:GridMap, src:Point, dest:Point):Array 
		{
			init();
			
			var node:GridInfo = map.GetGridInfo( src.x, src.y );
			node._list = GridInfo.OPEN_LIST;
			m_searchList.push( node );
			
			while ( true )
			{
				if ( m_searchList.length == 0 )
				{
					break;
				}
				
				node = m_searchList.shift();
				var neighbors:Array = getNodeNeighbors( map, node );
				
			}
			
		}
		
		//------------------------------ private function ----------------------------------
		
		protected function init():void
		{
			m_arriveList = new Vector.<GridInfo>();
			m_searchList = new Vector.<GridInfo>();
		}
		
		protected function getNodeNeighbors( map:GridMap, nodeMe:GridInfo ):Array
		{
			var neighbors:Array = [];
			
			var node:GridInfo;
			var pending:Array = [];
			pending[0] = map.GetGridInfo( nodeMe._x + 1, nodeMe._y );
			pending[1] = map.GetGridInfo( nodeMe._x + 1, nodeMe._y + 1 );
			pending[2] = map.GetGridInfo( nodeMe._x, nodeMe._y + 1 );
			pending[3] = map.GetGridInfo( nodeMe._x - 1, nodeMe._y + 1 );
			pending[4] = map.GetGridInfo( nodeMe._x - 1, nodeMe._y );
			pending[5] = map.GetGridInfo( nodeMe._x - 1, nodeMe._y - 1 );
			pending[6] = map.GetGridInfo( nodeMe._x, nodeMe._y - 1 );
			pending[7] = map.GetGridInfo( nodeMe._x + 1, nodeMe._y - 1 );
			
			for ( var i:int = 0; i < 8; i++ )
			{
				if ( pending[i] == null )	continue;
				
				if ( i % 2 == 0 )
				{
					if ( pending[i]._list == 0 && pending[i]._type != GridInfo.TYPE_OBSTACLE )
					{
						neighbors.push( pending[i] );
					}
				}
				else
				{
					if ( pending[i]._list == 0 && pending[i]._type != GridInfo.TYPE_OBSTACLE && 
						( pending[i - 1]._type != GridInfo.TYPE_OBSTACLE && pending[(i + 1)%8]._type != GridInfo.TYPE_OBSTACLE ) )
					{
						neighbors.push( pending[i] );
					}
				}
			}
			
			return neighbors;
		}
		
		protected function cleanMap():void
		{
			//TODO
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}