package stages 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import gameComponent.Battlefield;
	import gameComponent.Command;
	import gameObj.building.Arsenal;
	import gameObj.UnitTypes;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		//---------------------------- static member ------------------------------
		
		static protected const MOUSE_MOVE_MIN:Number = 7.0;
		
		static protected const SCROLL_UP:int = 0;
		static protected const SCROLL_DOWN:int = 1;
		static protected const SCROLL_LEFT:int = 2;
		static protected const SCROLL_RIGHT:int = 3;
		static protected const SCROLL_LEFT_TOP:int = 4;
		static protected const SCROLL_RIGHT_TOP:int = 5;
		static protected const SCROLL_LEFT_BOTTOM:int = 6;
		static protected const SCROLL_RIGHT_BUTTON:int = 7;
		
		static protected const SCROLL_VELOCITY:Number = 10;
		
		static protected const VIEWPORT_WIDTH:int = 1024;
		static protected const VIEWPORT_HEIGHT:int = 722;
		
		static protected const SELECT_FRAME_COLOR:uint = 0xfa3399;
		
		//---------------------------- private member ----------------------------- 
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		protected var m_scrollBars:Array = null;
		protected var m_btnExit:SimpleButton = null;
		protected var m_txtMoney:TextField = null;
		protected var m_txtArmyCnt:TextField = null;
		protected var m_txtCityCnt:TextField = null;
		protected var m_uiFactory:Sprite = null;
		protected var m_btnMakeTank:SimpleButton = null;
		protected var m_btnMakeSoldier:SimpleButton = null;
		
		// mini map
		protected var m_miniMapCom:Sprite = null;
		protected var m_miniMapFrame:Sprite = null;
		protected var m_miniMapMouseArea:Sprite = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		protected var m_isMouseDown:Boolean = false;
		protected var m_startMousePos:Point = new Point();
		
		protected var m_inScrollMap:Boolean = false;
		protected var m_scrollMapVec:Point = new Point();
		
		protected var m_currentArsenal:Arsenal = null;
		
		protected var m_money:Number = 0;
		
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
			
			// map scroll stuff
			m_scrollBars = new Array(8);
			m_scrollBars[SCROLL_UP] = m_ui.getChildByName( "mcScrollUp" ) as SimpleButton;
			m_scrollBars[SCROLL_DOWN] = m_ui.getChildByName( "mcScrollDown" ) as SimpleButton;
			m_scrollBars[SCROLL_LEFT] = m_ui.getChildByName( "mcScrollLeft" ) as SimpleButton;
			m_scrollBars[SCROLL_RIGHT] = m_ui.getChildByName( "mcScrollRight" ) as SimpleButton;
			m_scrollBars[SCROLL_LEFT_TOP] = m_ui.getChildByName( "mcScrollLeftTop" ) as SimpleButton;
			m_scrollBars[SCROLL_LEFT_BOTTOM] = m_ui.getChildByName( "mcScrollLeftBottom" ) as SimpleButton;
			m_scrollBars[SCROLL_RIGHT_TOP] = m_ui.getChildByName( "mcScrollRightTop" ) as SimpleButton;
			m_scrollBars[SCROLL_RIGHT_BUTTON] = m_ui.getChildByName( "mcScrollRightBottom" ) as SimpleButton;
			
			m_scrollBars[SCROLL_UP].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_UP].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_DOWN].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_DOWN].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_LEFT].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_LEFT].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_RIGHT].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_RIGHT].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			
			m_scrollBars[SCROLL_LEFT_TOP].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_LEFT_TOP].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_LEFT_BOTTOM].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_LEFT_BOTTOM].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_RIGHT_TOP].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_RIGHT_TOP].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			m_scrollBars[SCROLL_RIGHT_BUTTON].addEventListener( MouseEvent.ROLL_OVER, onBeginScrollMap );
			m_scrollBars[SCROLL_RIGHT_BUTTON].addEventListener( MouseEvent.ROLL_OUT, onEndScrollMap );
			
			m_btnExit = m_ui.getChildByName( "btnExit" ) as SimpleButton;
			m_txtArmyCnt = m_ui.getChildByName( "txtTroopCnt" ) as TextField;
			m_txtCityCnt = m_ui.getChildByName( "txtCityCnt" ) as TextField;
			m_txtMoney = m_ui.getChildByName( "txtMoneyCnt" ) as TextField;
			
			// factory stuff
			m_uiFactory = new mcFactoryUI();
			m_btnMakeTank = m_uiFactory.getChildByName( "btnTank" ) as SimpleButton;
			m_btnMakeSoldier = m_uiFactory.getChildByName( "btnSoldier" ) as SimpleButton;
			m_btnMakeTank.addEventListener( MouseEvent.CLICK, onMakeTroop );
			m_btnMakeSoldier.addEventListener( MouseEvent.CLICK, onMakeTroop );
			m_mouseArea.addChild( m_uiFactory );
			m_uiFactory.visible = false;
			
			m_btnExit.addEventListener( MouseEvent.CLICK, onExitGame );
			
			this.CANVAS.addChild( m_ui );
			
			// mini map
			m_miniMapCom = m_ui.getChildByName( "mcMiniMapCom" ) as Sprite;
			m_miniMapFrame = m_miniMapCom.getChildByName( "mcMiniMapFrame" ) as Sprite;
			m_miniMapMouseArea = m_miniMapCom.getChildByName( "mcMiniMapMouseArea" ) as Sprite;
			m_miniMapMouseArea.addEventListener( MouseEvent.CLICK, onClkMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_DOWN, onStartDragMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_MOVE, onDragMiniMap );
			m_miniMapMouseArea.addEventListener( MouseEvent.MOUSE_UP, onStopDragMiniMap );
			
			// create the game stuff
			m_battlefield = new Battlefield();
			m_battlefield.SetViewport( VIEWPORT_WIDTH, VIEWPORT_HEIGHT );
			m_battlefield.CANVAS = m_gameLayer;
			
			m_battlefield.CreateRandomMap( 50, 50 );
			
			m_battlefield.MINI_MAP.width = m_miniMapFrame.width;
			m_battlefield.MINI_MAP.height = m_miniMapFrame.height;
			m_miniMapFrame.addChild( m_battlefield.MINI_MAP );
			
			// set the mini map
			m_battlefield.MINI_MAP.SetViewPort( -m_battlefield.MAP_OFFSET.x / m_battlefield.MAP.MAP_SIZE_WIDTH,
									-m_battlefield.MAP_OFFSET.y / m_battlefield.MAP.MAP_SIZE_HEIGHT,
									VIEWPORT_WIDTH / m_battlefield.MAP.MAP_SIZE_WIDTH,
									VIEWPORT_HEIGHT / m_battlefield.MAP.MAP_SIZE_HEIGHT );
			
			//TODO 
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
				
				m_battlefield.MINI_MAP.SetViewPort( -m_battlefield.MAP_OFFSET.x / m_battlefield.MAP.MAP_SIZE_WIDTH,
									-m_battlefield.MAP_OFFSET.y / m_battlefield.MAP.MAP_SIZE_HEIGHT,
									VIEWPORT_WIDTH / m_battlefield.MAP.MAP_SIZE_WIDTH,
									VIEWPORT_HEIGHT / m_battlefield.MAP.MAP_SIZE_HEIGHT );
				
				displayFactoryUI( false );
			}
			
			m_money += ( 0.1 + m_battlefield.SELF_CITY_CNT * 0.1 );
			
			//update ui
			m_txtArmyCnt.text = m_battlefield.SELF_TROOP_CNT + "";
			m_txtCityCnt.text = m_battlefield.SELF_CITY_CNT + "";
			m_txtMoney.text = (int)(m_money) + "";
			
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
			var cnt:int = m_battlefield.SelectUnits( rect, UnitTypes.SELF_GROUP );
			
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
		
		
		// show or hide the factory ui
		protected function displayFactoryUI( show:Boolean ):void
		{
			m_currentArsenal = null;
			
			if ( show == true )
			{
				var factory:Arsenal = m_battlefield.SELECTED_BUILDING;
				
				if ( factory != null )
				{
					m_currentArsenal = factory;
					
					m_uiFactory.x = factory.POSITION.x + m_battlefield.MAP_OFFSET.x;
					m_uiFactory.y = factory.POSITION.y + m_battlefield.MAP_OFFSET.y;
					
					m_uiFactory.visible = true;
				}
				
				if ( factory == null )
				{
					m_uiFactory.visible = false;
				}
			}
			
			if ( show == false )
			{
				m_uiFactory.visible = false;
			}
		}
		
		//----------------------------- event function ---------------------------- 
		
		protected function onMouseDown( evt:MouseEvent ):void
		{
			if ( evt.target != m_mouseArea ) return;
			
			m_isMouseDown = true;
			
			m_startMousePos.x = evt.localX;
			m_startMousePos.y = evt.localY;
		}
		
		protected function onMouseMove( evt:MouseEvent ):void
		{
			if ( evt.target != m_mouseArea ) return;
			
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
			if ( evt.target != m_mouseArea ) return;
			
			m_isMouseDown = false;
			
			var rect:Rectangle = MathCalculator.GetRectBy2Spot( evt.localX, evt.localY, m_startMousePos.x, m_startMousePos.y );
			var distance:Point = m_startMousePos.subtract( new Point( evt.localX, evt.localY ) );
			
			// no move
			if ( distance.length < MOUSE_MOVE_MIN )
			{
				var selected:Boolean = m_battlefield.SelectUnit( evt.localX, evt.localY, UnitTypes.SELF_GROUP );
				
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
			
			displayFactoryUI( true );
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
			
			if ( evt.target == m_scrollBars[SCROLL_LEFT_TOP] )
			{
				m_scrollMapVec.x = 1;
				m_scrollMapVec.y = 1;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_LEFT_BOTTOM] )
			{
				m_scrollMapVec.x = 1;
				m_scrollMapVec.y = -1;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_RIGHT_TOP] )
			{
				m_scrollMapVec.x = -1;
				m_scrollMapVec.y = 1;
			}
			
			if ( evt.target == m_scrollBars[SCROLL_RIGHT_BUTTON] )
			{
				m_scrollMapVec.x = -1;
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
		
		// exit the game & back to the main menu
		protected function onExitGame( evt:MouseEvent ):void
		{
			StageManager.SINGLETON.StartStage( "MainMenu" );
		}
		
		
		// make a troop from current factory
		protected function onMakeTroop( evt:MouseEvent ):void
		{
			var needMoney:Number = 0;
			var command:Command = new Command();
			command._type = Command.CMD_PRODUCE;
			
			if ( evt.target == m_btnMakeSoldier )
			{
				trace( "Make a soldier" );
				needMoney = 30;
				
				command._unitType = UnitTypes.TYPE_INFANTRY;
			}
			
			if ( evt.target == m_btnMakeTank )
			{
				trace( "Make a tank" );
				needMoney = 60;
				
				command._unitType = UnitTypes.TYPE_TANK
			}
			
			// check the money & arsenal state
			if ( m_money > needMoney )
			{
				m_money -= needMoney;
				
				m_currentArsenal.SendCommand( command );
			}
		}
		
	}

}