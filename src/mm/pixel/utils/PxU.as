package mm.pixel.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Pixel工具类
	 *  
	 * @author Andy Cai <huayicai@gmail.com>
	 * 
	 */
	public class PxU
	{
		public static const ZERO_POINT:Point = new Point();
		
		/**
		 * 在浏览器中打开新的页面 
		 */
		public static function openURL(url:String):void
		{
			navigateToURL(new URLRequest(url), '_blank');
		}
		
		/**
		 * 获取类的名字 
		 */
		public static  function getClassName(obj:Object, simple:Boolean=false):String
		{
			var string:String = getQualifiedClassName(obj);
			string = string.replace("::",".");
			if (simple)
				string = string.substr(string.lastIndexOf(".")+1);
			
			return string;
		}
		
		/**
		 * 根据类名获取类 
		 */
		public static  function getClass(name:String):Class
		{
			return getDefinitionByName(name) as Class;
		}
		
		/**
		 * 获取两点间的角度 
		 */
		public static function getAngle(Point1:Point, Point2:Point):Number
		{
			var x:Number = Point2.x - Point1.x;
			var y:Number = Point2.y - Point1.y;
			if ((x == 0) && (y == 0))
				return 0;
			var c1:Number = 3.14159265 * 0.25;
			var c2:Number = 3 * c1;
			var ay:Number = (y < 0)?-y:y;
			var angle:Number = 0;
			if (x >= 0)
				angle = c1 - c1 * ((x - ay) / (x + ay));
			else
				angle = c2 - c1 * ((x + ay) / (ay - x));
			angle = ((y < 0)?-angle:angle)*57.2957796;
			if (angle > 90)
				angle = angle - 270;
			else
				angle += 90;
			
			return angle;
		}
		
		/**
		 * 获取两点间距离 
		 */
		public static function getDistance(Point1:Point,Point2:Point):Number
		{
			var dx:Number = Point1.x - Point2.x;
			var dy:Number = Point1.y - Point2.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * DisplayObject转换为位图
		 * @param	displayObject	要被绘制的目标对象
		 * @param	transparent		是否透明
		 * @param	fillColor		填充色
		 * @param	scale			绘制的缩放值
		 * @return 	BxFrameInfo
		 */
		public static function drawBitmap(displayObject:DisplayObject, transparent:Boolean = true, 
										   fillColor:uint = 0x00000000, scale:Number = 1):PxFrameInfo
		{
			var rect:Rectangle = displayObject.getBounds(displayObject);
			var x:int = Math.round(rect.x * scale);
			var y:int = Math.round(rect.y * scale);
			//防止 "无效的 BitmapData"异常
			if (rect.isEmpty()) {
				rect.width = 1;
				rect.height = 1;
			}
			
			var bitData:BitmapData = new BitmapData(Math.ceil(rect.width * scale), Math.ceil(rect.height * scale), transparent, fillColor);
			bitData.draw(displayObject, new Matrix(scale, 0, 0, scale, -x, -y), null, null, null, true);
			
			//剔除边缘空白像素
			var realRect:Rectangle = bitData.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			if (!realRect.isEmpty() && (bitData.width != realRect.width || bitData.height != realRect.height)) {
				var realBitData:BitmapData = new BitmapData(realRect.width, realRect.height, transparent, fillColor);
				realBitData.copyPixels(bitData, realRect, new Point);
				
				bitData.dispose();
				bitData = realBitData;
				x += realRect.x;
				y += realRect.y;
			}
			
			var frameInfo:PxFrameInfo = new PxFrameInfo;
			frameInfo.x = x;
			frameInfo.y = y;
			frameInfo.bitmapData = bitData;
			
			return frameInfo;
		}
		
		/**
		 * DisplayObject转换为位图
		 * @param	displayObject	要被绘制的目标对象
		 * @param	transparent		是否透明
		 * @param	fillColor		填充色
		 * @param	scale			绘制的缩放值
		 * @return 	PxFrameInfo
		 */
		public static function cacheBitmap(displayObject:DisplayObject, transparent:Boolean = true, 
										   fillColor:uint = 0x00000000, scale:Number = 1):PxFrameInfo
		{
			var rect:Rectangle = displayObject.getBounds(displayObject);
			var x:int = Math.round(rect.x * scale);
			var y:int = Math.round(rect.y * scale);
			if (rect.isEmpty()) {
				rect.width = 1;
				rect.height = 1;
			}
			
			var bitData:BitmapData = new BitmapData(Math.ceil(rect.width * scale), Math.ceil(rect.height * scale), transparent, fillColor);
			bitData.draw(displayObject, new Matrix(scale, 0, 0, scale, -x, -y), null, null, null, true);
			
			var frameInfo:PxFrameInfo = new PxFrameInfo;
			frameInfo.x = x;
			frameInfo.y = y;
			frameInfo.bitmapData = bitData;
			
			return frameInfo;
		}
		
		/**
		 * MovieClip转换为位图动画
		 * @param	displayObject	要被绘制的影片剪辑
		 * @param	transparent		是否透明
		 * @param	fillColor		填充色
		 * @param	scale			绘制的缩放值
		 * @return	BitmapData
		 */
		public static function movieClipToBitmapMovie(displayObject:DisplayObject, transparent:Boolean = true, 
												fillColor:uint = 0x00000000, scale:Number = 1):Vector.<PxFrameInfo>
		{
			var id:String;
			var animation:Vector.<PxFrameInfo>;
			var mc:MovieClip = displayObject as MovieClip;
			var frameInfo:PxFrameInfo;
			
			if (mc == null) {
				animation = new Vector.<PxFrameInfo>(1, true);
				
				id = getQualifiedClassName( displayObject ) + "_" + 1;
				
				if ( PxG.pxCollection.search( id ) ) {
					animation[0] = PxG.pxCollection.collection[ id ];
				} else {
					frameInfo = cacheBitmap(displayObject, transparent, fillColor, scale);
					animation[0] = PxG.pxCollection.addBitmapData( id, frameInfo );
				}
				
			} else {
				var i:int = 0;
				var c:int = mc.totalFrames;
				
				mc.gotoAndStop(1);
				
				animation = new Vector.<PxFrameInfo>(c, true);
				while (i < c) {
					id = getQualifiedClassName( displayObject ) + "_" + (i+1);
					
					if ( PxG.pxCollection.search( id ) ) {
						animation[i] = PxG.pxCollection.collection[ id ];
					} else {
						frameInfo = cacheBitmap(mc, transparent, fillColor, scale);
						
						var childs:Array = findChilds(mc, MovieClip);
						mc.nextFrame();
						
						// 进入孩子MovieClip
						var j:int = 0;
						var k:int = childs.length;
						while (j < k) {
							var childMC:MovieClip = childs[j];
							childMC.nextFrame();
							
							j++;
						}
						animation[i] = PxG.pxCollection.addBitmapData( id, frameInfo );
					}
					i++;
				}
			}
			return animation;
		}
		
		/**
		 * sprite sheet转换为位图动画
		 * @param	mc				要被绘制的影片剪辑
		 * @param	transparent		是否透明
		 * @param	fillColor		填充色
		 * @param	scale			绘制的缩放值
		 * @return	BitmapData
		 */
		public static function spriteSheetToBitmapMovie(bmd:BitmapData, unit:Rectangle, transparent:Boolean = true, 
												fillColor:uint = 0x00000000, scale:Number = 1):Vector.<PxFrameInfo>
		{
			var id:String;
			var animation:Vector.<PxFrameInfo>;
			var rect:Rectangle;
			var tmpBmd:BitmapData;
			
			var i:int = 0;
			var c:int = bmd.width/unit.width;
			
			animation = new Vector.<PxFrameInfo>(c, true);
			while (i < c) {
				id = getQualifiedClassName( bmd ) + "_" + (i+1);
				
				if ( PxG.pxCollection.search( id ) ) {
					animation[i] = PxG.pxCollection.collection[ id ];
				} else {
					rect = new Rectangle(i*unit.width, 0, unit.width, unit.height);
					tmpBmd = new BitmapData(rect.width, rect.height, transparent, fillColor);
					tmpBmd.copyPixels(bmd, rect, ZERO_POINT);
					
					var frameInfo:PxFrameInfo = new PxFrameInfo;
					frameInfo.bitmapData = tmpBmd;
					
					// TODO: 剔除边缘空白像素
					animation[i] = PxG.pxCollection.addBitmapData( id, frameInfo);
				}
				i++;
			}
			
			return animation;
		}
		
		/**
		 * 搜索容器中指定类型的对象并以数组方式返回
		 * 
		 * @param container DisplayObjectContainer 父亲容器
		 * @param dispType Class 显示对象类型
		 * @return array 对象数组
		 * 
		 */
		public static function findChilds(container:DisplayObjectContainer, dispType:Class):Array
		{
			var childList:Array = [];
			
			var i:int = 0;
			var c:int = container.numChildren;
			while (i < c) {
				var child:DisplayObject = container.getChildAt(i);
				
				if (child is dispType) {
					childList.push(child);
				} else {
					if (child is DisplayObjectContainer) {
						childList = childList.concat(findChilds(child as DisplayObjectContainer, dispType));
					}
				}
				i++;
			}
			return childList;
		}
	}
}