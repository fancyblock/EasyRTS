package stages 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import gameComponent.Battlefield;
	import gameObj.moveableObj.Tank;
	import mapItem.MapItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		//---------------------------- static member ------------------------------
		
		static protected const STATE_NORMAL:int = 0;
		static protected const STATE_SELECTED_TROOP:int = 1;
		static protected const STATE_SELECTED_BUILDING:int = 2;
		
		static protected const SELF_GROUP:int = 0;
		
		//---------------------------- private member ----------------------------- 
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		
		// mini map
		protected var m_miniMapFrame:Sprite = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		
		protected var m_state:int = 0;
		
		
		//--------------------------- public function ----------------------------
		
		
		/**
		 * @desc	constructor of StageInGame
		 */
		public function StageInGame() 
		{
		}
		
		/* INTERFACE stages.IStage */
		
		override public function onEnter():void 
		{
			// create the game layer
			m_gameLayer = new Sprite();
			this.CANVAS.addChild( m_gameLayer );
			
			// initial the ui
			m_ui = new inGameUI();
			m_mouseArea = m_ui.getChildByName( "mcMouseArea" ) as Sprite;
			m_mouseArea.addEventListener( MouseEvent.MOUSE_DOWN, onSelect );
			
			//TODO	ui stuff
			
			this.CANVAS.addChild( m_ui );
			
			// mini map
			m_miniMapFrame = m_ui.getChildByName( "mcMiniMapFrame" ) as Sprite;
			
			// create the game stuff
			m_battlefield = new Battlefield();
			m_battlefield.CANVAS = m_gameLayer;
			
			//[TEMP]
			m_battlefield.Create( 50, 30 );
			var tank:Tank = new Tank();
			m_battlefield.AddGameObject( tank, 5, 5 );
			//[TEMP]
			
			// set game state
			m_state = STATE_NORMAL;
		}
		
		override public function onFrame(elapsed:Number):void 
		{
			m_battlefield.Update( elapsed );
		}
		
		override public function onLeave():void 
		{
			//TODO 
			
			this.CANVAS.removeChild( m_ui );
			this.CANVAS.removeChild( m_gameLayer );
		}
		
		
		//--------------------------- private function ----------------------------
		
		// single select your troop
		protected function selectUnit( posX:Number, posY:Number ):void
		{
			m_battlefield.SelectUnit( posX, posY );
			
			var unit:MapItem = m_battlefield.SELECTED_UNIT;
			var type:int = unit.TYPE;
			
			//TODO 
		}
		
		// order selected troop to attack or move
		protected function orderSpot( xPos:Number, yPos:Number ):void
		{
			//TODO 
		}
		
		// play the move animation
		protected function playAniMoveDest( xPos:Number, yPos:Number ):void
		{
			// play animation
			var aniSelect:mcSelect = new mcSelect();
			aniSelect.x = xPos;
			aniSelect.y = yPos;
			m_mouseArea.addChild( aniSelect );
			aniSelect.play();
		}
		
		//----------------------------- event function ---------------------------- 
		
		protected function onSelect( evt:MouseEvent ):void
		{
			if( m_state == STATE_NORMAL )
			{
				var unit:MapItem = m_battlefield.MAP.GetPositionItem( evt.localX, evt.localY );
				
				if ( unit != null )
				{
					if ( unit.GROUP == SELF_GROUP )
					{
						selectUnit( evt.localX, evt.localY );
					}
				}
			}
			
			if ( m_state == STATE_SELECTED_TROOP )
			{
				//TODO 
			}
			
			if ( m_state == STATE_SELECTED_BUILDING )
			{
				//TODO
			}
		}
		
	}

}