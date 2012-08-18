package mm.pixel
{	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 摄像机 
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public class PxCamera
	{
		private static var instance:PxCamera;
		private static var allowInstance:Boolean;

		private var distX:int;
		private var distY:int;
		
		public var ease:Number = .1;
		public var target:Point;
		public var basePoint:Point = new Point();
		public var boundary:Rectangle = new Rectangle();
		
		public function PxCamera()
		{
			if ( !allowInstance )
			{
				throw new Error( "PxCamera是单例" );
			}
		}
		
		public static function getInstance():PxCamera
		{
			if ( !instance )
			{
				allowInstance = true;
				instance = new PxCamera();
				allowInstance = false;
			}
			return instance;
		}
		
		public function scroll():void
		{
			if ( target )
			{
				scrollTarget();
			}
		}
		
		private function scrollTarget():void
		{	
			// horizontal
			if ( target.x < boundary.right && target.x > boundary.left )
			{
				distX = boundary.left - target.x - basePoint.x;
				basePoint.x += distX * ease;
			}
			else
			{
				if ( target.x > boundary.right )
				{
					distX = boundary.left - ( boundary.right + basePoint.x ); 
					basePoint.x += distX * ease;
				}
				 if ( target.x < boundary.left )
				{
					distX = boundary.left - ( boundary.left + basePoint.x ); 
					basePoint.x += distX * ease;
				}
			}
			// vertical
			if ( target.y < boundary.bottom && target.y > boundary.top )
			{
				distY = boundary.top - target.y - basePoint.y;
				basePoint.y += distY * ease;
			}
			else
			{
				if ( target.y > boundary.bottom )
				{
					distY = boundary.top - ( boundary.bottom + basePoint.y ); 
					basePoint.y += distY * ease;
				}
				if ( target.y < boundary.top )
				{
					distY = boundary.top - ( boundary.top + basePoint.y ); 
					basePoint.y += distY * ease;
				}
			}
		}
	}
}