package  {
	
	import flash.display.MovieClip;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public class LoadContainer extends MovieClip {
		
		public var characterContainer:CharacterContainer;
		
		public var globals;
		
		public function LoadContainer(globals) {
			this.globals = globals;
		}
		public function init() {
			//temp
			trace("##LOADCONTAINER TEST");
			characterContainer.skill1.abilityIcon.SetAbility("ursa_enrage");
			characterContainer.skill2.abilityIcon.SetAbility("crystal_maiden_brilliance_aura");
			characterContainer.skill3.abilityIcon.SetAbility("lina_dragon_slave");
			characterContainer.skill4.abilityIcon.SetAbility("pugna_decrepify");
			characterContainer.SetHero("npc_dota_hero_lina");
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
			
			if (t.name == "globals") {
				trace("GLOBALS TRAP!!! RUNNNN");
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
