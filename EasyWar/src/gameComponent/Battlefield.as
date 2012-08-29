package gameComponent 
{
	import flash.display.DisplayObjectContainer;
	import gameObj.IGameObject;
	import map.GridMap;
	import mapItem.MapItem;
	
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
		protected var m_unitList:Vector.<IGameObject> = null;
		protected var m_selectedUnit:MapItem = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Battlefield
		 */
		public function Battlefield() 
		{
			m_unitList = new Vector.<IGameObject>(); 
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
		 * @desc	return the selected unit type
		 */
		public function get SELECTED_UNIT():MapItem 
		{ 
			return m_selectedUnit;
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
		public function AddGameObject( unit:MapItem, xPos:int, yPos:int ):void
		{
			//TODO 
			
			unit.onAdd();
			m_unitList.push( unit );
		}
		
		
		/**
		 * @desc	update
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{
			for ( var i:int = 0; i < m_unitList.length; i++ )
			{
				m_unitList[i].Update( elapsed );
			}
		}
		
		
		/**
		 * @desc	return the grid map
		 */
		public function get MAP():GridMap { return m_map; }
		
		
		/**
		 * @desc	select the army or building
		 * @param	xPos
		 * @param	yPos
		 * @return
		 */
		public function SelectUnit( xPos:Number, yPos:Number ):Boolean
		{
			var selectSuccess:Boolean = false;
			
			cleanCurrentSelect();
			
			//TODO 
			
			return selectSuccess;
		}
		
		//------------------------------ private function ----------------------------------
		
		// clean the current selected unit
		protected function cleanCurrentSelect():void
		{
			m_selectedUnit = null;
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}