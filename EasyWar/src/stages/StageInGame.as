package stages 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		
		static protected const SCROLL_UP:int = 0;
		static protected const SCROLL_DOWN:int = 1;
		static protected const SCROLL_LEFT:int = 2;
		static protected const SCROLL_RIGHT:int = 3;
		
		static protected const SCROLL_VELOCITY:Number = 7.5;
		
		//---------------------------- private member ----------------------------- 
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		protected var m_scrollBars:Array = null;
		
		// mini map
		protected var m_miniMapFrame:Sprite = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		
		protected var m_state:int = 0;
		protected var m_inScrollMap:Boolean = false;
		protected var m_scrollMapVec:Point = new Point();
		
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
			
			m_scrollBars = new Array(4);
			m_scrollBars[SCROLL_UP] = m_ui.getChildByName( "mcScrollUp" ) as SimpleButton;
			m_scrollBars[SCROLL_DOWN] = m_ui.getChildByName( "mcScrollDown" ) as SimpleButton;
			m_scrollBars[SCROLL_LEFT] = m_ui.getChildByName( "mcScrollLeft" ) as SimpleButton;
			m_scrollBars[SCROLL_RIGHT] = m_ui.getChildByName( "mcScrollRight" ) as SimpleButton;
			m_scrollBars[SCROLL_UP].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_UP].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_DOWN].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_DOWN].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_LEFT].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_LEFT].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_RIGHT].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_RIGHT].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			
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
			
			// scroll the map
			if ( m_inScrollMap == true )
			{
				var offsetX:Number = m_scrollMapVec.x * SCROLL_VELOCITY;
				var offsetY:Number = m_scrollMapVec.y * SCROLL_VELOCITY;
				
				m_battlefield.MoveMap( offsetX, offsetY );
			}
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
		
		
		protected function onBeginScrollMap( evt:MouseEvent ):void
		{
			m_inScrollMap = true;
			
			if ( evt.target == m_scrollBars[SCROLL_LEFT] )
			{
				m_scrollMapVec.x = 1;
				m_scrollMapVec.y = 0;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_RIGHT] )
			{
				m_scrollMapVec.x = -1;
				m_scrollMapVec.y = 0;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_UP] )
			{
				m_scrollMapVec.x = 0;
				m_scrollMapVec.y = 1;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_DOWN] )
			{
				m_scrollMapVec.x = 0;
				m_scrollMapVec.y = -1;
			}
		}
		
		protected function onEndScrollMap( evt:MouseEvent ):void
		{
			m_inScrollMap = false;
		}
		
	}

}