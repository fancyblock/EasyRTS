package gameObj 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IGameObject 
	{
		function Update( elapsed:Number ):void;
		
		function onAdd():void;
		
		function onRemove():void;
		
		function SetCanvas( canvas:DisplayObjectContainer ):void;
	}
	
}