--[[
Author: Teelo - Jubei'thos (Retail) / Teelo - Arugal (Classic)
This Grid tab will track two things:
1. Cloak level
2. Corruption level
]]

local addonName = "Altoholic"
local addon = _G[addonName]
local colors = addon.Colors

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local callbacks = {
	OnUpdate = function() end,
	GetSize = function() return 2 end,
	RowSetup = function(self, rowFrame, dataRowID)
            if dataRowID == 1 then
			     rowFrame.Name.Text:SetText("Cloak Level")
			     rowFrame.Name.Text:SetJustifyH("RIGHT")
            elseif dataRowID == 2 then
                rowFrame.Name.Text:SetText("Corruption Level")
                rowFrame.Name.Text:SetJustifyH("RIGHT")
            end
		end,
	RowOnEnter = function()	end,
	RowOnLeave = function() end,
	ColumnSetup = function(self, button, dataRowID, character)
			button.Background:SetDesaturated(false)
			button.Background:SetVertexColor(1.0, 1.0, 1.0)
			button.Background:SetTexCoord(0, 1, 0, 1)
			
			button.Name:SetFontObject("NumberFontNormalSmall")
			button.Name:SetJustifyH("RIGHT")
			button.Name:SetPoint("BOTTOMRIGHT", 0, 0)
			
            local cloakLevel, corruptionLevel = DataStore:GetCorruptionInfo(character)

            if (dataRowID == 1) and cloakLevel and (tonumber(cloakLevel) > 0) then
				button.key = character
				button.Background:SetTexture(C_Item.GetItemIconByID(169223))
				button.Name:SetText(cloakLevel)
			elseif (dataRowID == 2) and corruptionLevel and (tonumber(corruptionLevel) > 0) then
                button.key = character 
                button.Background:SetTexture(3004126)
                button.Name:SetText(corruptionLevel)
            else
				button.key = nil
				button.Background:SetTexture(nil)
				button.Name:SetText("")
			end
			
			button.id = dataRowID
		end,
		
	OnEnter = function(frame) 
			local character = frame.key
			if not character then return end

			GameTooltip:SetOwner(frame, "ANCHOR_LEFT")
		end,
	OnClick = function(frame, button)
		end,
	OnLeave = function(self) 
		end,
	InitViewDDM = function(frame, title) 
			frame:Hide()
			title:Hide()
		end,
}

AltoholicTabGrids:RegisterGrid(14, callbacks)
