package  {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import scaleform.clik.motion.Tween;
	import fl.transitions.easing.*;
	import ValveLib.Controls.VideoController;
	
	
	public class LoadContainer extends MovieClip {
		
		public var cardVideoController:VideoController = new VideoController(1);
		
		public var characterContainer:CharacterContainer;
		
		public function LoadContainer() {
			var card = ReplaceAsset(characterContainer.heroPortrait, "s_FullDeckCardWithMovie");
			//Now to move the card to the "correct" location
			card.x = card.x + (card.width / 2);
			card.y = card.y + (6 * card.height / 7);
			//And now to disable a bunch of the card that we dont want
			card.dailyHeroQuestIcon.visible = false;
			card.heroQuestIcon.visible = false;
			card.heroQuestCompletedIcon.visible = false;
			card.abilityContainer.visible = false;
			
			//Attribute
			
			//0 is Str
			//1 is Agi
			//2 is Int
			var statPipIndex = 1;
			
			card.statIcon.visible = true;
			card.statIcon.gotoAndStop(statPipIndex + 1);
			card.statIcon.pipIndex = statPipIndex;
            card.statIcon.pipNumber = 0;
			
			//And save
			characterContainer.heroPortrait = (card as MovieClip);
		}
		
		public function startCardVideo(heroName:String) : * {
			 var videoContainer:Object = characterContainer.heroPortrait.selectorBG.portraitVideoContainer;
			 var videoFilename:* = "videos/portraits/npc_dota_hero_" + heroName + ".usm";
			 this.cardVideoController.startVideo(0,videoContainer,videoFilename);
			 
			 videoContainer.mouseEnabled = false;
			 videoContainer.mouseChildren = false;
			 videoContainer.alpha = 0;
			 
			 var t:Tween = new Tween(200,videoContainer,{"alpha":1},{"ease":None.easeNone});
			 t.delay = 100;
		  }
		  
		public function ReplaceAsset(btn, type) {
			var parent = btn.parent;
			var oldx = btn.x;
			var oldy = btn.y;
			var oldwidth = btn.width;
			var oldheight = btn.height;
			var olddepth = parent.getChildIndex(btn);
			var oldname = btn.name;
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			newObject.width = oldwidth;
			newObject.height = oldheight;
			newObject.name = oldname;
			
			parent.removeChild(btn);
			parent.addChild(newObject);
			
			parent.setChildIndex(newObject, olddepth);
			
			return newObject;
		}
	}
	
}
