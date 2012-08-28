package stages 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gameComponent.Battlefield;
	import gameObj.moveableObj.Tank;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class StageInGame extends BaseStage
	{
		//---------------------------- private member -----------------------------
		
		protected var m_ui:Sprite = null;
		protected var m_gameLayer:Sprite = null;
		protected var m_battlefield:Battlefield = null;
		
		// for mouse action
		protected var m_mouseArea:Sprite = null;
		protected var m_isSelectting:Boolean = false;
		protected var m_isSingleSelect:Boolean = false;
		protected var m_selectStartPos:Point = new Point();
		
		//--------------------------- public function ----------------------------
		
		public function StageInGame() 
		{
			//TODO 
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
			//m_mouseArea.addEventListener( MouseEvent.ROLL_OUT, onEndSelect );
			
			//TODO	ui stuff
			
			this.CANVAS.addChild( m_ui );
			
			// create the game stuff
			m_battlefield = new Battlefield();
			m_battlefield.CANVAS = m_gameLayer;
			
			//[TEMP]
			m_battlefield.Create( 50, 30 );
			
			var tank:Tank = new Tank();
			m_battlefield.AddGameObject( tank, 100, 100 );
			//[TEMP]
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
		
		protected function singleSelect( posX:Number, posY:Number ):void
		{
			//TODO 
		}
		
		protected function groupSelect( rect:Rectangle ):void
		{
			//TODO 
		}
		
		//----------------------------- event function ----------------------------
		
		protected function onStartSelect( evt:MouseEvent ):void
		{
			m_isSelectting = true;
			m_isSingleSelect = true;
			
			var startPosX:Number = evt.localX;
			var startPosY:Number = evt.localY;
			
			m_selectStartPos.x = startPosX;
			m_selectStartPos.y = startPosY;
		}
		
		protected function onSelect( evt:MouseEvent ):void
		{
			if ( m_isSelectting == true )
			{
				m_isSingleSelect = false;
			
				//TODO 
			}
			
			if ( m_isSelectting == false )
			{
				//TODO 	scroll the map
			}
		}
		
		protected function onEndSelect( evt:MouseEvent ):void
		{
			var endPosX:Number = evt.localX;
			var endPosY:Number = evt.localY;
			
			if ( m_isSingleSelect == true )
			{
				// play animation
				var aniSelect:mcSelect = new mcSelect();
				aniSelect.x = endPosX;
				aniSelect.y = endPosY;
				m_mouseArea.addChild( aniSelect );
				aniSelect.play();
				
				// send select message
				singleSelect( endPosX, endPosY );
			}
			
			// group select 
			if ( m_isSingleSelect == false )
			{
				//TODO 
			}
			
			m_isSelectting = false;
		}
		
	}

}