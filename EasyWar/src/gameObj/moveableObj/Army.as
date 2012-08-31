package gameObj.moveableObj 
{
	import flash.geom.Point;
	import gameComponent.Command;
	import gameComponent.LifeBar;
	import map.GridInfo;
	import mapItem.MoveableItem;
	
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class Army extends MoveableItem 
	{
		//------------------------------ static member -------------------------------------
		
		//------------------------------ private member ------------------------------------
		
		protected var m_lifeBar:LifeBar = null;
		
		//------------------------------ public function -----------------------------------
		
		/**
		 * @desc	constructor of Army
		 */
		public function Army() 
		{
			super();
			
			// initial the lifebar
			m_lifeBar = new LifeBar();
			m_lifeBar.x = 0;
			m_lifeBar.y = 0;
		}
		
		
		/**
		 * @desc	select
		 */
		override public function set SELECTED( value:Boolean ):void
		{ 
			super.SELECTED = value;
			
			m_lifeBar.visible = this.SELECTED;
		}
		
		
		/**
		 * @desc	update function
		 * @param	elapsed
		 */
		override public function Update( elapsed:Number ):void
		{
			super.Update( elapsed );
			
			var i:int;
			
			// process the order
			if ( m_command != null )
			{
				if ( m_command._type == Command.CMD_MOVE )
				{
					var orgPath:Array = this.findPath( new Point( m_command._destGrid._x, m_command._destGrid._y ) );
					
					var path:Vector.<GridInfo> = new Vector.<GridInfo>();
					for ( i = 1; i < orgPath.length; i++ )					// exclude self
					{
						path.push( m_map.GetGridInfo( orgPath[i].x, orgPath[i].y ) );
					}
					
					this.PATH = path;
				}
				
				if ( m_command._type == Command.CMD_ATTACK )
				{
					//TODO 
				}
				
				m_command = null;
			}
			
			//TODO 
		}
		
		//------------------------------ private function ----------------------------------
		
		//------------------------------- event callback -----------------------------------
		
	}

}