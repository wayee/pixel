package mm.pixel.effects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * The GlowEffect class creates a glow effect based on the colors of the layer. 
	 * This effect works best on top of dark backgrounds.
	 */
	public class GlowEffect extends DefaultEffect
	{
		private var blurBig:BlurFilter = new BlurFilter( 10, 10, 1 );
		private var ct:ColorTransform = new ColorTransform();
		private var convolution:ConvolutionFilter;
		private var temp:BitmapData;
		
		/**
		 * Creates a GlowEffect instance.
		 */
		public function GlowEffect()
		{
			ct.alphaMultiplier 	= .25;
			ct.redMultiplier 	= 1.5;
			ct.greenMultiplier 	= 1.5;
			ct.blueMultiplier 	= 1.5;
			
			convolution = new ConvolutionFilter(
			3,
			3,
			[0, 0, 0, 
			 0, 2, 0, 
			 0, 0, 0],
			1,
			-255,
			true,
			true,
			0x000000,
			0);
		}
		
		/**
		 * @private
		 */
		public override function init( rect:Rectangle ):void
		{
			super.init( rect );
			temp = new BitmapData( width, height, true, 0 );
		}
		
		/**
		 * @inheritDoc 
		 */
		public override function preRender( bitmapData:BitmapData ):void
		{
			bitmapData.colorTransform( rect, ct );
			temp.fillRect( rect, 0 );
			temp.copyPixels( bitmapData, rect, ZERO_POINT, null, null, true );
		} 
		
		/**
		 * @inheritDoc 
		 */
		public override function postRender( bitmapData:BitmapData ):void
		{
			temp.applyFilter( temp, rect, ZERO_POINT, convolution );
			temp.applyFilter( temp, rect, ZERO_POINT, blurBig );
			
			bitmapData.draw( temp, null, null, BlendMode.ADD );
		}
		
	}
}