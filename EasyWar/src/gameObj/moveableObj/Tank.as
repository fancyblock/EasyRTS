package gameObj.moveableObj 
{
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Tank extends MoveableItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Tank
		 */
		public function Tank() 
		{
			super();
			
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			//TODO 
		}
		
		
		/**
		 * @desc	callback when object be add
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			//TODO
		}
		
		
		/**
		 * @desc	callback when object be removed
		 */
		override public function onRemove():void
		{
			super.onRemove();
			
			//TODO
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}