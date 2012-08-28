package gameComponent 
{
	import flash.display.DisplayObjectContainer;
	import map.GridMap;
	import gameObj.IGameObject;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Battlefield 
	{
		//------------------------------ static member -------------------------------------
		
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
		 * @desc	add game object
		 * @param	gameObj
		 */
		public function AddGameObject( gameObj:IGameObject, xPos:Number, yPos:Number ):void
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
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}