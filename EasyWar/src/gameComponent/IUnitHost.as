package gameComponent 
{
	import gameObj.Unit;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public interface IUnitHost 
	{
		function AddGameObject( unit:Unit, xPos:Number, yPos:Number, group:int ):void
	}
	
}