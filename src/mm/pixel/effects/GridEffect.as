package mm.pixel.effects
{
	import flash.display.BitmapData;
	
	/**
	 * The GridEffect class creates a grid effect to the RenderLayer. 
	 * <p>
	 * This effect is similar to a scanline effect. 
	 * Instead of removing on every other horizontal row, every other pixel is altered on both the x and y axis.
	 * </p>
	 */
	public class GridEffect extends DefaultEffect
	{	
		/**
		 * Creates a GridEffect instance.
		 */
		public function GridEffect(){}
		
		/**
		 * @inheritDoc
		 */
		public override function postRender( bitmapData:BitmapData ):void
		{	
			var bHeight:int = bitmapData.height;
			for ( var i:int = 0; i <= bHeight; i += 2 )
			{
				var bWidth:int = bitmapData.width;
				for ( var j:int = 0; j <= bWidth; j += 2 )
				{
					bitmapData.setPixel32( int(j), int(i), 0x00000000 );
				}
			}
		}
		
	}
}