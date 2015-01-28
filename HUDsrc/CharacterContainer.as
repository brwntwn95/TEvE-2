package  {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import ModDotaLib.RealAssets.HeroPortrait;
	import ValveLib.Globals;
	
	public class CharacterContainer extends MovieClip {
		
		public var description:TextField;
		public var heroPortrait:HeroPortrait;
		public var skill1:SkillContainer;
		public var skill2:SkillContainer;
		public var skill3:SkillContainer;
		public var skill4:SkillContainer;
		public var descScrollBar:Object;
		
		private var hasLinkedScrollbar:Boolean = false;
		public function CharacterContainer() {
			
		}
		public function SetHero(heroName) {
			if (hasLinkedScrollbar == false) {
				SyncScrollbar();
			}
			heroPortrait.SetHero(heroName, 3);
			heroPortrait.heroName.text = Globals.instance.GameInterface.Translate("#"+heroName);
			description.text = Globals.instance.GameInterface.Translate("#"+heroName+"_bio");
		}
		
		private function SyncScrollbar() {
			descScrollBar = this.getChildByName("descScrollBar");
			descScrollBar.scrollTarget = description;
			hasLinkedScrollbar = true;
		}
	}
	
}
