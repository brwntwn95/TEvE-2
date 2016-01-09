NeutralSpawners = class({})

--Constants
NeutralSpawners.SPAWN_DELAY = 30



function NeutralSpawners:Start()
	local spawners = Entities:FindAllByName('neutral_spawner'); --all entities with name "neutral_spawner" (all info_targets placed in hammer)
	NeutralSpawners.UnitsTable = LoadKeyValues("scripts/kv/spawners.txt")
	DeepPrintTable(NeutralSpawners.UnitsTable)
	for _,spawner in pairs( spawners ) do
	   --keep unit list on the spawner to keep track of the units still alive, just set thisup once
        spawner.unitList = {}

        NeutralSpawners:SpawnUnits( spawner )
	end
end

function NeutralSpawners:RespawnTimer(spawner, unit)
	for k,u in pairs( spawner.unitList ) do
        if u == unit then
            table.remove( spawner.unitList, k )
            break
        end
    end

    if #spawner.unitList == 0 then
        Timers:CreateTimer( NeutralSpawners.SPAWN_DELAY, function()
            NeutralSpawners:SpawnUnits( spawner )
        end)
    end
end

function NeutralSpawners:SpawnUnits( spawner )
        --spawn unit
    local unitid = spawner:Attribute_GetIntValue("unit_type", -1)
    print(NeutralSpawners.UnitsTable[tostring(unitid)])
	local unit = CreateUnitByName( NeutralSpawners.UnitsTable[tostring(unitid)], spawner:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
        --add the unit to its spawner's unit list
        table.insert( spawner.unitList, unit )

        --Tell the unit to which spawner it belongs
        unit.neutralSpawner = spawner
end