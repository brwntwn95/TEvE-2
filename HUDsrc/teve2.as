package  {
	
	import flash.display.MovieClip;
	
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	
	public class teve2 extends MovieClip {
		//GameAPI stuff, requried for this to work
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;
		
		public var res16by9Width:Number = 1920;
        public var res16by9Height:Number = 1080;
		
		public var res16by10Width:Number = 1680;
		public var res16by10Height:Number = 1050;
		
		public var res4by3Width:Number = 1280;
		public var res4by3Height:Number = 960;
		
		public var curRes:int = 3; //Invalid so that everything resizes
		
		public var resWidth:Number = res16by9Width;
		public var resHeight:Number = res16by10Width;
		
		//Default to 16by9 as that is the master resolution
		public var maxStageWidth:Number = res16by9Width;
		public var maxStageHeight:Number = res16by9Height;
		
		public var STATCOLLECT_RPG_MAXSAVES:Number = 10;

		public var loadingScreen:LoadContainer;
		
		
		public function onLoaded() : void {
			trace("\n\n-- TEvE 2 hud starting to load! --\n\n");
			
			loadingScreen = new LoadContainer();
			loadingScreen.x = 100;
			loadingScreen.y = 100;
			addChild(loadingScreen);
			
			Globals.instance.resizeManager.AddListener(this);
			AutoReplaceAssets(this);
			
			loadingScreen.visible = true;
		}
		
		public function onResize(re:ResizeManager) : * {
			// Update the stage width

			x = 0;
			y = 0;

			visible = true;

			try {
				trace("###TEvE HUD Flipped to "+globals.Game.IsHUDFlipped().toString());
			} catch (Exception) {
				trace("###ERRROR Ok, this didn't work..."); //This actually is used, not quite sure why yet.
			}
			
			trace("### Resizing");
			if (re.IsWidescreen()) {
				trace("### Widescreen detected!");
				//16:x
				if (re.Is16by9()) {
					if (curRes != 0) {
						curRes = 0;
					}
					trace("###TrollsAndElves Resizing for 16:9 resolution");
					resWidth = res16by9Width;
					resHeight = res16by9Height;
					//1920 * 1080
				} else {
					if (curRes != 1) {
						curRes = 1;
					}
					trace("###TrollsAndElves Resizing for 16:10 resolution");
					resWidth = res16by10Width;
					resHeight = res16by10Height;
					//1680 * 1050
				}
			} else {
				trace("###TrollsAndElves Resizing for 4:3 resolution");
				if (curRes != 2) {
					curRes = 2;
				}
				resWidth = res4by3Width;
				resHeight = res4by3Height;
				//1280 * 960
			}
			
			maxStageHeight = re.ScreenHeight / re.ScreenWidth * resWidth;
			maxStageWidth = re.ScreenWidth / re.ScreenHeight * resHeight;
            //Scale hud to screen
            this.scaleX = re.ScreenWidth/maxStageWidth;
            this.scaleY = re.ScreenHeight/maxStageHeight;
		}
		

        public function AutoReplaceAssets(t) {
        	var i:int;

			switch(getQualifiedClassName(t)) {
				case "DotoAssets::HeroPortrait":
					trace("OMGOMGOMG A HEROPORTRAIT");
					break;
				case "DotoAssets::DotoContainer":
					trace("OMGOMGOMG A DOTOCONTAINER");
					ReplaceAsset(t, "DB4_outerpanel");
					break;
				default:
					//trace("nvm, not interested in: "+getQualifiedClassName(t));
			}
			
        	if(t is MovieClip) {
        		// Loop over children
	        	for(i = 0; i < t.numChildren; i++) {
					// Recurse!
	        		AutoReplaceAssets(t.getChildAt(i));
	        	}
        	}
        }
		
		public function ReplaceAsset(btn, type) {
			var parent = btn.parent;
			var oldx = btn.x;
			var oldy = btn.y;
			var oldwidth = btn.width;
			var oldheight = btn.height;
			var olddepth = parent.getChildIndex(btn);
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			newObject.width = oldwidth;
			newObject.height = oldheight;
			
			parent.removeChild(btn);
			parent.addChild(newObject);
			
			parent.setChildIndex(newObject, olddepth);
		}
	}
}
