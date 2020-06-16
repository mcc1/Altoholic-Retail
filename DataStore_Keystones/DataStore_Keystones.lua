if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    print("DataStore_Keystones does not support Classic WoW")
    return
end

--[[	*** DataStore_Keystones ***
Written by : Teelo, US-Jubei'thos
https://www.patreon.com/teelojubeithos
--]]

if not DataStore then return end
local addonName = "DataStore_Keystones"
_G[addonName] = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")
local addon = _G[addonName]

local AddonDB_Defaults = {
	global = {
		Characters = {
			['*'] = {				-- ["Account.Realm.Name"] 
				lastUpdate = nil,
				currentKeystone = {},
				highestKeystoneThisWeek = {},
			}
		},
        Guilds = {
            ['*'] = {
                lastUpdate = nil,
                
            }
        },
	}
}

local ReferenceDB_Defaults = {
	global = {
		['*'] = {							-- "englishClass" like "MAGE", "DRUID" etc..
			Version = nil,					-- build number under which this class ref was saved
			Locale = nil,					-- locale under which this class ref was saved
		},
	}
}

-- *** Utility functions ***
local function GetVersion()
	local _, version = GetBuildInfo()
	return tonumber(version)
end

-- *** Scanning functions ***
local function ScanCurrentKeystoneInfo()
    local char = addon.ThisCharacter
    
    if not C_MythicPlus.GetOwnedKeystoneChallengeMapID() then return end
    local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(C_MythicPlus.GetOwnedKeystoneChallengeMapID())
    local keyStoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    
    if char.currentKeystone.name ~= name then
        -- Keystone has changed since last scan
        char.currentKeystone.name = name
        char.currentKeystone.texture = texture
        char.currentKeystone.keystoneLevel = keyStoneLevel
    end        
    
    char.lastUpdate = time()
end

-- *** Event Handlers ***
local function OnNewWeeklyRecord(event, ...)
    local mapChallengeModeID, completionMilliseconds, level = ...
    local char = addon.ThisCharacter
    local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
    
    char.highestKeystoneThisWeek.name = name
    char.highestKeystoneThisWeek.completionMilliseconds = completionMilliseconds
    char.highestKeystoneThisWeek.level = level
    char.highestKeystoneThisWeek.texture = texture
    char.highestKeystoneThisWeek.backgroundTexture = backgroundTexture
    
    char.lastUpdate = time()
end

local function OnPlayerAlive()
	ScanCurrentKeystoneInfo()
end

local function OnItemReceived(event, bag)
    if (bag < 0) or (bag >= 5) then
		return
	end
    ScanCurrentKeystoneInfo()
end

-- *** Keystone Info ***
local function _GetCurrentKeystone(character)
    local keystone = character.currentKeystone
    if not keystone then return nil, nil, nil end    
    return keystone.name, keystone.texture, keystone.keystoneLevel
end

local function _GetHighestKeystone(character)
    local keystone = character.highestKeystone
    if not keystone then return nil, nil, nil, nil, nil end
    return keystone.name, keystone.completionMilliseconds, keystone.level, keystone.texture, keystone.backgroundTexture
end


local PublicMethods = {
    GetCurrentKeystone = _GetCurrentKeystone,
    GetHighestKeystone = _GetHighestKeystone,
}

function addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New(addonName .. "DB", AddonDB_Defaults)
	addon.ref = LibStub("AceDB-3.0"):New(addonName .. "RefDB", ReferenceDB_Defaults)

	DataStore:RegisterModule(addonName, addon, PublicMethods)

	DataStore:SetCharacterBasedMethod("GetCurrentKeystone")
	DataStore:SetCharacterBasedMethod("GetHighestKeystone")
end

function addon:OnEnable()
	addon:RegisterEvent("PLAYER_ALIVE", OnPlayerAlive)
	addon:RegisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD", OnNewWeeklyRecord)
	addon:RegisterEvent("BAG_UPDATE", OnItemReceived)
end

function addon:OnDisable()
	addon:UnregisterEvent("PLAYER_ALIVE")
	addon:UnregisterEvent("MYTHIC_PLUS_NEW_WEEKLY_RECORD")
	addon:UnregisterEvent("BAG_UPDATE")
end
