package {
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Main extends MovieClip {

		private var movieClp: MovieClip;
		
		//relative positions
		private var xDisToCorner: Number; //x axis distance to right corner in percent
		private var yDisToCroner: Number; //y axis distance to bottom corner in percent

		function randomRange(minNum: Number, maxNum: Number): Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}

		private function drawRectangle(xx: int, yy: int, wdth: int, hght: int): Shape {
			var rectangle: Shape = new Shape;
			rectangle.graphics.beginFill(0xFF0000);
			rectangle.graphics.drawRect(xx, yy, wdth, hght);
			rectangle.graphics.endFill();
			return rectangle;
		}

		private function showTraceData() {
			trace("stageWidth: " + this.stage.stageWidth + " |  stageHeight: " + this.stage.stageHeight);
			trace("internMovieClipX: " + movieClp.x + " |  internMovieClipY: " + movieClp.y + " |  internMovieClipWidth: " + movieClp.width + " |  internMovieClipHeight: " + movieClp.height);
			trace("xDisToCorner(%): " + xDisToCorner + " |  yDisToCroner(%): " + yDisToCroner);	
		}
		
		//parameterized function for scaling of custom movieclip with rectangle (for better visibility)
		private function createNewMovieClip(startX: int = 30, startY: int = 30, startWidth: int = 50, startHeight: int = 50): MovieClip {
			var tmpMovieClip = new MovieClip();
			tmpMovieClip.x = startX;
			tmpMovieClip.y = startY;
			var rectAngle = drawRectangle(0, 0, startWidth, startHeight); // to see movie clip
			tmpMovieClip.addChild(rectAngle); // to see movie clip
			xDisToCorner = tmpMovieClip.x / this.stage.stageWidth;
			yDisToCroner = tmpMovieClip.y / this.stage.stageHeight;
			return tmpMovieClip;
		}

		//function scales movieClip in X and Y direction
		private function scaleMovieClip(mvClip: MovieClip, scaleX: Number = 0, scaleY: Number = 0): void {
			mvClip.scaleX += scaleX;
			mvClip.scaleY += scaleY;
		}
		
		//calculates percetwise different based on initilized values for each axis multiplied with the current size of that window axis
		private function adjustMovieClipPositions(): void {
			this.movieClp.x = xDisToCorner * this.stage.stageWidth;
			this.movieClp.y = yDisToCroner * this.stage.stageHeight;
			//showTraceData();
		}

		private function resizeHandler(event: Event): void {
			adjustMovieClipPositions(); //adjust movie clip location
			//showTraceData();
		}

		//Generate new random MovieClip
		function onKeyDownHandler(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.R) {
				removeChild(movieClp);
				movieClp = createNewMovieClip(randomRange(10, this.stage.stageWidth - (this.stage.stageWidth * 0.1)), randomRange(10, this.stage.stageHeight - (this.stage.stageHeight * 0.1)));
				addChild(movieClp);
				//showTraceData();
			} else if (event.keyCode == Keyboard.UP) {
				scaleMovieClip(movieClp, 0 , -1);
			} else if (event.keyCode == Keyboard.DOWN) {
				scaleMovieClip(movieClp, 0 , 1);
			} else if (event.keyCode == Keyboard.RIGHT) {
				scaleMovieClip(movieClp, 1);
			} else if (event.keyCode == Keyboard.LEFT) {
				scaleMovieClip(movieClp, -1);
			}
		}

		public function Main() {
			movieClp = createNewMovieClip();
			addChild(movieClp);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.addEventListener(Event.RESIZE, resizeHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		}
	}
}