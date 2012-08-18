package mm.pixel.utils
{
	import flash.display.BitmapData;
	
	/**
	 * 存储和管理BitmapData对象的集合
	 * <li> 确保BitmapData对象没有重复创建
	 *  
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public final class PxCollection
	{
		public static var instance:PxCollection;
		public static var allowInstance:Boolean;
		
		public var collection:Object = {};
		
		public function PxCollection()
		{
			if ( !allowInstance )
			{
				throw new Error( "BitmapDataCollection is a singleton. " + 
								 "Use the getInstance method to create an instance."
								);
			}
		}
		
		public static function getInstance():PxCollection
		{
			if ( !instance )
			{
				allowInstance = true;
				instance = new PxCollection();
				allowInstance = false;
			}
			return instance;
		}
		
		public function addBitmapData( id:String, frameInfo:PxFrameInfo ):PxFrameInfo
		{	
			collection[ id ] = frameInfo;
			return collection[ id ];
		}
		
		public function search( item:String ):Boolean
		{
			if ( collection[ item ] )
			{
				return true;
			}
			return false;
		}
		
		public function dispose():void
		{
			for each ( var p:PxFrameInfo in collection )
			{
				p.bitmapData.dispose();
				p = null;
			}
			collection = {};
		}
		
		public function removeBitmapData( frameInfo:PxFrameInfo ):Boolean
		{
			for each ( var p:PxFrameInfo in collection )
			{
				if ( p === frameInfo )
				{
					p.bitmapData.dispose();
					p = null;
					return true;
				}
			}
			return false;
		}
	}
}