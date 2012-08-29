package gameComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import gameObj.IGameObject;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Battlefield 
	{
		//------------------------------ static member -------------------------------------
		
		static public const UNIT_TROOP:int = 1;
		static public const UNIT_BUILDING:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_canvas:DisplayObjectContainer = null;
		protected var m_map:GridMap = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Battlefield
		 */
		public function Battlefield() 
		{
			//TODO 
		}
		
		
		/**
		 * @desc	load the battlefield from a xml file
		 * @param	settingFile
		 */
		public function LoadFromXML( settingFile:XML ):void
		{
			//TODO 
		}
		
		
		/**
		 * @desc	set the canvas of the battlefield
		 */
		public function set CANVAS( value:DisplayObjectContainer ):void 
		{
			m_canvas = value;
		}
		
		
		/**
		 * @desc	create a blank battlefield
		 * @param	wid
		 * @param	hei
		 */
		public function Create( wid:int, hei:int ):void
		{
			if ( wid <= 0 || hei <= 0 )
			{
				throw new Error( "[Battlefield]: create battlefield error, size is illegal" );
			}
			
			m_map = new GridMap( wid, hei );
			
			//TODO 
		}
		
		
		/**
		 * @desc	add game object	to the map ( grid coordinate )
		 * @param	gameObj
		 */
		public function AddGameObject( gameObj:IGameObject, xPos:int, yPos:int ):void
		{
			//TODO 
		}
		
		
		/**
		 * @desc	update
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			//TODO 
		}
		
		
		/**
		 * @desc	select the army or building
		 * @param	xPos
		 * @param	yPos
		 * @return
		 */
		public function SelectSingle( xPos:Number, yPos:Number ):int
		{
			var selectCnt:int = 0;
			
			cleanCurrentSelect();
			
			//TODO 
			
			return selectCnt;
		}
		
		
		/**
		 * @desc	select a group of the army
		 * @param	rect
		 * @return
		 */
		public function SelectGroup( rect:Rectangle ):int
		{
			var selectCnt:int = 0;
			
			cleanCurrentSelect();
			
			//TODO
			
			return selectCnt;
		}
		
		//------------------------------ private function ----------------------------------
		
		// clean the current selected unit
		protected function cleanCurrentSelect():void
		{
			//TODO
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}