package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.events.Event;
	import fl.motion.Color;
	import fl.controls.TextInput;
	import fl.controls.ColorPicker;
	import fl.events.ColorPickerEvent;

	//Animation effects
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.transitions.*;
	import fl.transitions.easing.*;

	public class Main extends MovieClip {
		private var movieClipContainer: MovieClip;

		//Message history stack: FIFO
		private var aTextFieldStack: Array;
		private var nTextFieldMax: Number;

		//Input field and color picker
		private var textInputField: TextInput;
		private var colorPicker: ColorPicker;

		//Visual effects and visiblity
		private var fadeOutTimer: Timer;
		private var containerVisible: Boolean;


		public function Main() {
			init();
		}

		private function init() {
			movieClipContainer = new MovieClip();
			addChild(movieClipContainer);
			containerVisible = true;
			
			initGUI();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			
			fadeOutTimer = new Timer(5000, int.MAX_VALUE);
			fadeOutTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			fadeOutTimer.start();
		}
		
		private function initGUI(): void {
			var nTextFieldWidth: Number = 240;
			var nTextFieldHeight: Number = 30;
			
			//Text field stack initialization
			aTextFieldStack = new Array();
			nTextFieldMax = 4;
			for (var i: Number = 0; i < nTextFieldMax; i++) {
				aTextFieldStack[i] = new TextField();
				aTextFieldStack[i].width = nTextFieldWidth;
				aTextFieldStack[i].height = nTextFieldHeight;
				aTextFieldStack[i].border = true;
				aTextFieldStack[i].text = i;
				aTextFieldStack[i].textColor = new uint(0x000000);
				aTextFieldStack[i].x = 10;
				aTextFieldStack[i].y = 16 + i * nTextFieldHeight;
				movieClipContainer.addChild(aTextFieldStack[i]);
			}

			//Input field initialization
			textInputField = new TextInput();
			textInputField.x = 10;
			textInputField.y = 30 + 4 * nTextFieldHeight;
			textInputField.width = nTextFieldWidth - 40;
			textInputField.height = 20;
			textInputField.visible = true;
			movieClipContainer.addChild(textInputField);

			//Color Picker initialization
			colorPicker = new ColorPicker();
			colorPicker.x = textInputField.width + 30;
			colorPicker.y = 30 + 4 * nTextFieldHeight;
			colorPicker.width = 20;
			colorPicker.height = 20;
			colorPicker.visible = true;
			movieClipContainer.addChild(colorPicker);
		}
		
		private function FadeEffect(fadeIn: Boolean): void {
			containerVisible = fadeIn;
			TransitionManager.start(movieClipContainer, {type:Fade, direction:(fadeIn)? Transition.IN : Transition.OUT, duration:1, easing:Strong.easeOut});
		}

		public function timerHandler(event: TimerEvent): void {
			trace("timerHandler: " + event);
			if (containerVisible) {
				FadeEffect(false);
			}
		}

		function onKeyDownHandler(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.ENTER && !containerVisible) {
				fadeOutTimer.stop();
				FadeEffect(true);
				fadeOutTimer.start();
				stage.focus = textInputField;
			} else if (event.keyCode == Keyboard.ENTER) {
				fadeOutTimer.stop();
				pushMessage(textInputField.text, colorPicker.selectedColor);
				textInputField.text = "";
			}
		}

		// Walk recursivly over the stack from bottom to top and assign new values to each
		private function pushUpTheStack(index: Number): void {
			if (0 <= index && index < 3) {
				aTextFieldStack[index].text = aTextFieldStack[index + 1].text;
				aTextFieldStack[index].textColor = aTextFieldStack[index + 1].textColor;
				pushUpTheStack(index + 1);
			}
		}

		private function pushMessage(text: String = "", color: uint = 0x000000): void {
			 //First move other messages up the stack
			pushUpTheStack(0);
			
			//then add new one
			aTextFieldStack[nTextFieldMax - 1].text = text;
			aTextFieldStack[nTextFieldMax - 1].textColor = color;
			
			//start timer
			fadeOutTimer.start();
		}

	}

}