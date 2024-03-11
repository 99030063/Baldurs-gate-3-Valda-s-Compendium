-- Defining the key pieces of information for the mod here
local modGuid = "646d127d-6e6a-4d09-a2b0-2ec15b572e47"
local subClassGuid = "77ec456b-0ee0-4b46-a0cf-8113c28bc131"
local BootStrap = {}

-- If SCF is loaded, use it to load Subclass into Progressions. Otherwise, DIY.
if Ext.Mod.IsModLoaded("67fbbd53-7c7d-4cfa-9409-6d737b4d92a9") then
  local subClasses = {
    HavsglimtChronurgyMagic = {
      modGuid = modGuid,
      subClassGuid = subClassGuid,
      class = "wizard",
      subClassName = "Chronurgy Magic"
    }
  }

  local function OnStatsLoaded()
    Mods.SubclassCompatibilityFramework = Mods.SubclassCompatibilityFramework or {}
    Mods.SubclassCompatibilityFramework.API = Mods.SubclassCompatibilityFramework.Api or {}
    Mods.SubclassCompatibilityFramework.API.InsertSubClasses(subClasses)
  end

  Ext.Events.StatsLoaded:Subscribe(OnStatsLoaded)
-- If SCF isn't installed, insert class into Progression if another mod overwrites the Progression
else
  local function InsertSubClass(arr)
    table.insert(arr, subClassGuid)
  end

  local function DetectSubClass(arr)
    for _, value in pairs(arr) do
      if value == subClassGuid then
        return true
      end
    end
  end

  function BootStrap.loadSubClass(arr)
    if arr ~= nil then
      local found = DetectSubClass(arr)
      if not found then
        InsertSubClass(arr)
      end
    end
  end

  BootStrap.loadSubClass(Ext.Definition.Get("d6184c47-5b99-4e63-95ac-02f8ce4ccda1", "Progression").SubClasses)
end