package map.pathFinding
{
	import flash.geom.Point;
	import map.GridInfo;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class AStar implements IPathFinder
	{
		//------------------------------ static member -------------------------------------
		
		static private var s_flag:Boolean = false;
		static private var s_instance:AStar = null;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_openList:Vector.<GridInfo> = null;
		protected var m_openListLen:int = 0;
		protected var m_closeList:Vector.<GridInfo> = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		* @desc	return the singleton of AStar
		*/
		static public function get SINGLETON():AStar
		{
			if ( s_instance == null )
			{
				s_flag = true;
				s_instance = new AStar();
				s_flag = false;
			}
			
			return s_instance;
		}
		
		
		/**
		 * @desc	constructor of AStar
		 */
		public function AStar() 
		{
			if ( s_flag == false )
			{
				throw new Error( "[Error] singleton can not be new directly" );
			}
		}
		
		/* INTERFACE IPathFinder */
		
		public function GetPath( theMap:GridMap, src:Point, dest:Point, omitDest:Boolean = false ):Array 
		{
			init();
			
			var node:GridInfo = theMap.GetGridInfo( src.x, src.y );
			node._list = 0;
			node._g = 0;
			node._h = calculateH( node, dest );
			node._f = node._g + node._h;
			addOpenList( node );
			
			var forceNeighbor:GridInfo = null;
			if ( omitDest == true )
			{
				forceNeighbor = theMap.GetGridInfo( dest.x, dest.y );
			}
			
			var isArrived:Boolean = false;
			while ( true )
			{
				if ( IsOpenListEmpty() == true || isArrived == true )
				{
					break;
				}
				
				node = popFirstNode();
				var neighbors:Array = getNodeNeighbors( theMap, node, forceNeighbor );
				addCloseList( node );
				
				var neiNode:GridInfo = null;
				for ( var i:int = 0; i < neighbors.length; i++ )
				{
					neiNode = neighbors[i] as GridInfo;
					
					if( neiNode._list == GridInfo.OPEN_LIST )
					{
						if ( neiNode._g > node._g + neiNode._weight )
						{
							neiNode._parentNode = node;
							neiNode._g = node._g + neiNode._weight;
							neiNode._h = calculateH( neiNode, dest );
							neiNode._f = neiNode._g + neiNode._h;
							
							updateNode( neiNode );
						}
					}
					else
					{
						neiNode._parentNode = node;
						neiNode._g = node._g + neiNode._weight;
						neiNode._h = calculateH( neiNode, dest );
						neiNode._f = neiNode._g + neiNode._h;
						
						addOpenList( neiNode );
					}
					
					if ( neiNode._x == dest.x && neiNode._y == dest.y )		// arrive to the dest
					{
						isArrived = true;
					}
				}
			}
			
			var path:Array = null;
			node = theMap.GetGridInfo( dest.x, dest.y ) as GridInfo;
			if ( node._parentNode != null )
			{
				path = [];
				
				while ( node != null )
				{
					path.push( new Point( node._x, node._y ) );
					node = node._parentNode;
				}
				
				path.reverse();
			}
			
			cleanMap();
			
			return path;
		}
		
		//------------------------------ private function ----------------------------------
		
		protected function init():void
		{
			m_openList = new Vector.<GridInfo>();
			m_openList.push( new GridInfo() );
			m_openListLen = 0;
			m_closeList = new Vector.<GridInfo>();
		}
		
		protected function addOpenList( node:GridInfo ):void
		{
			var index:int = m_openListLen + 1;
			m_openList.push( node );
			node._list = GridInfo.OPEN_LIST;
			
			var parentIndex:int;
			while ( index != 1 )
			{
				parentIndex = index / 2;
				
				if ( m_openList[parentIndex]._f > m_openList[index]._f )
				{
					var temp:GridInfo = m_openList[parentIndex];
					m_openList[parentIndex] = m_openList[index];
					m_openList[index] = temp;
					
					index = parentIndex;
				}
				else
				{
					break;
				}
			}
			
			m_openListLen++;
		}
		
		// return the first node of heap and erase it
		protected function popFirstNode():GridInfo
		{
			if ( m_openListLen == 0 ) return null;
			
			var firstNode:GridInfo = m_openList[1];
			firstNode._list = 0;
			
			var index:int = 1;
			m_openList[index] = m_openList[m_openListLen];
			m_openList.pop();
			
			var nodeLeftIndex:int;
			var nodeRightIndex:int;
			var temp:GridInfo;
			var finished:Boolean = false;
			while ( true )
			{
				nodeLeftIndex = index * 2;
				nodeRightIndex = nodeLeftIndex + 1;
				
				if ( ( nodeLeftIndex >= m_openListLen ) || finished )
				{
					break;
				}
				else if ( nodeRightIndex >= m_openListLen )
				{
					if ( m_openList[nodeLeftIndex]._f < m_openList[index]._f )
					{
						temp = m_openList[nodeLeftIndex];
						m_openList[nodeLeftIndex] = m_openList[index];
						m_openList[index] = temp;
						
						index = nodeLeftIndex;
					}
					else
					{
						finished = true;
					}
				}
				else
				{
					if ( m_openList[nodeLeftIndex]._f < m_openList[nodeRightIndex]._f )
					{
						if ( m_openList[nodeLeftIndex]._f < m_openList[index]._f )
						{
							temp = m_openList[nodeLeftIndex];
							m_openList[nodeLeftIndex] = m_openList[index];
							m_openList[index] = temp;
							
							index = nodeLeftIndex;
						}
						else
						{
							finished = true;
						}
					}
					else
					{
						if ( m_openList[nodeRightIndex]._f < m_openList[index]._f )
						{
							temp = m_openList[nodeRightIndex];
							m_openList[nodeRightIndex] = m_openList[index];
							m_openList[index] = temp;
							
							index = nodeRightIndex;
						}
						else
						{
							finished = true;
						}
					}
				}
			}
			
			m_openListLen--;
			
			return firstNode;
		}
		
		protected function updateNode( node:GridInfo ):void
		{
			var index:int = m_openList.indexOf( node );
			
			var parentIndex:int;
			while ( index != 1 )
			{
				parentIndex = index / 2;
				
				if ( m_openList[parentIndex]._f > m_openList[index]._f )
				{
					var temp:GridInfo = m_openList[parentIndex];
					m_openList[parentIndex] = m_openList[index];
					m_openList[index] = temp;
					
					index = parentIndex;
				}
				else
				{
					break;
				}
			}
		}
		
		protected function IsOpenListEmpty():Boolean
		{
			if ( m_openListLen == 0 )
			{
				return true;
			}
			
			return false;
		}
		
		protected function addCloseList( node:GridInfo ):void
		{
			node._list = GridInfo.CLOSE_LIST;
			m_closeList.push( node );
		}
		
		protected function getNodeNeighbors( theMap:GridMap, nodeMe:GridInfo, forceNeighbor:GridInfo ):Array
		{
			var neighbors:Array = [];
			
			var node:GridInfo;
			var pending:Array = [];
			pending[0] = theMap.GetGridInfo( nodeMe._x + 1, nodeMe._y );
			pending[1] = theMap.GetGridInfo( nodeMe._x + 1, nodeMe._y + 1 );
			pending[2] = theMap.GetGridInfo( nodeMe._x, nodeMe._y + 1 );
			pending[3] = theMap.GetGridInfo( nodeMe._x - 1, nodeMe._y + 1 );
			pending[4] = theMap.GetGridInfo( nodeMe._x - 1, nodeMe._y );
			pending[5] = theMap.GetGridInfo( nodeMe._x - 1, nodeMe._y - 1 );
			pending[6] = theMap.GetGridInfo( nodeMe._x, nodeMe._y - 1 );
			pending[7] = theMap.GetGridInfo( nodeMe._x + 1, nodeMe._y - 1 );
			
			for ( var i:int = 0; i < 8; i++ )
			{
				if ( pending[i] == null )	continue;
				
				var canReachGrid:Boolean = pending[i]._type == GridInfo.BLANK || pending[i] == forceNeighbor;
				
				if ( i % 2 == 0 )
				{
					if ( pending[i]._list != GridInfo.CLOSE_LIST && canReachGrid )
					{
						neighbors.push( pending[i] );
						pending[i]._weight = 1.0;
					}
				}
				else
				{
					if ( pending[i]._list != GridInfo.CLOSE_LIST && canReachGrid && 
						( pending[i - 1]._type == GridInfo.BLANK && ( pending[(i + 1)%8]._type == GridInfo.BLANK || pending[(i + 1)%8] == forceNeighbor ) ) )
					{
						neighbors.push( pending[i] );
						pending[i]._weight = 1.414;
					}
				}
			}
			
			return neighbors;
		}
		
		protected function cleanMap():void
		{
			var i:int;
			
			for ( i = 0; i < m_closeList.length; i++ )
			{
				( m_closeList[i] as GridInfo )._parentNode = null;
				( m_closeList[i] as GridInfo )._list = 0;
			}
			
			for ( i = 1; i < m_openList.length; i++ )
			{
				( m_openList[i] as GridInfo )._parentNode = null;
				( m_openList[i] as GridInfo )._list = 0;
			}
		}
		
		protected function calculateH( node:GridInfo, dest:Point ):int
		{
			return ( Math.abs( node._x - dest.x ) + Math.abs( node._y - dest.y ) );
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}