package stages 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameComponent.Battlefield;
	import gameObj.moveableObj.Tank;
	import map.MiniMap;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		//---------------------------- static member ------------------------------
		
		static protected const STATE_NORMAL:int = 0;
		//TODO
		
		static protected const SELF_GROUP:int = 0;
		static protected const ENEMY_GROUP:int = 1;
		
		static protected const SCROLL_UP:int = 0;
		static protected const SCROLL_DOWN:int = 1;
		static protected const SCROLL_LEFT:int = 2;
		static protected const SCROLL_RIGHT:int = 3;
		
		static protected const SCROLL_VELOCITY:Number = 10;
		
		static protected const VIEWPORT_WIDTH:int = 1024;
		static protected const VIEWPORT_HEIGHT:int = 558;
		
		static protected const SELECT_FRAME_COLOR:uint = 0xfa3399;
		
		//---------------------------- private member ----------------------------- 
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		protected var m_scrollBars:Array = null;
		
		// mini map
		protected var m_miniMapFrame:Sprite = null;
		protected var m_miniMap:MiniMap = null;
		protected var m_miniMapMouseArea:Sprite = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		protected var m_isMouseDown:Boolean = false;
		protected var m_startMousePos:Point = new Point();
		
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
			m_mouseArea.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			m_mouseArea.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			m_mouseArea.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
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
			m_miniMapMouseArea = m_ui.getChildByName( "mcMiniMapMouseArea" ) as Sprite;
			m_miniMapMouseArea.addEventListener( MouseEvent.CLICK, onClkMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_DOWN, onStartDragMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_MOVE, onDragMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_UP, onStopDragMiniMap );
			m_miniMap = new MiniMap( 90, 90 );
			m_miniMap.width = m_miniMapFrame.width;
			m_miniMap.height = m_miniMapFrame.height;
			m_miniMapFrame.addChild( m_miniMap );
			
			// create the game stuff
			m_battlefield = new Battlefield();
			m_battlefield.SetViewport( VIEWPORT_WIDTH, VIEWPORT_HEIGHT );
			m_battlefield.CANVAS = m_gameLayer;
			
			//[hack]
			m_battlefield.RandomCreate( 90, 90 );
			//[hack]
			
			// set the mini map
			m_battlefield.MAP.MINI_MAP = m_miniMap;
			m_miniMap.SetViewPort( -m_battlefield.MAP_OFFSET.x / m_battlefield.MAP.MAP_SIZE_WIDTH,
									-m_battlefield.MAP_OFFSET.y / m_battlefield.MAP.MAP_SIZE_HEIGHT,
									VIEWPORT_WIDTH / m_battlefield.MAP.MAP_SIZE_WIDTH,
									VIEWPORT_HEIGHT / m_battlefield.MAP.MAP_SIZE_HEIGHT );
			
			//[hack]
			m_battlefield.AddGameObject( new Tank(), 5, 5 );
			m_battlefield.AddGameObject( new Tank(), 5, 6 );
			m_battlefield.AddGameObject( new Tank(), 5, 7 );
			m_battlefield.AddGameObject( new Tank(), 7, 5 );
			m_battlefield.AddGameObject( new Tank(), 8, 5 );
			m_battlefield.AddGameObject( new Tank(), 5, 8 );
			m_battlefield.AddGameObject( new Tank(), 13, 5, ENEMY_GROUP );
			//[hack]
			
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
				
				m_miniMap.SetViewPort( -m_battlefield.MAP_OFFSET.x / m_battlefield.MAP.MAP_SIZE_WIDTH,
									-m_battlefield.MAP_OFFSET.y / m_battlefield.MAP.MAP_SIZE_HEIGHT,
									VIEWPORT_WIDTH / m_battlefield.MAP.MAP_SIZE_WIDTH,
									VIEWPORT_HEIGHT / m_battlefield.MAP.MAP_SIZE_HEIGHT );
			}
		}
		
		override public function onLeave():void 
		{
			//TODO 
			
			this.CANVAS.removeChild( m_ui );
			this.CANVAS.removeChild( m_gameLayer );
		}
		
		
		//--------------------------- private function ----------------------------
		
		// group select your troop
		protected function selectUnits( rect:Rectangle ):void
		{
			var cnt:int = m_battlefield.SelectUnits( rect, SELF_GROUP );
			
			//TODO 
		}
		
		// order selected troop to attack or move
		protected function orderSpot( xPos:Number, yPos:Number ):void
		{
			//TODO 
			
			m_battlefield.OrderSpot( xPos, yPos );
			
			playAniMoveDest( xPos, yPos );
		}
		
		// play the move animation
		protected function playAniMoveDest( xPos:Number, yPos:Number ):void
		{
			// play animation
			var aniSelect:mcSelect = new mcSelect();
			aniSelect.x = xPos;
			aniSelect.y = yPos;
			m_gameLayer.addChild( aniSelect );
			aniSelect.play();
		}
		
		//----------------------------- event function ---------------------------- 
		
		protected function onMouseDown( evt:MouseEvent ):void
		{
			m_isMouseDown = true;
			
			m_startMousePos.x = evt.localX;
			m_startMousePos.y = evt.localY;
		}
		
		protected function onMouseMove( evt:MouseEvent ):void
		{
			if ( m_isMouseDown )
			{
				m_mouseArea.graphics.clear();
				m_mouseArea.graphics.lineStyle( 1, SELECT_FRAME_COLOR );
				var rect:Rectangle = MathCalculator.GetRectBy2Spot( evt.localX, evt.localY, m_startMousePos.x, m_startMousePos.y );
				m_mouseArea.graphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			}
		}
		
		protected function onMouseUp( evt:MouseEvent ):void
		{
			m_isMouseDown = false;
			
			var rect:Rectangle = MathCalculator.GetRectBy2Spot( evt.localX, evt.localY, m_startMousePos.x, m_startMousePos.y );
			
			// no move
			if ( rect.width == 0 && rect.height == 0 )
			{
				var selected:Boolean = m_battlefield.SelectUnit( evt.localX, evt.localY, SELF_GROUP );
				
				if ( selected == false )
				{
					orderSpot( evt.localX, evt.localY );
				}
			}
			else
			{
				selectUnits( rect );
			}
			
			m_mouseArea.graphics.clear();
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
		
		//----------------------------------------------- mini map stuff ------------------------------------------
		
		protected function onClkMiniMap( evt:MouseEvent ):void
		{
			m_battlefield.OrderSpotGrid( evt.localX * m_battlefield.MAP.WIDTH / m_miniMapMouseArea.width,
										evt.localY * m_battlefield.MAP.HEIGHT / m_miniMapMouseArea.height );
		}
		
		protected function onStartDragMiniMap( evt:MouseEvent ):void
		{
			//TODO 
		}
		
		protected function onDragMiniMap( evt:MouseEvent ):void
		{
			//TODO 
		}
		
		protected function onStopDragMiniMap( evt:MouseEvent ):void
		{
			//TODO 
		}
		
	}

}