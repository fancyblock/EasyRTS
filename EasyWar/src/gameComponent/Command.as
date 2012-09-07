package gameComponent 
{
	import flash.geom.Point;
	import map.GridInfo;
	import mapItem.MapItem;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Command 
	{
		//------------------------------ static member -------------------------------------
		
		static public const CMD_NONE:int = 0;		// default command , no command
		static public const CMD_MOVE:int = 1;
		static public const CMD_ATTACK:int = 2;
		static public const CMD_OCCUPY:int = 3;
		static public const CMD_PRODUCE:int = 4;
		
		//------------------------------ private member ------------------------------------
		
		public var _type:int = 0;					// comman type
		public var _destGrid:GridInfo = null;		// for CMD_MOVE
		public var _aim:MapItem = null;				// for CMD_ATTACK , CMD_OCCUPY 
		public var _unitType:int = 0;				// for CMD_PRODUCE
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Command
		 */
		public function Command() 
		{
			this._type = CMD_NONE;
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}