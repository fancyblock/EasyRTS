package map.pathFinding
{
	import flash.geom.Point;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IPathFinder 
	{
		function GetPath(map:GridMap, src:Point, dest:Point, omitDest:Boolean = false ):Array; 
	}
	
}