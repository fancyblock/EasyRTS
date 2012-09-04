package gameObj.weapons 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Cannonball extends Unit 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const VELOCITY:Number = 24.0;
		static protected const DEFAULT_FORCE:Number = 10.0;
		
		static protected const STATE_BULLET_FLY:int = 0;
		static protected const STATE_BULLET_BOOST:int = 1;
		static protected const STATE_BULLET_WAITDIE:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_force:Number = DEFAULT_FORCE;
		
		protected var m_dest:Point = null;
		protected var m_moveOffset:Point = null;
		protected var m_bulletState:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Cannonball
		 */
		public function Cannonball() 
		{
			super();
			
			m_dest = new Point();
			m_moveOffset = new Point();
			m_velocity = VELOCITY;
			
			m_type = UnitTypes.TYPE_CANNONBALL;
		}
		
		
		/**
		 * @desc	set the dest
		 * @param	xPos
		 * @param	yPos
		 */
		public function SetDest( xPos:Number, yPos:Number ):void
		{
			m_dest.x = xPos;
			m_dest.y = yPos;
		}
		
		
		/**
		 * @desc	set the force of this cannonball
		 * @param	force
		 */
		public function SetForce( force:Number ):void
		{
			m_force = force;
		}
		
		
		/* INTERFACE gameObj.IGameObject */
		
		override public function Update(elapsed:Number):void 
		{
			super.Update( elapsed );
			
			if ( m_bulletState == STATE_BULLET_FLY )
			{
				var distance:Point = m_dest.subtract( m_position );
				
				// last frame
				if ( distance.length < m_velocity )
				{
					m_position.x = m_dest.x;
					m_position.y = m_dest.y;
					
					m_bulletState = STATE_BULLET_BOOST;
				}
				else
				{
					var offsetX:Number = m_moveOffset.x;
					var offsetY:Number = m_moveOffset.y;
					
					m_position.x += offsetX;
					m_position.y += offsetY;
				}
			}
			
			if ( m_bulletState == STATE_BULLET_BOOST )
			{
				boost();
				
				m_state = STATE_DEAD;
				m_bulletState = STATE_BULLET_WAITDIE;
			}
		}
		
		override public function onAdd():void 
		{
			super.onAdd();
			
			var ball:Sprite = new mcBullet();
			m_display.addChild( ball );
			
			m_moveOffset.x = m_dest.x - m_position.x;
			m_moveOffset.y = m_dest.y - m_position.y;
			m_moveOffset.normalize( m_velocity );
			
			m_bulletState = STATE_BULLET_FLY;
			
		}
		
		override public function onRemove():void 
		{
			//TODO 
			
			super.onRemove();
		}
		
		
		//------------------------------ private function ----------------------------------
		
		// boost
		protected function boost():void
		{
			// boost the cannonball
			var boost:DeadArea = new DeadArea();
			boost.SetForce( m_force );
			
			m_unitHost.AddGameObject( boost, m_position.x, m_position.y, this.GROUP );
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}