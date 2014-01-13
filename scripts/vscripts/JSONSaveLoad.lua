local jsonLib = require "lib.json"

local OBJDEF = {
  version="0.0.1"
}
--all ID's are for example purposes
--Names might not stay in the final version, as the ID is a foreign key to a table, which would contain names

--Item ID's can define if the item can stack or not, and WILL override save loading, be it json or code

--ACCOUNT_INFO would be an individual JSON file containing all the saves of that user
local ACCOUNT_INFO = {
  heros = {
    {
      name = "Stalker",              --User defined name
      tier = 3,                      --Might not stay, ID can collect it
      id = 1,                        --The Class ID of this save
      xp = 3,                --The amount of experience this save has
      profession = {                 --Info for profession, can be missing if not learnt yet
        id = 1,
        tier = 3,
        xp = 10
      },
      coords = {
        x=0,
        y=0
      },
      Skills = {
        {
        name = "Vanish",             --Might not stay, ID can collect it
          id = 10,                   --The Skill ID of this skill
          level = 30                 --The level of this skill
        },
        {
          name = "Evasion",          --Might not stay, ID can collect it
          id = 11,                   --The Skill ID of this skill
          level = 30                 --The level of this skill
        },
        {
          name = "Critical Strike",  --Might not stay, ID can collect it
          id = 12,                   --The Skill ID of this skill
          level = 30                 --The level of this skill
        },
        {
          name = "Agilty",           --Might not stay, ID can collect it
          id = 13,                   --The Skill ID of this skill
          level = 30                 --The level of this skill
        }
      }
    }
  },
  items = {
    {
      name = "Thief build",          --The user defined name for this item save
      gold = 10,
      shards = 10,
      pvp = 10,
      items = {
        {
          id = 1,
          quantity = 1
        },
        {
          id = 2,
          quantity = 10
        },
        {
          id = 3,
          quantity = 1
        },
        {
          id = 1,
          quantity = 1
        },
        {
          id = 4,
          quantity = 10
        },
        {
          id = 3,
          quantity = 1
        }
      },
      stash = {
        {
          id = 1,
          quantity = 1
        },
        {
          id = 2,
          quantity = 10
        },
        {
          id = 3,
          quantity = 1
        },
        {
          id = 1,
          quantity = 1
        },
        {
          id = 4,
          quantity = 10
        },
        {
          id = 3,
          quantity = 1
        }
      }
    }
  }
}


--Loads json from disk
--returns TABLE
function OBJDEF:LoadAll(location, steamID)
end

--Loads a particular save from disk
--returns TABLE
function OBJDEF:Load(location,steamID, type, save)
  return OBJDEF:LoadAll(location,steamID)[type][save]
end

--Saves info to disk as json
--returns VOID
function OBJDEF:SaveAll(location, steamID, info)
end

--Saves a particular save to disk as json
--returns a particular save
function OBJDEF:Save(location,steamID, type, save, info)
end

--global call to this library
JSONSaveLoad = OBJDEF