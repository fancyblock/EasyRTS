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
		static public const HOLD:int = 3;
		
		//------------------------------ for path finding ----------------------------------
		
		static public const OPEN_LIST:int = 4;
		static public const CLOSE_LIST:int = 5;
		
		public var _list:int = 0;
		public var _f:Number = 0;
		public var _g:Number = 0;
		public var _h:Number = 0;
		public var _weight:Number = 0;
		public var _parentNode:GridInfo = null;
		
		//------------------------------ private member ------------------------------------
		
		public var _x:int = 0;
		public var _y:int = 0;
		
		public var _type:int = 0;
		public var _coverItem:MapItem = null;
		
		public var _map:GridMap = null;
		
		//------------------------------ public functions -----------------------------------
		
		
		/**
		 * @desc	set the grid blank
		 */
		public function SetBlank():void
		{
			this._type = BLANK;
			this._coverItem = null;
			
			if ( _map.MINI_MAP != null )
			{
				_map.MINI_MAP.CleanMapItem( _x, _y );
			}
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
		 * @desc	set the hold
		 * @param	item
		 */
		public function SetHold( item:MapItem ):void
		{
			this._type = HOLD;
			this._coverItem = item;
		}
		
		
		/**
		 * @desc	set the mapItem
		 * @param	item
		 */
		public function SetMapItem( item:MapItem ):void
		{
			this._type = UNIT;
			this._coverItem = item;
			
			// update the miniMap display
			if ( _map.MINI_MAP != null )
			{
				_map.MINI_MAP.SetMapItem( _x, _y, item );
			}
		}
		
	}

}