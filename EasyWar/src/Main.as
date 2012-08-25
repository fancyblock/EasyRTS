package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import stages.StageInGame;
	import stages.StageMainMenu;
	import stages.StageManager;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	[SWF(width="1024", height="768", backgroundColor="0xffffff")]
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			// create the game layer
			var gameLayer:Sprite = new Sprite();
			StageManager.SINGLETON.CANVAS = gameLayer;
			
			this.addChild( gameLayer );
			this.addChild( new GameMonitor() );
			
			// inital the game
			StageManager.SINGLETON.AddStage( new StageMainMenu(), "MainMenu" );
			StageManager.SINGLETON.AddStage( new StageInGame(), "InGame" );
			
			// start form this stage
			StageManager.SINGLETON.StartStage( "MainMenu" );
			
			// startup the game loop
			this.addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		// frame callback
		private function _onEnterFrame( evt:Event ):void
		{
			StageManager.SINGLETON.Update( 1.0 / 30.0 );		// FPS = 30
		}
		
	}
	
}