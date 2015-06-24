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
		private var nTextFieldWidth: Number = 240;
		private var nTextFieldHeight: Number = 30;
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
			stage.focus = textInputField;
		}
		
		private function createNewTextField(text: String, colour: uint, xPos: Number, yPos: Number):TextField {
			var newTextField = new TextField();
			newTextField.width = nTextFieldWidth;
			newTextField.height = nTextFieldHeight;
			newTextField.border = false;
			newTextField.text = text;
			newTextField.textColor = colour;
			newTextField.x = xPos;
			newTextField.y = yPos;
			movieClipContainer.addChild(newTextField);
			return newTextField;
		}
		
		private function initGUI(): void {
			//Text field stack initialization
			aTextFieldStack = new Array();
			nTextFieldMax = 4;
			for (var i: Number = 0; i < nTextFieldMax; i++) {
				aTextFieldStack[i] = createNewTextField(i.toString(), uint(0x000000), 10, 16 + i * nTextFieldHeight);
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
		
		private function fadeEffect(isVisible: Boolean, time: Number = 0.5): void {
			containerVisible = isVisible;
			TransitionManager.start(movieClipContainer, {type:Fade, direction:(isVisible)? Transition.IN : Transition.OUT, duration:time, easing:Strong.easeOut});
		}
		
		private function pushUpTextFieldEffect(txtField: TextField, startY: Number, endY: Number, time: Number = 1): void {
			var myTween:Tween = new Tween(txtField, "y", Strong.easeOut, startY, endY, time, true);
		}

		private function bounceUpTextFieldEffect(txtField: TextField, startY: Number, endY: Number, time: Number = 1): void {
			var myTween:Tween = new Tween(txtField, "y", Bounce.easeOut, startY, endY, time, true);
		}
		
		public function timerHandler(event: TimerEvent): void {
			trace("timerHandler: " + event);
			if (containerVisible) {
				fadeEffect(false);
			}
		}

		function onKeyDownHandler(event: KeyboardEvent): void {
			if (event.keyCode == Keyboard.ENTER && !containerVisible) {
				fadeOutTimer.stop();
				fadeEffect(true);
				fadeOutTimer.start();
				stage.focus = textInputField;
			} else if (event.keyCode == Keyboard.ENTER) {
				fadeOutTimer.stop();
				pushMessage(textInputField.text, colorPicker.selectedColor);
				textInputField.text = "";
			}
		}

		// Walk recursivly over the stack from bottom to top and assign new values to each
		private function pushStack(index: Number): void {
			if (index == nTextFieldMax - 4) {
				 // "pop" -> just that all messages are still in memory :)
				pushUpTextFieldEffect(aTextFieldStack[index], aTextFieldStack[index].y, aTextFieldStack[index].y - 90, 0.2);
				pushStack(index + 1);
			} else if ((nTextFieldMax - 4) < index && index <= nTextFieldMax - 1) {
				pushUpTextFieldEffect(aTextFieldStack[index], aTextFieldStack[index].y, aTextFieldStack[index].y - 30);
				pushStack(index + 1);
			}
		}

		private function pushMessage(text: String = "", color: uint = 0x000000): void {
			 //First move other messages up the stack
			pushStack(nTextFieldMax - 4);
			
			//then add new one
			aTextFieldStack[nTextFieldMax] = createNewTextField(text, color, 10, 16 + 3 * nTextFieldHeight);
			pushUpTextFieldEffect(aTextFieldStack[nTextFieldMax], 30 + 4 * nTextFieldHeight, aTextFieldStack[nTextFieldMax].y);
			//bounceUpTextFieldEffect(aTextFieldStack[nTextFieldMax], 30 + 4 * nTextFieldHeight, aTextFieldStack[nTextFieldMax].y);
			nTextFieldMax = nTextFieldMax + 1;
			
			//start timer
			fadeOutTimer.start();
		}

	}

}