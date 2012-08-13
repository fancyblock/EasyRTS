package stages 
{
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		
		public function StageInGame() 
		{
			//TODO 
		}
		
		/* INTERFACE stages.IStage */
		
		override public function onEnter():void 
		{
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
		}
		
	}

}