package mapItem 
{
	import flash.geom.Point;
	import map.GridInfo;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MoveableItem extends MapItem 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const STATE_IDLE:int = 0;
		static protected const STATE_MOVE:int = 1;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_velocity:Number = 0;
		protected var m_moveVector:Point = new Point();
		
		protected var m_path:Vector.<GridInfo> = null;
		protected var m_moveState:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of MoveableItem
		 */
		public function MoveableItem() 
		{
			super();
			
			m_path = new Vector.<GridInfo>();
		}
		
		
		/**
		 * @desc	getter & setter of the velocity
		 */
		public function set VELOCITY( value:Number ):void { m_velocity = value; }
		public function get VELOCITY():Number { return m_velocity; }
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			if ( m_moveState == STATE_MOVE )
			{
				//TODO 
			}
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}