package stages 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IStage 
	{
		function onEnter():void;
		function onFrame( elapsed:Number ):void;
		function onLeave():void;
		
		function get CANVAS():DisplayObjectContainer;
		function set CANVAS( canvas:DisplayObjectContainer ):void;
	}
	
}