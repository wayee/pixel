package mm.pixel
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import mm.pixel.utils.PxFrameInfo;
	import mm.pixel.utils.PxU;
	
	/**
	 * 分析sprite sheet并实现动画，继承于BxSprite
	 *  
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public class PxSpriteSheet extends PxObject
	{
		protected var _currentFrame:int;
		protected var animation:Vector.<PxFrameInfo>;
		protected var isPlaying:Boolean = true;
		
		private var _unit:Rectangle;
		
		public function PxSpriteSheet(bmd:BitmapData, uWidth:int, uHeight:int, dispX:int=0, dispY:int=0)
		{
			parseSpriteSheet(bmd, uWidth, uHeight);
			
			rect 	= bitmapData.rect;
			width 	= bitmapData.width;
			height 	= bitmapData.height;
			
			// 应该是bmd的显示对象的x, y
			x 		= dispX; 
			y 		= dispY;
			
			super();
		}
		
		/**
		 * 分析并转换一个显示对象的每个帧动画到一个可视帧 
		 * @param displayObject
		 * 
		 */
		private function parseSpriteSheet(bmd:BitmapData, uWidth:int, uHeight:int):void
		{
			_unit = new Rectangle(0, 0, uWidth, uHeight);
			
			animation = PxU.spriteSheetToBitmapMovie(bmd, _unit, true, 0x0);

			bitmapData = animation[_currentFrame].bitmapData;
		}
		
		/**
		 * 渲染 
		 */
		override public function update():void
		{
			if ( isPlaying ) {
				if ( _currentFrame < totalFrames - 1 ) {
					_currentFrame++;
				} else {
					_currentFrame = 0;
				}
			}
			
			bitmapData = animation[ _currentFrame ].bitmapData;
			super.update();
		}
		
		/**
		 * 从当前帧开始播放
		 */
		public function play():void
		{
			isPlaying = true;
		}
		
		/**
		 * 停止在当前帧
		 */
		public function stop():void
		{
			isPlaying = false;
		}
		
		/**
		 * 跳到某帧并播放
		 * @param frame 帧数
		 * 
		 */
		public function gotoAndPlay(frame:int):void
		{
			if (frame < 0)  {
				currentFrame = 0; 
			} else if (frame > totalFrames - 1) {
				currentFrame = totalFrames - 1;
			} else {
				currentFrame = frame;
			}
			isPlaying = true;
		}
		
		/**
		 * 跳到某帧并停止
		 * @param frame 帧数
		 * 
		 */
		public function gotoAndStop(frame:int):void
		{
			if (frame < 0)  {
				currentFrame = 0; 
			} else if (frame > totalFrames - 1) {
				currentFrame = totalFrames - 1;
			} else {
				currentFrame = frame;
			}
			isPlaying = false;
			
			width = animation[currentFrame].bitmapData.width;
			height = animation[currentFrame].bitmapData.height;
		}
		
		/**
		 * 移动到一下帧并停止播放
		 */
		public function nextFrame():void
		{
			currentFrame = Math.min(currentFrame + 1, totalFrames - 1);
			isPlaying = false;
		}
		
		/**
		 * 移动到上一帧并停止播放
		 */
		public function prevFrame():void
		{
			currentFrame = Math.max(currentFrame - 1, 0);
			isPlaying = false;
		}
		
		/**
		 * 总的帧数 
		 */
		public function get totalFrames():int
		{
			return animation.length;
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
		}
	}
}