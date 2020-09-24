local addonName = "Altoholic"
local addon = _G[addonName]
local colors = addon.Colors
local icons = addon.Icons

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local PARAGON_LABEL = "Paragon"

-- *** Reputations ***
local Factions = {	
	{	-- [1]
		name = EXPANSION_NAME6,	-- "Legion"
		{	-- [1]
			name = OTHER,
			{ name = DataStore:GetFactionName(1900), icon = "achievements_zone_azsuna" },		-- Court of Farondis
			{ name = DataStore:GetFactionName(1883), icon = "achievements_zone_valsharah" },		-- Dreamweavers
			{ name = DataStore:GetFactionName(1828), icon = "achievements_zone_highmountain" },		-- Highmountain Tribe
			{ name = DataStore:GetFactionName(1948), icon = "achievements_zone_stormheim" },		-- Valarjar
			{ name = DataStore:GetFactionName(1859), icon = "achievements_zone_suramar" },			-- The Nightfallen
			{ name = DataStore:GetFactionName(1894), icon = "achievements_zone_brokenshore" },			-- The Wardens
			{ name = DataStore:GetFactionName(2045), icon = "achievement_faction_legionfall" },			-- Armies of Legionfall
			{ name = DataStore:GetFactionName(2165), icon = "achievement_admiral_of_the_light" },			-- Army of the Light
			{ name = DataStore:GetFactionName(2170), icon = "achievement_master_of_argussian_reach" },			-- Argussian Reach
		},		
	},
	{	-- [2]
		name = EXPANSION_NAME7,	-- "Battle for Azeroth"
		{	-- [1]
			name = FACTION_ALLIANCE,
			{ name = DataStore:GetFactionName(2159), icon = "Inv_tabard_alliancewareffort" },
			{ name = DataStore:GetFactionName(2160), icon = "Inv_tabard_proudmoore" },
			{ name = DataStore:GetFactionName(2161), icon = "Inv_tabard_orderoftheembers" },
			{ name = DataStore:GetFactionName(2162), icon = "Inv_tabard_stormswake" },
            { name = DataStore:GetFactionName(2400), icon = "inv_faction_akoan" },
		},
		{	-- [2]
			name = FACTION_HORDE,
			{ name = DataStore:GetFactionName(2157), icon = "Inv_tabard_hordewareffort" },
			-- should use the libbabble .. horde / ally factions again..
			{ name = DataStore:GetFactionName(2103) or "Zandalari Empire", icon = "Inv_tabard_zandalariempire" },
			{ name = DataStore:GetFactionName(2156) or "Talanji's Expedition", icon = "Inv_tabard_talanjisexpedition" },
			{ name = DataStore:GetFactionName(2158) or "Voldunai", icon = "Inv_tabard_vulpera" },
            { name = DataStore:GetFactionName(2373), icon = "inv_faction_unshackled" },
		},
		{	-- [3]
			name = OTHER,
            { name = DataStore:GetFactionName(2164), icon = "Inv_tabard_championsofazeroth" },
            { name = DataStore:GetFactionName(2163), icon = "Inv_tabard_tortollanseekers" },
			{ name = DataStore:GetFactionName(2391), icon = "inv_mechagon_junkyardtinkeringcrafting" },
			{ name = DataStore:GetFactionName(2415), icon = "inv_faction_83_rajani" },
			{ name = DataStore:GetFactionName(2417), icon = "inv_faction_83_uldumaccord" },
		},
	},
    { -- [3]
        name = EXPANSION_NAME8, -- "Shadowlands"
		{	-- [1]
			name = FACTION_ALLIANCE,
			--{ name = DataStore:GetFactionName(2159), icon = "Inv_tabard_alliancewareffort" },
		},
		{	-- [2]
			name = FACTION_HORDE,
			--{ name = DataStore:GetFactionName(2157), icon = "Inv_tabard_hordewareffort" },
		},
		{	-- [3]
			name = OTHER,
            { name = DataStore:GetFactionName(2410), icon = "inv_tabard_maldraxxus_d_01" },
            { name = DataStore:GetFactionName(2422), icon = "inv_tabard_ardenweald_d_01" },
			{ name = DataStore:GetFactionName(2413), icon = "inv_tabard_revendreth_d_01" },
			{ name = DataStore:GetFactionName(2407), icon = "PLACEHOLDER" }, -- check https://shadowlands.wowhead.com/achievement=14335/the-ascended#criteria-of:0+1+2
		},
    },
}

local view
local isViewValid

local OPTION_XPACK = "UI.Tabs.Grids.Paragon.CurrentXPack"
local OPTION_FACTION = "UI.Tabs.Grids.Paragon.CurrentFactionGroup"

local currentFaction
local currentDDMText
local dropDownFrame

local function BuildView()
	view = view or {}
	wipe(view)
	
	local currentXPack = addon:GetOption(OPTION_XPACK)
	local currentFactionGroup = addon:GetOption(OPTION_FACTION)

	if (currentXPack ~= CAT_ALLINONE) then
        if currentFactionGroup then
		    for index, faction in ipairs(Factions[currentXPack][currentFactionGroup]) do
			    table.insert(view, faction)	-- insert the table pointer
		    end
        else
            for k, v in ipairs(Factions[currentXPack]) do
                for index, faction in ipairs(v) do
                    table.insert(view, faction)
                end
            end
        end
	else	-- all in one, add all factions
		for xPackIndex, xpack in ipairs(Factions) do		-- all xpacks
			for factionGroupIndex, factionGroup in ipairs(xpack) do 	-- all faction groups
				for index, faction in ipairs(factionGroup) do
					table.insert(view, faction)	-- insert the table pointer
				end
			end
		end
		
		table.sort(view, function(a,b) 	-- sort all factions alphabetically
			if not a.name then
				DEFAULT_CHAT_FRAME:AddMessage(a.icon)
			end
			if not b.name then
				DEFAULT_CHAT_FRAME:AddMessage(b.icon)
			end
			
			
			return a.name < b.name
		end)
	end
	
	isViewValid = true
end

local function OnFactionChange(self, xpackIndex, factionGroupIndex)
	dropDownFrame:Close()

	addon:SetOption(OPTION_XPACK, xpackIndex)
	addon:SetOption(OPTION_FACTION, factionGroupIndex)
		
	local factionGroup
    if factionGroupIndex then
        factionGroup = Factions[xpackIndex][factionGroupIndex]
    else
        factionGroup = Factions[xpackIndex]
    end
	currentDDMText = factionGroup.name
	AltoholicTabGrids:SetViewDDMText(currentDDMText)
	
	isViewValid = nil
	AltoholicTabGrids:Update()
end

local function DropDown_Initialize(frame, level)
	if not level then return end

	local info = frame:CreateInfo()
	
	local currentXPack = addon:GetOption(OPTION_XPACK)
	local currentFactionGroup = addon:GetOption(OPTION_FACTION)
	
	if level == 1 then
		for xpackIndex = 1, #Factions do
			info.text = Factions[xpackIndex].name
			info.hasArrow = 1
			info.checked = (currentXPack == xpackIndex)
			info.value = xpackIndex
            info.arg1 = xpackIndex
            info.arg2 = nil
            info.func = OnFactionChange
			frame:AddButtonInfo(info, level)
		end
		
		frame:AddCloseMenu()
	
	elseif level == 2 then
		local menuValue = frame:GetCurrentOpenMenuValue()
		
		for factionGroupIndex, factionGroup in ipairs(Factions[menuValue]) do
			info.text = factionGroup.name
			info.func = OnFactionChange
			info.checked = ((currentXPack == menuValue) and (currentFactionGroup == factionGroupIndex))
			info.arg1 = menuValue
			info.arg2 = factionGroupIndex
			frame:AddButtonInfo(info, level)
		end
	end
end

local callbacks = {
	OnUpdate = function() 
			if not isViewValid then
				BuildView()
			end

			local currentXPack = addon:GetOption(OPTION_XPACK)
			local currentFactionGroup = addon:GetOption(OPTION_FACTION)
			
			if (currentFactionGroup) then
				AltoholicTabGrids:SetStatus(format("%s / %s", Factions[currentXPack].name, Factions[currentXPack][currentFactionGroup].name))
            else
                AltoholicTabGrids:SetStatus(format("%s / %s", Factions[currentXPack].name, Factions[currentXPack].name))
			end
		end,
	GetSize = function() return #view end,
	RowSetup = function(self, rowFrame, dataRowID)
			currentFaction = view[dataRowID]

			if not currentFaction.name then return end
            rowFrame.Name.Text:SetText(colors.white .. currentFaction.name)
			rowFrame.Name.Text:SetJustifyH("LEFT")
		end,
	RowOnEnter = function()	end,
	RowOnLeave = function() end,
	ColumnSetup = function(self, button, dataRowID, character)
			local faction = currentFaction
			
			if faction.left then		-- if it's not a full texture, use tcoords
				button.Background:SetTexture(faction.icon)
				button.Background:SetTexCoord(faction.left, faction.right, faction.top, faction.bottom)
			else
				button.Background:SetTexture("Interface\\Icons\\"..faction.icon)
				button.Background:SetTexCoord(0, 1, 0, 1)
			end		
			
			button.Name:SetFontObject("GameFontNormal")
			button.Name:SetJustifyH("CENTER")
			button.Name:SetPoint("BOTTOMRIGHT", 0, 0)
			button.Background:SetDesaturated(false)
			
			local status, amount = DataStore:GetReputationInfo(character, faction.name)
			if status and amount then 
				if status ~= PARAGON_LABEL then
					button:Hide()
				end

				button.Background:SetVertexColor(1, 1, 1);

                if amount >= 10000 then
        			if faction.left then
        				button.Background:SetTexture(faction.icon)
        				button.Background:SetTexCoord(faction.left, faction.right, faction.top, faction.bottom)
        			else
        				button.Background:SetTexture("Interface\\Icons\\"..faction.icon)
        				button.Background:SetTexCoord(0, 1, 0, 1)
        			end
                else
                    button.Background:SetTexture(nil)
                end
                
                amount = amount / 1000
                if amount > 0 then
                    amount = math.floor(amount)
                    amount = amount .. "K"
                end

				button.key = character
				button:SetID(dataRowID)
				button.Name:SetText(colors.white..amount)
			else
				button:Hide()
				button:SetID(0)
				button.key = nil
			end
		end,
		
	OnEnter = function(frame) 
		end,
	OnClick = function(frame, button)
			local character = frame.key
			if not character then return end

			local faction = view[ frame:GetParent():GetID() ].name
			local status, currentLevel, maxLevel, rate = DataStore:GetReputationInfo(character, faction)
			if not status then return end
			
			if ( button == "LeftButton" ) and ( IsShiftKeyDown() ) then
				local chat = ChatEdit_GetLastActiveWindow()
				if chat:IsShown() then
					chat:Insert(format(L["%s is %s with %s (%d/%d)"], DataStore:GetCharacterName(character), status, faction, currentLevel, maxLevel))
				end
			end
		end,
	OnLeave = function(self)
			AltoTooltip:Hide() 
		end,
	InitViewDDM = function(frame, title)
			dropDownFrame = frame
			frame:Show()
			title:Show()

			local currentXPack = addon:GetOption(OPTION_XPACK)
			local currentFactionGroup = addon:GetOption(OPTION_FACTION)
			
			if currentXPack and currentFactionGroup then
                currentDDMText = Factions[currentXPack][currentFactionGroup].name
            elseif currentXPack then
                currentDDMText = Factions[currentXPack].name
            end
			
			frame:SetMenuWidth(100) 
			frame:SetButtonWidth(20)
			frame:SetText(currentDDMText)
			frame:Initialize(DropDown_Initialize, "MENU_NO_BORDERS")
		end,
}

AltoholicTabGrids:RegisterGrid(20, callbacks)