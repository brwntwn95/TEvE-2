package DotoAssets {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import scaleform.clik.motion.Tween;
	import fl.transitions.easing.*;
	import ValveLib.Controls.VideoController;
	
	public class HeroPortrait extends MovieClip {
		public var cardVideoController:VideoController = new VideoController(1);
		
		public var heroName;
		public var videoContainer;
		public var statIcon;
		public var cardBG;
		
		public function HeroPortrait() {
			var oldcardClass = getDefinitionByName("s_HeroCard");
			var newcardClass = getDefinitionByName("s_FullDeckCardWithMovie");
			var oldcard = new oldcardClass();
			var newcard = new newcardClass();

			videoContainer = AdoptAsset(newcard.selectorBG.portraitVideoContainer, this);
			videoContainer.visible = true;
			videoContainer.x = 2 * this.width / 48;
			videoContainer.y = 4 * this.height / 48;
			videoContainer.width = 6*this.width /12;
			videoContainer.height = 6*this.height / 12;

			cardBG = AdoptAsset(oldcard.card.cardFront.cardBG, this);
			cardBG.imageHolder.visible = false;
			cardBG.x = this.x;
			cardBG.y = this.y;
			cardBG.width = this.width;
			cardBG.height = this.height;
			//cardBG.visible = true;
			
			statIcon = AdoptAsset(oldcard.card.cardFront.statIcon, this);
			statIcon.visible = true;
			statIcon.scaleX = statIcon.scaleX * 2;
			statIcon.scaleY = statIcon.scaleY * 2;
			statIcon.x = statIcon.x + 9*this.width/24;
			
			heroName = AdoptAsset(oldcard.card.cardFront.heroName, this);
			heroName.scaleX = heroName.scaleX * 2;
			heroName.scaleY = heroName.scaleY * 2;
			heroName.x = heroName.x * 2;
			heroName.y = heroName.y * 2;
			heroName.visible = true;
			
			//Time to set the statIcon
			//Attribute, 1=Str, 2=Agi, 3=Int
			var statPipIndex = 3;		
			statIcon.gotoAndStop(statPipIndex + 1);
			statIcon.pipIndex = statPipIndex;
            statIcon.pipNumber = 0;
		}
		
		public function startCardVideo(heroName:String) : * {
			 trace("A");
			 //characterContainer.heroPortrait.card.cardFront.heroName = heroName;
			 this.heroName.text = heroName;
			 trace("B");
			 var videoFilename:* = "videos/portraits/npc_dota_hero_" + heroName + ".usm";
			 trace("C");
			 this.cardVideoController.startVideo(0,videoContainer,videoFilename);
			 trace("D");
			 videoContainer.mouseEnabled = false;
			 trace("E");
			 videoContainer.mouseChildren = false;
			 trace("F");
			 videoContainer.alpha = 0;
			 trace("G");
			 var t:Tween = new Tween(200,videoContainer,{"alpha":1},{"ease":None.easeNone});
			 trace("H");
			 t.delay = 100;
		}
		  
		//Time to steal some children
		public function AdoptAsset(child, adoptedParent) {
			var griefingMother = child.parent;
			griefingMother.removeChild(child);
			adoptedParent.addChild(child);
			
			return child;
		}
		
				//Stolen from Frota
		public function strRep(str, count) {
            var output = "";
            for(var i=0; i<count; i++) {
                output = output + str;
            }

            return output;
        }

        public function isPrintable(t) {
        	if(t == null || t is Number || t is String || t is Boolean || t is Function || t is Array) {
        		return true;
        	}
        	// Check for vectors
        	if(flash.utils.getQualifiedClassName(t).indexOf('__AS3__.vec::Vector') == 0) return true;

        	return false;
        }

        public function PrintTable(t, indent=0, done=null) {
        	var i:int, key, key1, v:*;

        	// Validate input
        	if(isPrintable(t)) {
        		trace("PrintTable called with incorrect arguments!");
        		return;
        	}

        	if(indent == 0) {
        		trace(t.name+" "+t+": {")
        	}

        	// Stop loops
        	done ||= new flash.utils.Dictionary(true);
        	if(done[t]) {
        		trace(strRep("\t", indent)+"<loop object> "+t);
        		return;
        	}
        	done[t] = true;

        	// Grab this class
        	var thisClass = flash.utils.getQualifiedClassName(t);

        	// Print methods
			for each(key1 in flash.utils.describeType(t)..method) {
				// Check if this is part of our class
				if(key1.@declaredBy == thisClass) {
					// Yes, log it
					trace(strRep("\t", indent+1)+key1.@name+"()");
				}
			}

			// Check for text
			if("text" in t) {
				trace(strRep("\t", indent+1)+"text: "+t.text);
			}

			// Print variables
			for each(key1 in flash.utils.describeType(t)..variable) {
				key = key1.@name;
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
			}

			// Find other keys
			for(key in t) {
				v = t[key];

				// Check if we can print it in one line
				if(isPrintable(v)) {
					trace(strRep("\t", indent+1)+key+": "+v);
				} else {
					// Open bracket
					trace(strRep("\t", indent+1)+key+": {");

					// Recurse!
					PrintTable(v, indent+1, done)

					// Close bracket
					trace(strRep("\t", indent+1)+"}");
				}
        	}

        	// Get children
        	if(t is MovieClip) {
        		// Loop over children
	        	for(i = 0; i < t.numChildren; i++) {
	        		// Open bracket
					trace(strRep("\t", indent+1)+t.name+" "+t+": {");

					// Recurse!
	        		PrintTable(t.getChildAt(i), indent+1, done);

	        		// Close bracket
					trace(strRep("\t", indent+1)+"}");
	        	}
        	}

        	// Close bracket
        	if(indent == 0) {
        		trace("}");
        	}
        }
	}
	
}
