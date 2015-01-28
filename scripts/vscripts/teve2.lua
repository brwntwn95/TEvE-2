if TEvEGameMode == nil then
    TEvEGameMode = {}
    TEvEGameMode.__index = TEvEGameMode
end


function TEvEGameMode:new (o)
	o = o or {}
	setmetatable(o, self)
	return o
end

--questEnt = SpawnEntityFromTableSynchronous( "quest", { name = "Quest1", title = "#game_mode_15_desc" } )
--for k,v in pairs(questEnt) do
--	print(k)
--	print(v)
--end

function TEvEGameMode:InitGameMode()
	print(" --- TEvE 2 Hello World! --- ")
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(TEvEGameMode,"onPlayerConnect"), self)
end

function TEvEGameMode:onPlayerConnect(keys)
	player = EntIndexToHScript(self.index + 1)
	player:SetTeam(DOTA_TEAM_GOODGUYS)
end