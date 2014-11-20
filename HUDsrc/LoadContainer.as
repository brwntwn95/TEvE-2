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
			card.x = card.x + (card.width / 2);
			card.y = card.y + (6 * card.height / 7);
			trace("a");
			card.dailyHeroQuestIcon.visible = false;
			trace("b");
			card.heroQuestIcon.visible = false;
			trace("c");
			card.heroQuestCompletedIcon.visible = false;
			trace("d");
			card.abilityContainer.visible = false;
			trace("e");
			characterContainer.heroPortrait = (card as MovieClip);
		}
		
		public function startCardVideo(heroName:String) : * {
			 trace("Party time!!");
			 var videoContainer:Object = characterContainer.heroPortrait.selectorBG.portraitVideoContainer;
			 trace("a");
			 var videoFilename:* = "videos/portraits/npc_dota_hero_" + heroName + ".usm";
			 trace("b");
			 this.cardVideoController.startVideo(0,videoContainer,videoFilename);
			 trace("c");
			 videoContainer.mouseEnabled = false;
			 trace("d");
			 videoContainer.mouseChildren = false;
			 trace("e");
			 videoContainer.alpha = 0;
			 trace("f");
			 var t:Tween = new Tween(200,videoContainer,{"alpha":1},{"ease":None.easeNone});
			 trace("g");
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
