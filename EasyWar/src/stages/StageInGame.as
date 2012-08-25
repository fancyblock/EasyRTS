package stages 
{
	import flash.display.Sprite;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		protected var m_ui:Sprite = null;
		
		public function StageInGame() 
		{
			//TODO 
		}
		
		/* INTERFACE stages.IStage */
		
		override public function onEnter():void 
		{
			// initial the ui
			m_ui = new inGameUI();
			
			//TODO 
			
			this.CANVAS.addChild( m_ui );
			
			//TODO
			
			var gameMap:GridMap = new GridMap( 30, 30 );		//TEMP

		}
		
		override public function onFrame(elapsed:Number):void 
		{
			//TODO
		}
		
		override public function onLeave():void 
		{
			//TODO 
			
			this.CANVAS.removeChild( m_ui );
		}
		
	}

}