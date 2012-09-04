package gameComponent 
{
	import gameObj.Unit;
	import map.GridMap;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IUnitHost 
	{
		function AddGameObject( unit:Unit, xPos:Number, yPos:Number, group:int ):void
		
		function get MAP():GridMap;
	}
	
}