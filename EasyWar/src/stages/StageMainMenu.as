package stages 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageMainMenu extends BaseStage
	{
		protected var m_ui:Sprite = null;
		
		public function StageMainMenu() 
		{
			//TODO
		}
		
		/* INTERFACE stages.IStage */
		
		override public function onEnter():void 
		{
			m_ui = new mainMenu();
			
			m_ui.getChildByName( "btnStart" ).addEventListener( MouseEvent.CLICK, _onStart );
			
			this.CANVAS.addChild( m_ui );
		}
		
		override public function onFrame(elapsed:Number):void 
		{
			
		}
		
		override public function onLeave():void 
		{
			m_ui.getChildByName( "btnStart" ).removeEventListener( MouseEvent.CLICK, _onStart );
			
			this.CANVAS.removeChild( m_ui );
		}
		
		
		private function _onStart( evt:MouseEvent ):void
		{
			StageManager.SINGLETON.StartStage( "InGame" );
		}
		
	}

}