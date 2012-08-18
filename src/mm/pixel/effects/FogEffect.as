package mm.pixel.effects
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The FogEffect class creates a moving fog effect.
	 */
	public class FogEffect extends DefaultEffect
	{
		private var scale:int = 8;
		private var matrix:Matrix = new Matrix ();
		private var offSets:Array = [ new Point(), new Point(), new Point(), new Point() ];
		private var ct:ColorTransform = new ColorTransform();
		private var blur:BlurFilter = new BlurFilter( 3, 3, 1 );
		private var noise:BitmapData;
		private var _speed:Number = .20;
		
		/**
		 * Creates a FogEffect instance.
		 */
		public function FogEffect()
		{	
			matrix.scale ( scale, scale );
			ct.alphaMultiplier = .35;
		}
		/**
		 * @private
		 */
		public override function init( rect:Rectangle ):void
		{
			super.init( rect );
			noise = new BitmapData( Math.ceil( width / scale ), Math.ceil( height / scale ), true, 0 );
		}
		
		/**
		 * A value between 0 and 1 indicating the movement speed of the fog.
		 */
		public function set speed( value:Number ):void
		{
			_speed = Math.min( value, 1 );
		}
		public function get speed():Number
		{
			return _speed;
		}
		
		/**
		 * @inheritDoc 
		 */
		public override function preRender( bitmapData:BitmapData ):void
		{	
			noise.perlinNoise ( noise.width, noise.height, 4, 3, false, false, BitmapDataChannel.ALPHA|BitmapDataChannel.BLUE|BitmapDataChannel.GREEN|BitmapDataChannel.RED, true, offSets );
		
			bitmapData.draw( noise, matrix, null, null, null, true );
			bitmapData.colorTransform( rect, ct );
			bitmapData.applyFilter( bitmapData, rect, ZERO_POINT, blur );
		}
		
		/**
		 * @inheritDoc
		 */
		public override function postRender( bitmapData:BitmapData ):void
		{
			offSets[0].x += _speed;
			offSets[1].x -= _speed;
			offSets[2].x += _speed * .5;
			offSets[3].x -= _speed * .5;
		}
	}
}