-- Written like this to allow reloading
if TEvEGameMode == nil then
	TEvEGameMode = {}
	TEvEGameMode.szEntityClassName = "teve2"
	TEvEGameMode.szNativeClassName = "dota_base_game_mode"
	TEvEGameMode.__index = TEvEGameMode
    
end

function TEvEGameMode:new (o)
	o = o or {}
	setmetatable(o, self)
	return o
end


-- Called from C++ to Initialize
function TEvEGameMode:InitGameMode()
print("Hello World!")
end

-- Called from C++ to handle the entity_killed event
function TEvEGameMode:OnEntityKilled( keys )
end

-- Called from C++ to handle the npc_spawned event
function TEvEGameMode:OnNPCSpawned( keys )
end

-- Called from C++ to handle the dota_item_picked_up event
function TEvEGameMode:OnItemPickedUp( keys )
end

-- Called from C++ to handle the dota_match_done event
function TEvEGameMode:OnMatchDone( keys )
end

-- Think function called from C++, every second.
function TEvEGameMode:Think()
end