package stages 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameComponent.Battlefield;
	import gameObj.moveableObj.Tank;
	import Utility.MathCalculator;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		//---------------------------- static member ------------------------------
		
		static protected const STATE_NORMAL:int = 0;
		static protected const STATE_ORDER:int = 1;
		static protected const STATE_BUILDING:int = 2;
		static protected const STATE_SELL:int = 3;
		
		//---------------------------- private member ----------------------------- 
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		protected var m_isSelectting:Boolean = false;
		protected var m_isSingleSelect:Boolean = false;
		protected var m_selectStartPos:Point = new Point();
		
		// mini map
		protected var m_miniMapFrame:Sprite = null;
		
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
			m_mouseArea.addEventListener( MouseEvent.MOUSE_DOWN, onStartSelect );
			m_mouseArea.addEventListener( MouseEvent.MOUSE_MOVE, onSelect );
			m_mouseArea.addEventListener( MouseEvent.MOUSE_UP, onEndSelect );
			
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
			m_battlefield.AddGameObject( tank, 100, 100 );
			//[TEMP]
			
			// set game state
			m_state = STATE_NORMAL;
		}
		
		override public function onFrame(elapsed:Number):void 
		{
			m_battlefield.Update( elapsed );
			
			//TODO 
		}
		
		override public function onLeave():void 
		{
			//TODO 
			
			this.CANVAS.removeChild( m_ui );
			this.CANVAS.removeChild( m_gameLayer );
		}
		
		
		//--------------------------- private function ----------------------------
		
		// single select your troop
		protected function singleSelect( posX:Number, posY:Number ):void
		{
			//TODO 
		}
		
		// group select your troop
		protected function groupSelect( rect:Rectangle ):void
		{
			//TODO 
		}
		
		// order selected troop to attack or move
		protected function orderSpot( xPos:Number, yPos:Number ):void
		{
			//TODO 
		}
		
		// scroll the map
		protected function scrollMap( xPos:Number, yPos:Number ):void
		{
			//TODO 
		}
		
		// build the building at this position
		protected function buildingAt( xPos:Number, yPos:Number ):void
		{
			//TODO 
		}
		
		// cell the building at this position
		protected function sellBuilding( xPos:Number, yPos:Number ):void
		{
			//TODO 
		}
		
		//----------------------------- event function ----------------------------
		
		protected function onStartSelect( evt:MouseEvent ):void
		{
			if( m_state == STATE_NORMAL || m_state == STATE_ORDER )
			{
				m_isSelectting = true;
				m_isSingleSelect = true;
				
				var startPosX:Number = evt.localX;
				var startPosY:Number = evt.localY;
				
				m_selectStartPos.x = startPosX;
				m_selectStartPos.y = startPosY;
			}
			
			if ( m_state == STATE_BUILDING )
			{
				buildingAt( evt.localX, evt.localY );
			}
			
			if ( m_state == STATE_ORDER )
			{
				orderSpot( evt.localX, evt.localY );
			}
			
			if ( m_state == STATE_SELL )
			{
				sellBuilding( evt.localX, evt.localY );
			}
		}
		
		protected function onSelect( evt:MouseEvent ):void
		{
			if ( m_state == STATE_NORMAL || m_state == STATE_ORDER )
			{
				if ( m_isSelectting == true )
				{
					m_isSingleSelect = false;
				
					// draw the rect
					m_mouseArea.graphics.clear();
					m_mouseArea.graphics.lineStyle( 1, 0xff0000 );
					var rect:Rectangle = MathCalculator.GetRectBy2Spot( evt.localX, evt.localY, m_selectStartPos.x, m_selectStartPos.y );
					m_mouseArea.graphics.drawRect( rect.left, rect.top, rect.width, rect.height );
					
				}
			}
			
			//TODO 	scroll the map
			if ( m_isSelectting == false )
			{
				scrollMap( evt.localX, evt.localY ); 
			}
		}
		
		protected function onEndSelect( evt:MouseEvent ):void
		{
			if ( m_state == STATE_NORMAL || m_state == STATE_ORDER || m_isSelectting == true )
			{
				var endPosX:Number = evt.localX;
				var endPosY:Number = evt.localY;
				
				if ( m_isSingleSelect == true )
				{
					// play animation
					var aniSelect:mcSelect = new mcSelect();
					aniSelect.x = endPosX;
					aniSelect.y = endPosY;
					m_gameLayer.addChild( aniSelect );
					aniSelect.play();
					
					// send select message
					singleSelect( endPosX, endPosY );
				}
				
				// group select 
				if ( m_isSingleSelect == false )
				{
					var rect:Rectangle = MathCalculator.GetRectBy2Spot( evt.localX, evt.localY, m_selectStartPos.x, m_selectStartPos.y );
					this.groupSelect( rect );
					
					// clear the rect
					m_mouseArea.graphics.clear();
				}
				
				m_isSelectting = false;
			}
		}
		
	}

}