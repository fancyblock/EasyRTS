package Utility 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Hejiabin
	 */
	public class MathCalculator 
	{
		
		/**
		 * @desc	return the rect by two point
		 * @param	pt1X
		 * @param	pt1Y
		 * @param	pt2X
		 * @param	pt2Y
		 * @return
		 */
		static public function GetRectBy2Spot( pt1X:Number, pt1Y:Number, pt2X:Number, pt2Y:Number ):Rectangle
		{	
			var width:Number = Math.abs( pt1X - pt2X );
			var height:Number = Math.abs( pt1Y - pt2Y );
			var left:Number = pt1X < pt2X ? pt1X : pt2X;
			var top:Number = pt1Y < pt2Y ? pt1Y : pt2Y;
			
			var rect:Rectangle = new Rectangle( left, top, width, height );
			
			return rect;
		}
		
		
		/**
		 * @desc	convert the vector to the angle ( in degree )
		 * @param	vec
		 * @return
		 */
		static public function VectorToAngle( vec:Point ):Number
		{
			var angle:Number = 0;
			
			angle = Math.atan2( vec.y, vec.x );
			
			// convert to degree
			angle = angle / Math.PI * 180.0;
			
			return angle;
		}
	}

}