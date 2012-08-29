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
		static public const OBJ_OCCUPY:int = 1;
		//TODO 
		
		//------------------------------ private member ------------------------------------
		
		public var _x:int = 0;
		public var _y:int = 0;
		
		public var _type:int = 0;
		public var _coverItem:MapItem = null;
		
		
		/**
		 * @desc	set the grid blank
		 */
		public function SetBlank():void
		{
			this._type = BLANK;
			this._coverItem = null;
		}
		
		
		/**
		 * @desc	set the mapItem
		 * @param	item
		 */
		public function SetMapItem( item:MapItem ):void
		{
			this._type = OBJ_OCCUPY;
			this._coverItem = item;
		}
		
	}

}