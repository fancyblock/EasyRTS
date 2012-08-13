package stages 
{
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class BaseStage implements IStage 
	{
		protected var m_canvas:DisplayObjectContainer = null;
		
		public function BaseStage() 
		{
			
		}
		
		/* INTERFACE stages.IStage */
		
		public function onEnter():void 
		{
			
		}
		
		public function onFrame(elapsed:Number):void 
		{
			
		}
		
		public function onLeave():void 
		{
			
		}
		
		public function get CANVAS():DisplayObjectContainer 
		{
			return m_canvas;
		}
		
		public function set CANVAS( canvas:DisplayObjectContainer ):void
		{
			m_canvas = canvas;
		}
		
	}

}