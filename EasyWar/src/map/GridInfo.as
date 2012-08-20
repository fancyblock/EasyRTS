package map 
{
	import mapItem.MapItem;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class GridInfo 
	{
		//------------------------------ static member -------------------------------------
		
		static public const BLANK:int = 0;
		//TODO 
		
		//------------------------------ private member ------------------------------------
		
		public var _x:int = 0;
		public var _y:int = 0;
		
		public var _type:int = 0;
		public var _coverItem:MapItem = null;
		
	}

}