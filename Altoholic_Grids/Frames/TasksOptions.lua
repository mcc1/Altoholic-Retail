local addonName = "Altoholic"
local addon = _G[addonName]
local colors = addon.Colors

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- Setup localized names for all the text strings
AltoTasksOptionsTextTask:SetText(L["Task"]..":")
AltoTasksOptionsTextNewTask:SetText(L["New"]..":")
AltoTasksOptionsTextTaskType:SetText(L["Task Type"]..":")
AltoTasksOptionsTextExpansionName:SetText(L["Expansion"]..":")
AltoTasksOptionsTextTaskTarget:SetText(L["Target"]..":")
AltoTasksOptionsTextMinimumLevel:SetText(L["Minimum Level"]..":")
AltoTasksOptionsTextFaction:SetText(L["FILTER_FACTIONS"]..":")
AltoTasksOptionsTextFootnote:SetText("For instructions, check this page: "..colors.green.."https://github.com/teelolws/Altoholic-Retail/wiki/Grids-Tasks-Manual")
AltoTasksOptions_AddButton:SetText("Add")
AltoTasksOptions_DeleteButton:SetText("Delete")

-- Widen the dropdown menus
UIDropDownMenu_SetWidth(AltoTasksOptions_TaskTypeDropdown, 200, 0)
UIDropDownMenu_SetWidth(AltoTasksOptions_TaskExpansionDropdown, 200, 0)
UIDropDownMenu_SetWidth(AltoTasksOptions_TaskTargetDropdown, 200, 0)
UIDropDownMenu_SetWidth(AltoTasksOptions_TaskNameDropdown, 200, 0)
	
-- Get the array of saved tasks
if not Altoholic.db.global.Tasks then
    Altoholic.db.global.Tasks = {}
end
local tasks = Altoholic.db.global.Tasks
local currentTask = nil

-- Data Structure:
-- array Tasks
-- > Name = STRING
-- > ID = NUMBER UNIQUE PRIMARY KEY
-- > Category = ENUM {Daily / Dungeon / Raid / DungeonBoss / RaidBoss / ProfessionCooldown / Rare Spawn}
-- > Expansion = ENUM {Classic / TBC / WOTLK / Cataclysm / MOP / WOD / Legion / BFA / Shadowlands}
-- > Target = NUMBER variable {instanceID / questID / bossID / recipeID}
-- > (INTERNAL) Difficulty = ENUM {heroic / mythic} - for dungeons only

local expansions = {"Classic", "TBC", "WOTLK", "Cataclysm", "MOP", "WOD", "Legion", "BFA"}

-- Disable all the task type / expansion / target / minlvl / faction filter fields
UIDropDownMenu_DisableDropDown(AltoTasksOptions_TaskTypeDropdown)
UIDropDownMenu_DisableDropDown(AltoTasksOptions_TaskExpansionDropdown)
UIDropDownMenu_DisableDropDown(AltoTasksOptions_TaskTargetDropdown)
AltoTasksOptions_TaskMinimumLevelEditBox:SetEnabled(false)
AltoTasksOptions_TaskHordeCheckbox:SetEnabled(false)
AltoTasksOptions_TaskAllianceCheckbox:SetEnabled(false)

local function GetTaskByID(id)
    for _, task in pairs(tasks) do
        if id == task.ID then
            return task
        end
    end
    return nil
end

-- ==============================
-- ==============================
-- == Task Target Dropdown Menu Functions ==
-- ==============================
-- ==============================
local TaskOptionsScanningTooltip = CreateFrame("GameTooltip", "TaskOptionsScanningTooltip", UIParent, "GameTooltipTemplate")
-- Code from https://www.wowinterface.com/forums/showthread.php?t=46934
local QuestTitleFromID = setmetatable({}, { __index = function(t, id)
	TaskOptionsScanningTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	TaskOptionsScanningTooltip:SetHyperlink("quest:"..id)
	local title = TaskOptionsScanningTooltipTextLeft1:GetText()
	TaskOptionsScanningTooltip:Hide()
	if title and title ~= RETRIEVING_DATA then
		t[id] = title
		return title
	end
end })

local function TaskTargetDropdown_SetSelected(self, targetID, difficulty)
    -- Make the dropdown have the name of the selected target
    local name = EJ_GetInstanceInfo(targetID)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTargetDropdown, name)
    
    -- Save the selected target
    currentTask.Target = targetID
    currentTask.Difficulty = difficulty
end

local function TaskTargetDropdown_Opened(frame, level, menuList)
    -- Populate targets with different items depending on the category
    local category = currentTask.Category
    local expansion = currentTask.Expansion
    
    if category == "Dungeon" then
        -- Lets populate it with a list of Dungeons pulled from the Encounter Journal
        
        -- convert the expansion name to an expansion ID
        local expansionID = 1
        for k,v in pairs(expansions) do
            if (expansion == v) then
                expansionID = k
            end
        end

        -- Set the Encounter Journal to be checking that expansion                                             
        EJ_SelectTier(expansionID)
        
        -- Pull all the dungeon names for that expansion out of the Encounter Journal
        local index = 1
        local instanceID, name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty = EJ_GetInstanceByIndex(index, false)
        while instanceID do
            local info = UIDropDownMenu_CreateInfo()
            info.text = name.." (Heroic)"
            info.func = TaskTargetDropdown_SetSelected
            info.arg1 = instanceID
            info.arg2 = "heroic"
            UIDropDownMenu_AddButton(info)
            info.text = name.." (Mythic)"
            info.arg2 = "mythic"
            UIDropDownMenu_AddButton(info)
            index = index + 1
            instanceID, name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty = EJ_GetInstanceByIndex(index, false)
        end
    end
    
    if category == "Daily Quest" then
        
        local a = false
        -- Lets populate this with daily quests already completed by the current character this day, pulled from Datastore_Quests1
        for _, daily in pairs(DataStore:GetDailiesHistory(DataStore:GetCharacter())) do 
            a = true
            local info = UIDropDownMenu_CreateInfo()
            info.text = daily.title
            info.func = TaskTargetDropdown_SetSelected
            info.arg1 = daily.id
            info.arg2 = daily.title
            UIDropDownMenu_AddButton(info)
        end
        
        if not a then
            print("Altoholic: The Daily Quest dropdown will only list Daily Quests you have completed today on the character you are currently playing.")
        end
    end
end

-- Converts the targetID to its associated string, based on the category
local function getCurrentTargetName()
    local category = currentTask.Category
    local expansion = currentTask.Expansion
    local targetID = currentTask.Target
    
    if not targetID then return nil end
        
    if category == "Dungeon" then
        -- trim out all the extra parameters returned, we just want the name here
        local name = EJ_GetInstanceInfo(targetID)
        return name
    end
    
    if category == "Daily Quest" then
        local name = QuestTitleFromID[targetID]
        return name
    end
    
    AltoholicTabGrids:Update()        
end

-- ==============================
-- ==============================
-- == Task Expansion Dropdown Menu Functions ==
-- ==============================
-- ==============================
local function TaskExpansionDropdown_SetSelected(self, expansionName)
    -- Make the dropdown have the name of the selected expansion
    UIDropDownMenu_SetText(AltoTasksOptions_TaskExpansionDropdown, expansionName)
    
    -- Save the selected task expansion
    currentTask.Expansion = expansionName
    
    -- Wipe any selected target
    currentTask.Target = nil
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTargetDropdown, "")
    
    -- If both a category and an expansion are selected, enable the target dropdown
    if currentTask.Category then
        UIDropDownMenu_EnableDropDown(AltoTasksOptions_TaskTargetDropdown)
    end        
end

local function TaskExpansionDropdown_Opened(frame, level, menuList)
    for _, expansion in pairs(expansions) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = expansion
        info.func = TaskExpansionDropdown_SetSelected
        info.arg1 = expansion
        UIDropDownMenu_AddButton(info)
    end
end

-- ==============================
-- ==============================
-- == Task Type Dropdown Menu Functions ==
-- ==============================
-- ==============================
local function TaskTypeDropdown_SetSelected(self, categoryName)
    -- Make the dropdown have the name of the selected category
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTypeDropdown, categoryName)
    
    -- Save the selected category
    currentTask.Category = categoryName
    
    -- If both a category and an expansion are selected, enable the target dropdown
    if currentTask.Expansion then
        UIDropDownMenu_EnableDropDown(AltoTasksOptions_TaskTargetDropdown)
    end
    
    -- Wipe any selected target
    currentTask.Target = nil
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTargetDropdown, "")
end

local function TaskTypeDropdown_Opened(frame, level, menuList)
    local currentTaskType = currentTask.Category
    
    local categories = {"Daily Quest", "Dungeon", "Raid", "Dungeon Boss", "Raid Boss", "Profession Cooldown", "Rare Spawn"}
    
    for _, category in pairs(categories) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = category
        info.func = TaskTypeDropdown_SetSelected
        info.arg1 = category
        UIDropDownMenu_AddButton(info)
    end
end

-- ==============================
-- ==============================
-- == Task Name Dropdown Menu Functions ==
-- ==============================
-- ==============================

local function TaskNameDropdown_SetSelected(self, id)
    -- Make the dropdown have the name of the selected task
    UIDropDownMenu_SetText(AltoTasksOptions_TaskNameDropdown, GetTaskByID(id).Name)
    currentTask = GetTaskByID(id)
    
    -- Enable all the other dropdowns and fields
    UIDropDownMenu_EnableDropDown(AltoTasksOptions_TaskTypeDropdown)
    UIDropDownMenu_EnableDropDown(AltoTasksOptions_TaskExpansionDropdown)
    AltoTasksOptions_TaskMinimumLevelEditBox:SetEnabled(true)
    AltoTasksOptions_TaskHordeCheckbox:SetEnabled(true)
    AltoTasksOptions_TaskAllianceCheckbox:SetEnabled(true)
    
    -- Populate them
    addon:DDM_Initialize(AltoTasksOptions_TaskTypeDropdown, TaskTypeDropdown_Opened)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTypeDropdown, currentTask.Category)
    addon:DDM_Initialize(AltoTasksOptions_TaskExpansionDropdown, TaskExpansionDropdown_Opened)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskExpansionDropdown, currentTask.Expansion)
    addon:DDM_Initialize(AltoTasksOptions_TaskTargetDropdown, TaskTargetDropdown_Opened)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTargetDropdown, getCurrentTargetName())

    -- Target Dropdown should only be enabled if there is a category and expansion selected
    if currentTask.Category and currentTask.Expansion then
        UIDropDownMenu_EnableDropDown(AltoTasksOptions_TaskTargetDropdown)
    else
        UIDropDownMenu_DisableDropDown(AltoTasksOptions_TaskTargetDropdown)
    end
    
end

local function TaskNameDropdown_Opened(frame, level, menuList)
    for _, task in pairs(tasks) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = task.Name
        info.func = TaskNameDropdown_SetSelected
        info.arg1 = task.ID
        UIDropDownMenu_AddButton(info)
    end
end

-- ==============================
-- ==============================
-- == Initialization functions ==
-- ==============================
-- ==============================

-- Check if the array of saved tasks is empty
-- > if it is, disable the task field
if #tasks == 0 then
    UIDropDownMenu_DisableDropDown(AltoTasksOptions_TaskNameDropdown)
else
-- > otherwise, populate it
    addon:DDM_Initialize(AltoTasksOptions_TaskNameDropdown, TaskNameDropdown_Opened)
end

-- ==============================
-- ==============================
-- == Add Button functions ==
-- ==============================
-- ==============================

-- Crude primary key implementation
local function GetNextPrimaryKey()
    local i = 0
    local taken = true
    while(taken) do
        i = i + 1
        taken = false
        for _, task in pairs(tasks) do
            if task.ID == i then
                taken = true
            end
        end
    end
    return i
end

-- function to handle the add button being pushed
local function AddClicked()
    -- Check integrity of the TaskNameEditBox
    local taskName = AltoTasksOptions_TaskNameEditBox:GetText()
    
    if #taskName < 1 then
        print("Error: Task Name cannot be empty")
        return
    end
    
    local id = GetNextPrimaryKey()
    
    -- Add new task name to saved variables
    table.insert(tasks, {["Name"] = taskName, ["ID"] = id,})
    
    -- If this was the first task name, initialize the dropdown
    if #tasks == 1 then
        addon:DDM_Initialize(AltoTasksOptions_TaskNameDropdown, TaskNameDropdown_Opened)    
    end
    
    -- Set the new task as the currently selected task
    TaskNameDropdown_SetSelected(nil, id)
    
    AltoholicTabGrids:Update()
end
AltoTasksOptions_AddButton:SetScript("OnClick", AddClicked)

-- ==============================
-- ==============================
-- == Delete Button functions ==
-- ==============================
-- ==============================
-- function to handle the add button being pushed
local function DeleteClicked()

    -- Check that a task is actually selected
    if not currentTask then return end
    
    -- Remove the currentTask from the tasks table
    local id = currentTask.ID
    for k,v in pairs(tasks) do
        if v.ID == id then
            table.remove(tasks, k)
            break
        end
    end
    
    -- Clear the other dropdowns and such
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTypeDropdown, nil)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskExpansionDropdown, nil)
    UIDropDownMenu_SetText(AltoTasksOptions_TaskTargetDropdown, nil)

    AltoholicTabGrids:Update()
end
AltoTasksOptions_DeleteButton:SetScript("OnClick", DeleteClicked)

-- ==============================
-- ==============================

-- ==============================
-- ==============================

-- function to handle a task being selected 