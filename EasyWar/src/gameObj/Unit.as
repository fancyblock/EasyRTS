package gameObj 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameComponent.Command;
	import gameComponent.IUnitHost;
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
		
		protected var m_unitHost:IUnitHost = null;
		
		protected var m_position:Point = null;
		protected var m_display:Sprite = null;
		protected var m_velocity:Number = 0;
		
		protected var m_map:GridMap = null;
		protected var m_group:int = 0;
		protected var m_type:int = 0;
		protected var m_state:int = 0;
		protected var m_isSelected:Boolean = false;
		protected var m_command:Command = null;
		
		protected var m_canvas:DisplayObjectContainer = null;
		
		protected var m_lifeValue:Number = 0;
		protected var m_maxLifeValue:Number = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Unit
		 */
		public function Unit() 
		{
			m_position = new Point();
			m_state = STATE_NROMAL;
			
			m_display = new Sprite();
		}
		
		
		/**
		 * @desc	set unithoset
		 * @param	unitHost
		 */
		public function SetUnitHost( unitHost:IUnitHost ):void
		{
			m_unitHost = unitHost;
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
		 * @desc	getter & setter of the life
		 */
		public function get LIFE():Number { return m_lifeValue; }
		public function set LIFE( value:Number ):void 
		{
			if ( value <= 0 )
			{
				m_lifeValue = 0;
				m_state = STATE_DEAD;
			}
			else
			{
				m_lifeValue = value;
			}
		}
		
		
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
		
		
		/**
		 * @desc	set the position
		 * @param	xPos
		 * @param	yPos
		 * @return
		 */
		public function SetPosition( xPos:Number, yPos:Number ):void
		{
			m_position.x = xPos;
			m_position.y = yPos;
		}
		
		
		/* INTERFACE gameObj.IGameObject */
		
		public function Update(elapsed:Number):void 
		{
			// update the display stuff
			m_display.x = this.POSITION.x;
			m_display.y = this.POSITION.y;
		}
		
		public function onAdd():void 
		{
			m_display.x = m_position.x;
			m_display.y = m_position.y;
			
			m_canvas.addChild( m_display );
		}
		
		public function onRemove():void 
		{
			m_canvas.removeChild( m_display );
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