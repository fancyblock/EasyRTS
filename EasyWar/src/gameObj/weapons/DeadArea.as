package gameObj.weapons 
{
	import flash.display.MovieClip;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class DeadArea extends Unit 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const STATE_BOOST:int = 0;
		static protected const STATE_BOOST_ANI:int = 1;
		static protected const STATE_BOOST_DISAPPEAR:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_force:Number = 0;
		protected var m_deadAreaState:int = 0;
		
		protected var m_aniBoost:MovieClip = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of DeadArea
		 */
		public function DeadArea() 
		{
			super();
			
			m_type = UnitTypes.TYPE_DEAD_AREA;
		}
		
		
		/**
		 * @desc	set force
		 * @param	force
		 */
		public function SetForce( force:Number ):void
		{
			m_force = force;
		}
		
		
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			if ( m_deadAreaState == STATE_BOOST )
			{
				doDestory();
				
				m_deadAreaState = STATE_BOOST_ANI;
			}
			
			if ( m_deadAreaState == STATE_BOOST_ANI )
			{
				if ( m_aniBoost.currentFrame == m_aniBoost.totalFrames )
				{
					m_state = STATE_DEAD;
					
					m_deadAreaState = STATE_BOOST_DISAPPEAR;
				}
			}
		}
		
		
		override public function onAdd():void
		{
			super.onAdd();
			
			m_aniBoost = new mcDeadArea();
			m_display.addChild( m_aniBoost );
			
			m_deadAreaState = STATE_BOOST;
		}
		
		
		override public function onRemove():void
		{
			//TODO 
			
			super.onRemove();
		}
		
		
		//------------------------------ private function ----------------------------------
		
		// do destory
		protected function doDestory():void
		{
			var unit:MapItem = m_unitHost.MAP.GetPositionItem( m_position.x, m_position.y );
			
			if ( unit != null )
			{
				if ( unit.GROUP != this.GROUP )
				{
					unit.LIFE = unit.LIFE - m_force;
				}
			}
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}