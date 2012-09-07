package gameObj.building 
{
	import gameObj.UnitTypes;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class City extends Building 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const CITY_LIFE_VALUE:int = 360;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_occupyPoint:int = 0;
		protected var m_occupyMaxPoint:int = 0;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of City
		 */
		public function City() 
		{
			super();
			
			m_type = UnitTypes.TYPE_CITY;
			m_maxLifeValue = CITY_LIFE_VALUE;
			m_lifeValue = m_maxLifeValue;
			
			m_occupyMaxPoint = CITY_LIFE_VALUE;
			m_occupyPoint = m_occupyMaxPoint;
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			updateDisplay();
		}
		
		
		/**
		 * @desc	update 
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			//TODO 
		}
		
		
		/**
		 * @desc	getter & setter of the life
		 */
		override public function get LIFE():Number { return m_occupyPoint; }
		override public function set LIFE( value:Number ):void 
		{
			if ( value <= 0 )
			{
				m_occupyPoint = 0;
				
				changeGroup( this.ATTACK_GROUP );
				
				this.SetPosition( (this.GRID_COORDINATE.x + 0.5)*m_map.GRID_SIZE, (this.GRID_COORDINATE.y + 0.5)*m_map.GRID_SIZE );
				updateDisplay();
			}
			else
			{
				m_occupyPoint = value;
			}
			
			m_lifeBar.SetLife( (Number)(m_occupyPoint) / (Number)(m_occupyMaxPoint) );
		}
		
		
		//------------------------------ private function ----------------------------------
		
		// change the group
		protected function changeGroup( group:int ):void
		{
			this.GROUP = group;
			
			m_occupyPoint = m_occupyMaxPoint;
			m_lifeBar.SetLife( (Number)(m_occupyPoint) / (Number)(m_occupyMaxPoint) );
		}
		
		
		// update the display
		protected function updateDisplay():void
		{
			while ( m_display.numChildren > 0 )
			{
				m_display.removeChildAt( 0 );
			}
			
			if ( m_group == UnitTypes.SELF_GROUP )
			{
				m_display.addChild( new mcCity01() );
			}
			else if ( m_group == UnitTypes.ENEMY_GROUP )
			{
				m_display.addChild( new mcCity02() );
			}
			else
			{
				m_display.addChild( new mcCity03() );
			}
			
			m_display.addChild( m_lifeBar );
			m_lifeBar.visible = true;
			
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}