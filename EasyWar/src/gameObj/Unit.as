package gameObj 
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import gameComponent.Command;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Unit implements IGameObject 
	{
		//------------------------------ static member -------------------------------------
		
		static public var STATE_NROMAL:int = 0;
		static public var STATE_DEAD:int = 1;
		static public var STATE_REMOVE:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_position:Point = null;
		
		protected var m_map:GridMap = null;
		protected var m_group:int = 0;
		protected var m_type:int = 0;
		protected var m_state:int = 0;
		protected var m_isSelected:Boolean = false;
		protected var m_command:Command = null;
		
		protected var m_canvas:DisplayObjectContainer = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Unit
		 */
		public function Unit() 
		{
			m_position = new Point();
			m_state = STATE_NROMAL;
		}
		
		
		/**
		 * @desc	set the item owner map
		 * @param	map
		 */
		public function SetMap( map:GridMap ):void
		{
			m_map = map;
		}
		
		
		/**
		 * @desc	setter & getter of the group property
		 */
		public function get GROUP():int { return m_group; }
		public function set GROUP( value:int ):void { m_group = value; }
		
		
		/**
		 * @desc	setter & getter of the type property
		 */
		public function get TYPE():int { return m_type; }
		public function set TYPE( value:int ):void { m_type = value; }
		
		
		/**
		 * @desc	getter & setter of the state property
		 */
		public function set STATE( value:int ):void { m_state = value; }
		public function get STATE():int { return m_state; }
		
		
		/**
		 * @desc	getter & setter of the selected property
		 */
		public function set SELECTED( value:Boolean ):void { m_isSelected = value; }
		public function get SELECTED():Boolean { return m_isSelected; }
		
		
		/**
		 * @desc	set the command of this object
		 * @param	command
		 */
		public function SendCommand( command:Command ):void
		{
			m_command = command;
		}
		
		
		/**
		 * @desc	getter of the position property
		 */
		public function get POSITION():Point
		{
			return m_position;
		}
		
		
		/* INTERFACE gameObj.IGameObject */
		
		public function Update(elapsed:Number):void 
		{
		}
		
		public function onAdd():void 
		{
		}
		
		public function onRemove():void 
		{
		}
		
		
		/**
		 * @desc	set canvas
		 * @param	canvas
		 */
		public function SetCanvas( canvas:DisplayObjectContainer ):void
		{
			m_canvas = canvas;
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}