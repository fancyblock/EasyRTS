package map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MiniMap extends Sprite 
	{
		//------------------------------ static member -------------------------------------
		
		static protected const COLOR_BLANK:uint = 0xeaa477;
		static protected const COLOR_BLOCK:uint = 0x123456;
		
		static protected const COLOR_SELF_GROUP:uint = 0xff00ff00;
		static protected const COLOR_ENEMY_GROUP:uint = 0xffff0000;
		
		//------------------------------ private member ------------------------------------
		
		protected var m_width:Number = 0;
		protected var m_height:Number = 0;
		
		protected var m_mapLayer:Bitmap = null;
		protected var m_mapData:BitmapData = null;
		
		protected var m_unitLayer:Bitmap = null;
		protected var m_unitData:BitmapData = null;
		
		protected var m_viewportLayer:Sprite = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of MiniMap
		 */
		public function MiniMap( wid:int, hei:int )
		{
			super();
			
			m_width = wid;
			m_height = hei;
			
			// map layer
			m_mapData = new BitmapData( wid, hei );
			m_mapLayer = new Bitmap( m_mapData );
			
			// unit layer
			m_unitData = new BitmapData( wid, hei );
			m_unitLayer = new Bitmap( m_unitData );
			
			// viewport layer
			m_viewportLayer = new Sprite();
			
			this.addChild( m_mapLayer );
			this.addChild( m_unitLayer );
			this.addChild( m_viewportLayer );
		}
		
		
		/**
		 * @desc	create map bg
		 * @param	map
		 */
		public function CreateMapBG( theMap:GridMap ):void
		{
			for ( var i:int = 0; i < theMap.WIDTH; i++ )
			{
				for ( var j:int = 0; j < theMap.HEIGHT; j++ )
				{
					var gridInfo:GridInfo = theMap.GetGridInfo( i, j );
					
					if ( gridInfo._type == GridInfo.BLOCK )
					{
						m_unitData.setPixel( i, j, COLOR_BLOCK );
					}
					else
					{
						m_unitData.setPixel( i, j, COLOR_BLANK );
					}
				}
			}
		}
		
		
		/**
		 * @desc	set the viewport frame
		 * @param	u1
		 * @param	v1
		 * @param	u2
		 * @param	v2
		 */
		public function SetViewPort( u1:Number, v1:Number, uh:Number, vh:Number ):void
		{
			m_viewportLayer.graphics.clear();
			m_viewportLayer.graphics.lineStyle( 1, 0xff4000 );
			
			m_viewportLayer.graphics.drawRect( m_width * u1, m_height * v1, m_width * uh, m_height * vh );
		}
		
		
		/**
		 * @desc	set the troop
		 * @param	xPos
		 * @param	yPos
		 * @param	group
		 */
		public function SetTroop( xPos:int, yPos:int, group:int ):void
		{
			if ( group == 0 )		//[hack]
			{
				m_unitData.setPixel( xPos, yPos, COLOR_SELF_GROUP );
			}
			else
			{
				m_unitData.setPixel( xPos, yPos, COLOR_ENEMY_GROUP );
			}
		}
		
		
		/**
		 * @desc	clean the troop
		 * @param	xPos
		 * @param	yPos
		 */
		public function CleanTroop( xPos:int, yPos:int ):void
		{
			m_unitData.setPixel( xPos, yPos, COLOR_BLANK );
		}
		
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}