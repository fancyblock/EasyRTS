package gameObj.building 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import gameComponent.Command;
	import gameObj.moveableObj.Army;
	import gameObj.moveableObj.Infantry;
	import gameObj.moveableObj.Tank;
	import gameObj.Unit;
	import gameObj.UnitTypes;
	import map.GridInfo;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Arsenal extends Building 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const ARSENAL_STATE_IDLE:int = 0;
		static protected const ARSENAL_STATE_PRODUCE:int = 1;
		static protected const ARSENAL_STATE_DELIVERY:int = 2;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_factoryState:int = 0;
		protected var m_currentProduction:Army = null;
		
		protected var m_timer:int = 0;
		protected var m_model:Sprite = null;
		
		//------------------------------ public function -----------------------------------
		
		
		/**
		 * @desc	constructor of Arsenal
		 */
		public function Arsenal() 
		{
			super();
			
			m_type = UnitTypes.TYPE_ARSENAL;
		}
		
		
		/**
		 * @desc	return if this arsenal is idle or not
		 * @return
		 */
		public function IsIdle():Boolean 
		{
			return ( m_factoryState == ARSENAL_STATE_IDLE );
		}
		
		
		/**
		 * @desc	update 
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			if ( m_factoryState == ARSENAL_STATE_PRODUCE )
			{
				// produce done
				if ( m_timer == m_currentProduction.PRODUCE_CYCLE )
				{
					deliveryTroop();
					
					m_canvas.removeChild( m_model );
					m_factoryState = ARSENAL_STATE_DELIVERY;
				}
				else
				{
					m_timer++;
					
					m_model.alpha = (Number)(m_timer) / (Number)(m_currentProduction.PRODUCE_CYCLE);
				}
			}
			
			if ( m_factoryState == ARSENAL_STATE_DELIVERY )
			{
				if ( m_myGrid._type == GridInfo.BLANK )
				{
					HideOnMap( false );
					
					m_factoryState = ARSENAL_STATE_IDLE;
				}
				else
				{
					//TODO 
				}
			}
		}
		
		
		/**
		 * @desc	callback when add to map
		 */
		override public function onAdd():void
		{
			super.onAdd();
			
			m_display.addChild( new mcFactory01() );
			m_display.addChild( m_lifeBar );
		}
		
		
		/**
		 * @desc	callback when remove from map
		 */
		override public function onRemove():void
		{
			//TODO 
			
			super.onRemove();
		}
		
		
		/**
		 * @desc	set the command of this object
		 * @param	command
		 */
		override public function SendCommand( command:Command ):void
		{
			super.SendCommand( command );
			
			if ( m_factoryState != ARSENAL_STATE_IDLE )
			{
				trace( "[Arsenal]: not in idle state, can not produce the unit" );
				
				return;
			}
			
			if ( m_factoryState == ARSENAL_STATE_IDLE )
			{
				produceTroop( command._unitType );
				
				m_command = null;
			}
		}
		
		//------------------------------ private function ----------------------------------
		
		// produce the troop
		protected function produceTroop( type:int ):void
		{
			var unit:Army = null;
			
			if ( type == UnitTypes.TYPE_TANK )
			{
				unit = new Tank();
			}
			
			if ( type == UnitTypes.TYPE_INFANTRY )
			{
				unit = new Infantry();
			}
			
			m_currentProduction = unit;
			m_timer = 0;
			
			m_model = unit.GetDisplay();
			m_model.x = m_position.x;
			m_model.y = m_position.y;
			m_model.alpha = 0;
			m_canvas.addChild( m_model );
			
			m_factoryState = ARSENAL_STATE_PRODUCE;
		}
		
		
		// delivery the troop 
		protected function deliveryTroop():void
		{
			this.HideOnMap( true );
			
			m_unitHost.AddGameObject( m_currentProduction, this.POSITION.x, this.POSITION.y, this.GROUP );
			
			var positionGrid:GridInfo = m_map.GetGridInfo( m_myGrid._x, m_myGrid._y + 1 );
			
			if ( positionGrid._type == GridInfo.UNIT )
			{
				cleanGrid( positionGrid );
			}
			
			var path:Vector.<GridInfo> = new Vector.<GridInfo>();
			path.push( positionGrid );
			m_currentProduction.PATH = path;
		}
		
		
		// clean the destination grid
		protected function cleanGrid( gridInfo:GridInfo ):void
		{
			var unit:Army = gridInfo._coverItem as Army;
			
			var index:int = 0;
			var roundBlankGrids:Array = new Array();
			var roundArmyGrids:Array = new Array();
			var pendingGrid:GridInfo = null;
			var nextGrid:GridInfo = null;
			
			var offsets:Array = new Array( new Point( 1, 0 ), new Point( -1, 0 ), new Point( 0, 1 ), new Point( 0, -1 ) );
			
			for ( var i:int = 0; i < offsets.length; i++ )
			{
				pendingGrid = m_map.GetGridInfo( gridInfo._x + offsets[i].x, gridInfo._y + offsets[i].y );
				if ( pendingGrid != null )
				{
					if ( pendingGrid._type == GridInfo.BLANK )
					{
						roundBlankGrids.push( pendingGrid );
					}
					if ( pendingGrid._type == GridInfo.UNIT && 
						pendingGrid._coverItem.IsTroop() && 
						pendingGrid._coverItem.GROUP == this.GROUP &&
						pendingGrid._coverItem != m_currentProduction )
					{
						roundArmyGrids.push( pendingGrid );
					}
				}
			}
			
			var path:Vector.<GridInfo> = new Vector.<GridInfo>();
			
			if ( roundBlankGrids.length > 0 )
			{
				index = Math.random() * (Number)(roundBlankGrids.length)
				nextGrid = roundBlankGrids[index];
				
				// ask army to move
				path.push( nextGrid );
				unit.PATH = path;
			}
			else if( roundArmyGrids.length > 0 )
			{
				index = Math.random() * (Number)(roundArmyGrids.length)
				nextGrid = roundArmyGrids[index];
				
				// ask army to move
				path.push( nextGrid );
				unit.PATH = path;
				
				cleanGrid( nextGrid );
			}
			else
			{
				throw new Error( "[Arsenal]: all the way be blocked" );
			}
			
		}
		
		//------------------------------- event callback -----------------------------------
		
	}

}