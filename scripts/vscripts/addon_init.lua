print('\n\nLoading TEvE modules...')

-- Module loading system (it reports errors)
local totalErrors = 0
local function loadModule(name)
    local status, err = pcall(function()
        -- Load the module
        require(name)
    end)

    if not status then
        -- Add to the total errors
        totalErrors = totalErrors+1

        -- Tell the user about it
        print('WARNING: '..name..' failed to load!')
        print(err)
    end
end

-- Load TEvE

--TEST
loadModule('bit')

loadModule('lib.json')         -- Json Library
loadModule('teve2')        -- Main program

loadModule('CodeSaveLoad')
--require("moondota/moondota")

if totalErrors == 0 then
    -- No loading issues
    print('Loaded TEvE modules successfully!\n')
elseif totalErrors == 1 then
    -- One loading error
    print('1 TEvE module failed to load!\n')
else
    -- More than one loading error
    print(totalErrors..' TEvE modules failed to load!\n')
end

UnitsCustomKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
ItemsCustomKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")