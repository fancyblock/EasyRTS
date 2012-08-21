package stages 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageManager 
	{
		//--------------------------------------------- static member -------------------------------------------------
		
		static private var STATE_NONE:int = 0;
		static private var STATE_RUNNING:int = 1;
		static private var STATE_LEAVING:int = 2;
		static private var STATE_ENTERING:int = 3;
		
		static private var s_flag:Boolean = false;
		static private var s_instance:StageManager = null;
		
		//-------------------------------------------- static function ------------------------------------------------
		
		/**
		* @desc	return the singleton of StageManager
		*/
		static public function get SINGLETON():StageManager
		{
			if ( s_instance == null )
			{
				s_flag = true;
				s_instance = new StageManager();
				s_flag = false;
			}
			
			return s_instance;
		}
		
		//-------------------------------------------- private members ------------------------------------------------
		
		protected var m_stages:Array = null;
		protected var m_curStage:IStage = null;
		protected var m_nextStage:IStage = null;
		protected var m_state:int = STATE_NONE;
		
		protected var m_canvas:DisplayObjectContainer = null;
		
		//-------------------------------------------- public function ------------------------------------------------
		
		/**
		 * @desc	constructor of StageManager
		 */
		public function StageManager() 
		{
			if ( s_flag == false )
			{
				throw new Error( "[Error] singleton can not be new directly" );
			}
			
			// init
			m_stages = new Array();
			
		}
		
		
		/**
		 * @desc	add a stage
		 * @param	stage
		 * @param	name
		 * @return
		 */
		public function AddStage( stage:IStage, name:String ):Boolean
		{
			if ( m_stages[name] != null )
			{
				trace( "[Error: duplicated stage name: " + name );
				
				return false;
			}
			
			stage.CANVAS = m_canvas;
			m_stages[name] = stage;
			
			trace( "[AddStage]:  stage " + name + " has be added" );
			
			return true;
		}
		
		
		/**
		 * @desc	start a stage
		 * @param	name
		 * @return
		 */
		public function StartStage( name:String ):Boolean
		{
			if ( m_stages[name] == null )
			{
				trace( "[Error: Stage " + name + " can not be found" );
				
				return false;
			}
			
			if ( m_state == STATE_RUNNING )
			{
				m_state = STATE_LEAVING;
				m_nextStage = m_stages[name];
				
				return true;
			}
			
			if ( m_state == STATE_NONE )
			{
				m_state = STATE_ENTERING;
				m_nextStage = m_stages[name];
				
				return true;
			}
			
			if ( m_state == STATE_LEAVING || m_state == STATE_ENTERING )
			{
				return false;
			}
			
			return true;
		}
		
		
		/**
		 * @desc	
		 * @param	elapsed
		 */
		public function Update( elapsed:Number ):void
		{	
			if ( m_state == STATE_ENTERING )
			{
				m_curStage = m_nextStage;
				m_curStage.onEnter();
				
				m_nextStage = null;
				m_state = STATE_RUNNING;
			}
			
			if ( m_state == STATE_RUNNING )
			{
				m_curStage.onFrame( elapsed );
			}
			
			if ( m_state == STATE_LEAVING )
			{
				m_curStage.onLeave();
				m_state = STATE_ENTERING;
			}
		}
		
		
		/**
		 * @desc	setter of the CANVAS
		 */
		public function set CANVAS( canvas:DisplayObjectContainer ):void
		{
			m_canvas = canvas;
		}
		
	}

}