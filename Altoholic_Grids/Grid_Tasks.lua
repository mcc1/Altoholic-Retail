local addonName = "Altoholic"
local addon = _G[addonName]
local colors = addon.Colors
local icons = addon.Icons

local ICON_QUESTIONMARK = "Interface\\RaidFrame\\ReadyCheck-Waiting"

local xPacks = {
	EXPANSION_NAME0,	-- "Classic"
	EXPANSION_NAME1,	-- "The Burning Crusade"
	EXPANSION_NAME2,	-- "Wrath of the Lich King"
	EXPANSION_NAME3,	-- "Cataclysm"
	EXPANSION_NAME4,	-- "Mists of Pandaria"
	EXPANSION_NAME5,	-- "Warlords of Draenor"
}

-- Get the array of saved tasks
if not Altoholic.db.global.Tasks then
    Altoholic.db.global.Tasks = {}
end
local tasks = Altoholic.db.global.Tasks

local function isTaskComplete(taskID, character)
    if taskID == nil then return false end

    local task = tasks[taskID]
    if task == nil then return false end
    
    if (task.Category == nil) or (task.Target == nil) then return false end
    
    if task.Category == "Daily Quest" then
        local completed = false
        for _, daily in pairs(DataStore:GetDailiesHistory(character)) do
            if daily.id == task.Target then
                completed = true
                break
            end 
        end
        if completed then
            return true
        else
            return false
        end
    end
    
    if task.Category == "Dungeon" then
        if (task.Expansion == nil) then return false end
        if (task.Difficulty == nil) then return false end
        
        local completed = false
        for dungeonKey, _ in pairs(DataStore:GetSavedInstances(character)) do
            local instanceName, instanceID = strsplit("|", dungeonKey)
            local taskTargetName = EJ_GetInstanceInfo(task.Target)
            if task.Difficulty == "heroic" then
                if instanceName == (taskTargetName.." Heroic") then
                    completed = true
                    break
                end
            end
            if task.Difficulty == "mythic" then
                if instanceName == (taskTargetName.." Mythic") then
                    completed = true
                    break
                end
            end
		end
        if completed then
            return true
        else
            return false
        end
    end
    
    if task.Category == "Profession Cooldown" then
        for _ , profession in pairs(DataStore:GetProfessions(character)) do
            if DataStore:GetNumActiveCooldowns(profession) > 0 then
                for i = 1, DataStore:GetNumActiveCooldowns(profession) do
                    local name, expiresIn, resetsIn, expiresAt = DataStore:GetCraftCooldownInfo(profession, i)
                    if name == task.Target then
                        return true
                    end
                end
            end
        end
        return false
    end
end

local function OnDropDownClicked(self)
    addon:ToggleUI()
	AltoTasksOptions:Show()
end

local function OnTradeSkillChange(self)
	dropDownFrame:Close()
	addon:SetOption(OPTION_TRADESKILL, self.value)
	AltoholicTabGrids:Update()
end

local function DropDown_Initialize(frame, level)
	frame:AddButton("Manage", 1, OnDropDownClicked)
end

local callbacks = {
	OnUpdate = function() 
		end,
	OnUpdateComplete = function() end,
	GetSize = function() return #tasks end,
	RowSetup = function(self, rowFrame, dataRowID)
            if (tasks[dataRowID]) and (tasks[dataRowID].Name) then
			    rowFrame.Name.Text:SetText(tasks[dataRowID].Name)
            end
			rowFrame.Name.Text:SetJustifyH("LEFT")
		end,
	RowOnEnter = function()	end,
	RowOnLeave = function() end,
	ColumnSetup = function(self, button, dataRowID, character)
			button.Name:SetFontObject("GameFontNormalSmall")
			button.Name:SetJustifyH("CENTER")
			button.Name:SetPoint("BOTTOMRIGHT", 5, 0)
			button.Background:SetDesaturated(false)
			button.Background:SetTexCoord(0, 1, 0, 1)
			
			button.Background:SetTexture(GetItemIcon(currentItemID) or ICON_QUESTIONMARK)

			local text = icons.notReady
			local vc = 0.25	-- vertex color
			local tradeskills = addon.TradeSkills.spellIDs
			local profession = DataStore:GetProfession(character, GetSpellInfo(tradeskills[addon:GetOption(OPTION_TRADESKILL)]))			

			if #tasks ~= 0 then
		
				if isTaskComplete(dataRowID, character) then
					vc = 1.0
					text = icons.ready
				else
					vc = 0.4
				end
			end

			button.Background:SetVertexColor(vc, vc, vc)
			button.Name:SetText(text)
			button.id = currentItemID
		end,
	OnEnter = function(self)  
		end,
	OnClick = function(self, button)
		end,
	OnLeave = function(self) 
		end,
		
	InitViewDDM = function(frame, title)
			dropDownFrame = frame
			frame:Show()
			title:Show()
			
			frame:SetMenuWidth(100) 
			frame:SetButtonWidth(20)
			frame:SetText("Manage Tasks")
			frame:Initialize(DropDown_Initialize, "MENU_NO_BORDERS")
		end,
}

AltoholicTabGrids:RegisterGrid(15, callbacks)
