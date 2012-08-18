package mm.pixel.effects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * The DefaultEfect class clears the RenderLayer instance prior to being rendered.
	 */
	public class DefaultEffect implements IEffect
	{
		protected var rect:Rectangle;
		protected var width:int;
		protected var height:int;
		protected const ZERO_POINT:Point = new Point();
		
		public function DefaultEffect()
		{
		}
		
		/**
		 * @private
		 */
		public function init( rect:Rectangle ):void
		{
			this.rect = rect;
			width = rect.width;
			height = rect.height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function preRender( bitmapData:BitmapData ):void
		{
			bitmapData.fillRect( rect, 0 );
		}
		
		/**
		 * @inheritDoc
		 */
		public function postRender( bitmapData:BitmapData ):void
		{
		}
		
	}
}