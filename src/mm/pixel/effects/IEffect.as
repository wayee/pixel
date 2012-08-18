package mm.pixel.effects
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * The IEffect interface is implemented by objects that can be registered as an effect to a RenderLayer instance.
	 */
	public interface IEffect
	{	
		function init ( rect:Rectangle ):void
		
		/**
		 * [internal]
		 * Executes before the layer has been rendered.
		 * 
		 */
		function preRender( bitmapData:BitmapData ):void
		
		/**
		 * [internal]
		 * Executes after the layer has been rendered. 
		 */
		function postRender( bitmapData:BitmapData ):void
	}
}