package mm.pixel.effects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	 * The TrailsEffect class creates blurred trail effect behind the layer.
	 */
	public class TrailsEffect extends DefaultEffect
	{
		private var ct:ColorTransform = new ColorTransform();
		private var ct2:ColorTransform = new ColorTransform();
		private var blur:BlurFilter = new BlurFilter( 3, 3, 2 );
		private var temp:BitmapData;
		
		/**
		 * Creates a TrailsEffect instance.
		 */
		public function TrailsEffect()
		{
			ct.alphaMultiplier = .85;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function preRender( bitmapData:BitmapData ):void
		{	
			bitmapData.applyFilter( bitmapData, rect, ZERO_POINT, blur );
			
			bitmapData.colorTransform( rect, ct );
		}
	}
}