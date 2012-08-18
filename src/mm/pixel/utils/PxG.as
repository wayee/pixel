package mm.pixel.utils
{
	import mm.pixel.PxCamera;

	/**
	 * Pixel游戏全局助手
	 *  
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public class PxG
	{
		/**
		 * @see PxCamera
		 */
		public static var camera:PxCamera = PxCamera.getInstance();
		/**
		 * @see PxCollection
		 */
		public static var pxCollection:PxCollection = PxCollection.getInstance();
		
		/**
		 * 是否整个显示对象都只有Camera大小
		 * <li> 如果是的话，Camera会虚拟地移动到0,0位置，然后渲染对象
		 * <li> 如果否的话，Cmaera会移动到本来的位置，然后渲染对象 
		 */		
		public static var isGlobalGamera:Boolean = true;

	}
}