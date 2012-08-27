package map 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IMapRender 
	{
		function SetCanvas( canvas:DisplayObjectContainer ):void;
		
		function SetViewport( wid:Number, hei:Number ):void;
		
		function DrawMap( map:GridMap ):void;
	}
	
}