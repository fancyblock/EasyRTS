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
		static public const BLOCK:int = 1;
		static public const UNIT:int = 2;
		
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
		 * @desc	set block
		 */
		public function SetBlock():void
		{
			this._type = BLOCK;
			this._coverItem = null;
		}
		
		
		/**
		 * @desc	set the mapItem
		 * @param	item
		 */
		public function SetMapItem( item:MapItem ):void
		{
			this._type = UNIT;
			this._coverItem = item;
		}
		
	}

}