local addonName = ...
local addon = _G[addonName]
local colors = addon.Colors

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local THIS_ACCOUNT = "Default"

local function OnAccountChange(frame, dropDownFrame)
	local oldAccount = dropDownFrame:GetCurrentAccount()
	local newAccount = frame.value
	
	dropDownFrame:SetCurrentAccount(newAccount)

	if oldAccount then	-- clear the "select char" drop down if account has changed
		if oldAccount ~= newAccount then
			dropDownFrame:TriggerClassEvent("AccountChanged", newAccount)
		end
	end
end

addon:Controller("AltoholicUI.AccountPicker", {
	OnBind = function(frame)
		frame:SetMenuWidth(frame.menuWidth) 
		frame:SetButtonWidth(20)
		frame:Initialize(frame.DropDownAccount_Initialize)
		frame:SetCurrentAccount("Default")
	end,
	DropDownAccount_Initialize = function(frame)
		if not frame.currentAccount then return end

		-- this account first ..
		frame:AddTitle(colors.gold..L["This account"])
		local info = frame:CreateInfo()

		info.text = L["This account"]
		info.value = THIS_ACCOUNT 
		info.checked = nil
		info.func = OnAccountChange
		info.arg1 = frame
		frame:AddButtonInfo(info, 1)

		-- .. then all other accounts
		local accounts = DataStore:GetAccounts()
		local count = 0
		for account in pairs(accounts) do
			if account ~= THIS_ACCOUNT then
				count = count + 1
			end
		end
		
		if count > 0 then
			frame:AddTitle()
			frame:AddTitle(colors.gold..OTHER)
			
			for account in pairs(accounts) do
				if account ~= THIS_ACCOUNT then
					local info = frame:CreateInfo()
					info.text = format("%s%s", colors.green, account)
					info.value = format("%s", account)
					info.checked = nil
					info.func = OnAccountChange
					info.arg1 = frame
					frame:AddButtonInfo(info, 1)
				end
			end
		end
		
		frame:TriggerClassEvent("DropDownInitialized")
	end,
	SetCurrentAccount = function(frame, account)
		account = account or THIS_ACCOUNT
		frame.currentAccount = account
		frame:SetSelectedValue(account)
        if account == THIS_ACCOUNT then account = L["This account"] end
		frame:SetText(format("%s%s", colors.green, account))
	end,
	GetCurrentAccount = function(frame)
		return frame.currentAccount
	end,
})
