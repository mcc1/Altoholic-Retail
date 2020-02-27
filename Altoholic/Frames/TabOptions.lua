local addonName = ...
local addon = _G[addonName]
local colors = addon.Colors

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local addonList = {
	"Altoholic",
	"Altoholic_Summary",
	"Altoholic_Characters",
	"Altoholic_Search",
	"Altoholic_Guild",
	"Altoholic_Achievements",
	"Altoholic_Agenda",
	"Altoholic_Grids",
}

local url1 = "https://www.curseforge.com/wow/addons/altoholic/"
local url2 = "https://github.com/teelolws/Altoholic-Retail"
local url3 = "http://wow.curseforge.com/addons/altoholic/localization/"

local help = {
	{	name = "General",
		questions = {
			"How do I remove a character that has been renamed/transfered/deleted?",
			"Does Altoholic support command line options?",
			"My minimap icon is gone, how do I get it back?",
			"What are the official homepages?",
			"What is this 'DataStore' thing? Why so many directories?",
			"I am developper, I want to know more about DataStore",
			"Does the add-on support FuBar?",
			"What is the add-on's memory footprint?",
			"Where have my suggestions gone?",
		},
		answers = {
			"Go into the 'Account Summary', mouse over the character, right-click it to get the contextual menu, and select 'Delete this Alt'.",
			"Type /alto or /altoholic to get the list of command line options.",
			"Go into Altoholic's main option panel, and check 'Show Minimap Icon'.\nYou can also type /alto show.",
			format("%s%s\n%s\n%s", "The add-on is only released on these two sites, it is recommended NOT TO get it through other means:", colors.green, url1, url2 ),
			"DataStore and its modules take care of storing data for client add-ons; Altoholic itself now only stores very little information. The main purpose of the numerous directories is to offer split databases, instead of one massive database containing all the information required by the add-on.",
			"Refer to DataStore's own help topic for more information.",
			"Not anymore. Instead, it supports LibDataBroker (aka LDB), if you really want FuBar, use Broker2FuBar.",
			"For 10 characters and 1 guild bank, the add-on takes around 4-5mb on my machine. Note that due to its name, the add-on is one of the first in the alphabet, and often gets credited of the memory/cpu usage of its libraries.",
			"Development is an iterative process, and I review parts of the add-on constantly. Depending on my spare time, some suggestions might take longer than others to make it into the add-on. Be patient, the add-on is still far from being complete.",
		}
	},
	{	name = "Containers",
		questions = {
			"Do I have to open all my bags to let the add-on know about their content?",
			"What about my bank? .. and my guild bank?",
			"Will the content of my bags be visible in the tooltip? Can I configure that?",
		},
		answers = {
			"No. This happens silently and does not require any action from your part.",
			"You have to open your bank in order to let the add-on read its content. Same goes for the guild bank, except that the add-on can only read it tab per tab, so make sure to open them all.",
			"Yes. There are several tooltip options that can be set to specify what you want to see or not."
		}
	},
	{	name = "Professions",
		questions = {
			"Do I have to open all professions manually?",
		},
		answers = {
			"Not anymore, on the Retail version of Altoholic. They are scanned when you login. Classic users will need to open the professions individually.",
		}
	},
	{	name = "Mails",
		questions = {
			"Can Altoholic read my mails without being at the mailbox?",
			"Altoholic marks all my mails as read, how can I avoid that?",
			"My mailbox is full, can Altoholic read beyond the list of visible mails?",
		},
		answers = {
			"No. This is a restriction imposed by Blizzard. Your character must physically be at a mailbox to retrieve your mails.",
			"Go into the 'Options -> DataStore -> DataStore_Mails' and disable 'Scan mail body'.",
			"No. You will have to clear your mailbox to release mails that are queued server-side.",
		}
	},
	{	name = "Localization",
		questions = {
			"I found a bad translation, how can I help fixing it?",
		},
		answers = {
			format("Use the CurseForge localization tool, at %s|r.", colors.green..url3),
		}
	},
}	

local support = {
	{	name = "Reporting Bugs",
		questions = {
			"I found an error, how/where do I report it?",
			"What should I do before reporting?",
			"I just upgraded to the latest version, and there are so many Lua errors, what the..??",
			"I have multiple Lua errors at login, should I report them all?",
		},
		answers = {
			format("%s%s", "Please use the Issue Tracker on Github: ", colors.green..url2),
			format("%s\n\n%s\n%s\n%s\n%s\n%s\n", 
				"A few things:",
				colors.green.."1)|r Make sure you have the latest version of the add-on. Check for alpha builds on Github that address your issue.\n",
				colors.green.."2)|r If you suspect a conflict with another add-on, try to reproduce the issue with only Altoholic enabled. As the add-on deals with a lot of things, a conflict is always possible.\n",
				colors.green.."3)|r Make sure your issue has not been reported by someone else.\n",
				colors.green.."4)|r Never, ever, report that 'it does not work', this is the most useless sentence in the world! Be specific about what does not work.\n",
				colors.green.."5)|r DO NOT copy the entire add-on list from Swatter. While conflicts are possible, they are the exception rather than the rule."
			),
			"I'm just human, I make mistakes. But because I'm human, I fix them too, so be patient. This is a project that I develop in my spare time, and it fluctuates a lot.",
			"No. Only the first error you will get is relevant, it means that something failed during the initialization process of the add-on, or of a library, and this is likely to cause several subsequent errors that are more often than not irrelevant.",
		}
	},
	{	name = "Live support",
		questions = {
			"Is there an IRC channel where I could get live support?",
		},
		answers = {
			format("Yes. Join the %s#altoholic|r IRC channel on Freenode : %sirc://irc.freenode.net:6667/|r", colors.white, colors.green),
		}
	},
}

-- this content will be subject to frequent changes, do not bother translating it !!
local whatsnew = {
    { name = "8.3.003 Changes",
        bulletedList = {
            "Updated Altoholic_Grids to allow for scrolling along more than 12 characters using arrow button at the bottom.",
        },
    },
    { name = "8.3.001 Changes",
        bulletedList = {   
            "Added new factions.",
        },
    },
	{	name = "8.2.001 Changes",
		bulletedList = {
			"Minor fixes.",
			"Added new factions.",
		},
	},
	{	name = "8.0.008 Changes",
		bulletedList = {
			"Added BfA factions. (Thanks AlexSUCF !!)",
			"Added BfA currencies.",
			"Added BfA emissary quests.",
			"Some quest achievements for BfA were rearranged to better reflect a character's progress.",
			"Fixed the percentage of rest xp for pandaren to now properly show 200% or 300% depending on the mode.",
			"Reworked the way rest xp is displayed in the addon, there is now a tooltip giving more info about rest xp, including when an alt will be fully rested."
		},
	},
	{	name = "8.0.007 Changes",
		bulletedList = {
			"Account Summary : Removed a test that prevented the herbalism & skinning tooltip from showing the proper per expansion information.",
		},
	},
	{	name = "8.0.006 Changes",
		bulletedList = {
			"Restored the emissaries panel.",
			"Fixed the 'All levels' filter in the account summary being limited to 110.",
			"Added support for War Campaign Missions."
		},
	},
	{	name = "8.0.005 Changes",
		bulletedList = {
			"Closed a lot of bugs from the Curse issues list, and implemented a lot of smaller fixes (thanks to all who contributed !).",
			"Fixed guild bank counters being displayed in the tooltip for guild banks from other factions, when the options were set not to display them. (Thanks Leo!)",
			"Reorganized several achievement categories (Thanks AlexSUCF !!)",
			"Added Legion Fishing Masters reputations (Thanks AlexSUCF !!)",
			"Search tab: Character level edit boxes now accept 3-digit values (Thanks AlexSUCF !!)",
			"Fixed scanning of transmog sets (Thanks AlexSUCF !!)",
			"Fixed several smaller issues (Thanks AlexSUCF !!)",
			"DataStore_Agenda: fixed calendar scanning of events with an invalid 'calendar type'. This fixes the spam of events you were maybe getting at logon. Just open your calendar on the affected alts, and you will be fine.",
			"Added support for paragon reputation levels (Thanks all4atlantis !!)",
			"Fixed the auto-completion of alt's names on the same realm, this should fix the 'This character might be someone you don't know.' problem.",
		},
	},
	{	name = "8.0.004 Changes",
		bulletedList = {
			"Fixed a Lua error when mousing over a recipe in the search panel. (Thanks KaraKaori !)",
			"Archaelogy is back on its feet :)",
			"Quick note about fishing: Fishing now seems to be seen as a series of recipes, like the other professions, even though there are no actual recipes.",
			"This means you actually have to press the 'Fishing Skills' button in the profession UI to get its proper level.",
			"Fixed the 'known by' tooltips, which did not properly left out 'unlearned' recipes.",
			"Removed the last occurences of first aid in a few places.",
			"Fixed a Lua error when visiting merchants selling recipes.",
			"The amount of gold displayed in various places is now shown with a thousands' separator.",
		},
	},
	{	name = "8.0.003 Changes",
		bulletedList = {
			"Slightly modified the 'totals' that appear at the bottom right so that it now fully belongs to the Summary tab.",
			"Characters tab : the profession panel has been fully reworked.",
			"Professions can now be filtered by categories, subcategories, color, inventory slot, learned/unlearned, and by their actual name.",
			"Profession cooldowns should be ok, but I did not have enough material at hand for tangible testing. Please let me know if you notice anything weird.",
			"Recipe tooltips like 'Could be learned by' etc.. should now be fully functioning again.",
		},
	},
	{	name = "8.0.002 Changes",
		bulletedList = {
			"Fixed a Lua error in DataStore_Agenda.",
			"Fixed DataStore_Containers not properly scanning some bank content.",
			"Fixed DataStore_Agenda not properly scanning WotLK item cooldowns.",
			"Fixed Item cooldowns breaking the agenda view.",
			"Fixed the errors in the Agenda tab.",
			"DataStore_Crafts: now properly scanning profession data, UI still being worked on.",
			"Fixed several UI errors related to professions."
		},
	},
	{	name = "8.0.001 Changes",
		bulletedList = {
			"Fixed a ton of Lua errors.",
			"Summary tab : the artifact menu has been disabled, since no data can be retrieved anymore.",
			"Summary tab : the first aid profession has been removed.",
			"Note : Quests and professions are still being reworked."
		},
	},
	{	name = "Earlier changes",
		textLines = {
			"Refer to |cFF00FF00changelog.txt",
		},
	},
}

function addon:GetOption(name)
	if addon.db and addon.db.global and addon.db.global.options then
		return addon.db.global.options[name]
	end
end

function addon:SetOption(name, value)
	if addon.db and addon.db.global and addon.db.global.options then 
		addon.db.global.options[name] = value
	end
end

function addon:ToggleOption(frame, option)
	local value
	
	if frame then
		value = frame:GetChecked() and true or false
	else
		value = not addon:GetOption(option)
	end
	
	addon:SetOption(option, value)
end

function addon:SetupOptions()
	-- create categories in Blizzard's options panel
	
	DataStore:AddOptionCategory(AltoholicGeneralOptions, addonName)
	LibStub("LibAboutPanel").new(addonName, addonName);
	DataStore:AddOptionCategory(AltoholicHelp, HELP_LABEL, addonName)
	DataStore:AddOptionCategory(AltoholicSupport, "Getting support", addonName)
	DataStore:AddOptionCategory(AltoholicWhatsNew, "What's new?", addonName)
	DataStore:AddOptionCategory(AltoholicMemoryOptions, L["Memory used"], addonName)
	DataStore:AddOptionCategory(AltoholicSearchOptions, SEARCH, addonName)
	DataStore:AddOptionCategory(AltoholicMailOptions, MAIL_LABEL, addonName)
	DataStore:AddOptionCategory(AltoholicMiscOptions, MISCELLANEOUS, addonName)
	DataStore:AddOptionCategory(AltoholicAccountSharingOptions, L["Account Sharing"], addonName)
	DataStore:AddOptionCategory(AltoholicSharedContent, "Shared Content", addonName)
	DataStore:AddOptionCategory(AltoholicTooltipOptions, L["Tooltip"], addonName)
	DataStore:AddOptionCategory(AltoholicCalendarOptions, L["Calendar"], addonName)

	DataStore:SetupInfoPanel(help, AltoholicHelp_Text)
	DataStore:SetupInfoPanel(support, AltoholicSupport_Text)
	DataStore:SetupInfoPanel(whatsnew, AltoholicWhatsNew_Text)
	
	help = nil
	support = nil
	whatsnew = nil
	
	local value
	local f = AltoholicGeneralOptions
	
	-- ** General **
	f.Title:SetText(colors.teal..format("%s %s", addonName, addon.Version))
	f.BankAutoUpdate.Text:SetText(L["Automatically authorize guild bank updates"])
	f.BankAutoUpdate.tooltip = format("%s%s%s",
		L["|cFFFFFFFFWhen |cFF00FF00enabled|cFFFFFFFF, this option will allow other Altoholic users\nto update their guild bank information with yours automatically.\n\n"],
		L["When |cFFFF0000disabled|cFFFFFFFF, your confirmation will be\nrequired before sending any information.\n\n"],
		L["Security hint: disable this if you have officer rights\non guild bank tabs that may not be viewed by everyone,\nand authorize requests manually"])
	
	f.ClampWindowToScreen.Text:SetText(L["Clamp window to screen"])
	
	L["|cFFFFFFFFWhen |cFF00FF00enabled|cFFFFFFFF, this option will allow other Altoholic users\nto update their guild bank information with yours automatically.\n\n"] = nil
	L["When |cFFFF0000disabled|cFFFFFFFF, your confirmation will be\nrequired before sending any information.\n\n"] = nil
	L["Security hint: disable this if you have officer rights\non guild bank tabs that may not be viewed by everyone,\nand authorize requests manually"] = nil
	L["Max rest XP displayed as 150%"] = nil
	L["Automatically authorize guild bank updates"] = nil
	
	value = AltoholicGeneralOptions_SliderAngle:GetValue()
	AltoholicGeneralOptions_SliderAngle.tooltipText = L["Move to change the angle of the minimap icon"]
	AltoholicGeneralOptions_SliderAngleLow:SetText("1");
	AltoholicGeneralOptions_SliderAngleHigh:SetText("360"); 
	AltoholicGeneralOptions_SliderAngleText:SetText(format("%s (%s)", L["Minimap Icon Angle"], value))
	L["Move to change the angle of the minimap icon"] = nil
	
	value = AltoholicGeneralOptions_SliderRadius:GetValue()
	AltoholicGeneralOptions_SliderRadius.tooltipText = L["Move to change the radius of the minimap icon"]; 
	AltoholicGeneralOptions_SliderRadiusLow:SetText("1");
	AltoholicGeneralOptions_SliderRadiusHigh:SetText("200"); 
	AltoholicGeneralOptions_SliderRadiusText:SetText(format("%s (%s)", L["Minimap Icon Radius"], value))
	L["Move to change the radius of the minimap icon"] = nil
	
	f = AltoholicGeneralOptions
	f.ShowMinimapIcon.Text:SetText(L["Show Minimap Icon"])
	L["Show Minimap Icon"] = nil
	
	value = AltoholicGeneralOptions_SliderAlpha:GetValue()
	AltoholicGeneralOptions_SliderAlphaLow:SetText("0.1");
	AltoholicGeneralOptions_SliderAlphaHigh:SetText("1.0"); 
	AltoholicGeneralOptions_SliderAlphaText:SetText(format("%s (%1.2f)", L["Transparency"], value));
	
	-- ** Memory **
	AltoholicMemoryOptions_AddonsText:SetText(colors.orange..ADDONS)
	local list = ""
	for index, module in ipairs(addonList) do
		list = format("%s%s:\n", list, module)
	end

	list = format("%s\n%s", list, format("%s:", L["Memory used"]))
	
	AltoholicMemoryOptions_AddonsList:SetText(list)
	
	-- ** Search **
	f = AltoholicSearchOptions
	f.ItemInfoAutoQuery.Text:SetText(L["AutoQuery server |cFFFF0000(disconnection risk)"])
	f.ItemInfoAutoQuery.tooltip = format("%s%s%s%s",
		L["|cFFFFFFFFIf an item not in the local item cache\nis encountered while searching loot tables,\nAltoholic will attempt to query the server for 5 new items.\n\n"],
		L["This will gradually improve the consistency of the searches,\nas more items are available in the item cache.\n\n"],
		L["There is a risk of disconnection if the queried item\nis a loot from a high level dungeon.\n\n"],
		L["|cFF00FF00Disable|r to avoid this risk"])	
	
	f.IncludeNoMinLevel.Text:SetText(L["Include items without level requirement"])
	f.IncludeMailboxItems.Text:SetText(L["Include mailboxes"])
	f.IncludeGuildBankItems.Text:SetText(L["Include guild bank(s)"])
	f.IncludeKnownRecipes.Text:SetText(L["Include known recipes"])
	L["AutoQuery server |cFFFF0000(disconnection risk)"] = nil
	L["Sort loots in descending order"] = nil
	L["Include items without level requirement"] = nil
	L["Include mailboxes"] = nil
	L["Include guild bank(s)"] = nil
	L["Include known recipes"] = nil
	
	-- ** Mail **
	value = AltoholicMailOptions_SliderTimeToNextWarning:GetValue()
	AltoholicMailOptions_SliderTimeToNextWarning.tooltipText = L["TIME_TO_NEXT_WARNING_TOOLTIP"]
	AltoholicMailOptions_SliderTimeToNextWarningLow:SetText("1");
	AltoholicMailOptions_SliderTimeToNextWarningHigh:SetText("12"); 
	AltoholicMailOptions_SliderTimeToNextWarningText:SetText(format("%s (%s)", L["TIME_TO_NEXT_WARNING_TEXT"], format(D_HOURS, value)))

	f = AltoholicMailOptions
	f.GuildMailWarning.Text:SetText(L["New mail notification"])
	f.GuildMailWarning.tooltip = format("%s",	L["Be informed when a guildmate sends a mail to one of my alts.\n\nMail content is directly visible without having to reconnect the character"])
	f.AutoCompleteRecipient.Text:SetText("Auto-complete recipient name" )
	L["New mail notification"] = nil

	f = AltoholicMiscOptions
	f.AHColorCoding.Text:SetText(L["Use color-coding for recipes at the AH"])
	f.VendorColorCoding.Text:SetText(L["Use color-coding for recipes at vendors"])
				
	-- ** Account Sharing **
	f = AltoholicAccountSharingOptions
	f.Text1:SetText(colors.white.."Authorizations")
	f.Text2:SetText(colors.white..L["Character"])
	f.IconNever:SetText("\124TInterface\\RaidFrame\\ReadyCheck-NotReady:14\124t")
	f.IconAsk:SetText("\124TInterface\\RaidFrame\\ReadyCheck-Waiting:14\124t")
	f.IconAuto:SetText("\124TInterface\\RaidFrame\\ReadyCheck-Ready:14\124t")
	f.IsEnabled.Text:SetText(L["Account Sharing Enabled"])
	f.IsEnabled.tooltip = format("%s%s%s%s",
		L["|cFFFFFFFFWhen |cFF00FF00enabled|cFFFFFFFF, this option will allow other Altoholic users\nto send you account sharing requests.\n"],
		L["Your confirmation will still be required any time someone requests your information.\n\n"],
		L["When |cFFFF0000disabled|cFFFFFFFF, all requests will be automatically rejected.\n\n"],
		L["Security hint: Only enable this when you actually need to transfer data,\ndisable otherwise"])

	L["Account Sharing Enabled"] = nil
	L["|cFFFFFFFFWhen |cFF00FF00enabled|cFFFFFFFF, this option will allow other Altoholic users\nto send you account sharing requests.\n"] = nil
	L["Your confirmation will still be required any time someone requests your information.\n\n"] = nil
	L["When |cFFFF0000disabled|cFFFFFFFF, all requests will be automatically rejected.\n\n"] = nil
	L["Security hint: Only enable this when you actually need to transfer data,\ndisable otherwise"] = nil

	AltoholicAccountSharingOptions_InfoButton.tooltip = format("%s\n%s\n\n%s", 
	
	colors.white.."This list allows you to automate responses to account sharing requests.",
	"You can choose to automatically accept or reject requests, or be asked when a request comes in.",
	"If account sharing is totally disabled, this list will be ignored, and all requests will be rejected." )
	
	
	-- ** Shared Content **
	AltoholicSharedContentText1:SetText(colors.white.."Shared Content")
	AltoholicSharedContent_SharedContentInfoButton.tooltip = format("%s\n%s", 
		colors.white.."Select the content that will be visible to players who send you",
		"account sharing requests.")
	
	
	-- ** Tooltip **
	f = AltoholicTooltipOptions
	f.ShowItemSource.Text:SetText(L["Show item source"])
	f.ShowItemCount.Text:SetText(L["Show item count per character"])
	f.ShowSimpleCount.Text:SetText(L["Show item count without details"])
	f.ShowTotalItemCount.Text:SetText(L["Show total item count"])
	f.ShowKnownRecipes.Text:SetText(L["Show recipes already known/learnable by"])
	f.ShowItemID.Text:SetText(L["Show item ID and item level"])
	f.ShowGatheringNodesCount.Text:SetText(L["Show counters on gathering nodes"])
	f.ShowCrossFactionCount.Text:SetText(L["Show counters for both factions"])
	f.ShowMergedRealmsCount.Text:SetText(L["Show counters for connected realms"])
    f.ShowAllRealmsCount.Text:SetText(L["Show counters for all realms"])
	f.ShowAllAccountsCount.Text:SetText(L["Show counters for all accounts"])
	f.ShowGuildBankCount.Text:SetText(L["Show guild bank count"])
	f.IncludeGuildBankInTotal.Text:SetText(L["Include guild bank count in the total count"])
	f.ShowGuildBankCountPerTab.Text:SetText(L["Detailed guild bank count"])
	L["Show item source"] = nil
	L["Show item count per character"] = nil
	L["Show item count without details"] = nil
	L["Show total item count"] = nil
	L["Show guild bank count"] = nil
	L["Show already known/learnable by"] = nil
	L["Show recipes already known/learnable by"] = nil
	L["Show item ID and item level"] = nil
	L["Show counters on gathering nodes"] = nil
	L["Show counters for both factions"] = nil
	L["Show counters for all accounts"] = nil
	L["Include guild bank count in the total count"] = nil
	
	-- ** Calendar **
	f = AltoholicCalendarOptions
	f.WeekStartsOnMonday.Text:SetText(L["Week starts on Monday"])
	f.UseDialogBoxForWarnings.Text:SetText(L["Display warnings in a dialog box"])
	f.WarningsEnabled.Text:SetText(L["Disable warnings"])
	L["Week starts on Monday"] = nil
	L["Warn %d minutes before an event starts"] = nil
	L["Display warnings in a dialog box"] = nil
	
	for i = 1, 4 do 
		addon:DDM_Initialize(_G["AltoholicCalendarOptions_WarningType"..i], Altoholic.Events.WarningType_Initialize)
	end
	UIDropDownMenu_SetText(AltoholicCalendarOptions_WarningType1, "Profession Cooldowns")
	UIDropDownMenu_SetText(AltoholicCalendarOptions_WarningType2, "Dungeon Resets")
	UIDropDownMenu_SetText(AltoholicCalendarOptions_WarningType3, "Calendar Events")
	UIDropDownMenu_SetText(AltoholicCalendarOptions_WarningType4, "Item Timers")
end

function addon:RestoreOptionsToUI()
	local O = Altoholic.db.global.options
	
	local f = AltoholicGeneralOptions
	
	f.BankAutoUpdate:SetChecked(O["UI.Tabs.Guild.BankAutoUpdate"])
	f.ClampWindowToScreen:SetChecked(O["UI.ClampWindowToScreen"])

	AltoholicGeneralOptions_SliderAngle:SetValue(O["UI.Minimap.IconAngle"])
	AltoholicGeneralOptions_SliderRadius:SetValue(O["UI.Minimap.IconRadius"])
	f.ShowMinimapIcon:SetChecked(O["UI.Minimap.ShowIcon"])
	AltoholicGeneralOptions_SliderScale:SetValue(O["UI.Scale"])
	AltoholicFrame:SetScale(O["UI.Scale"])
	AltoholicGeneralOptions_SliderAlpha:SetValue(O["UI.Transparency"])

	-- set communication handlers according to user settings.
	if O["UI.AccountSharing.IsEnabled"] then
		Altoholic.Comm.Sharing:SetMessageHandler("ActiveHandler")
	else
		Altoholic.Comm.Sharing:SetMessageHandler("EmptyHandler")
	end
	
	
	f = AltoholicSearchOptions
	
	f.ItemInfoAutoQuery:SetChecked(O["UI.Tabs.Search.ItemInfoAutoQuery"])
	f.IncludeNoMinLevel:SetChecked(O["UI.Tabs.Search.IncludeNoMinLevel"])
	f.IncludeMailboxItems:SetChecked(O["UI.Tabs.Search.IncludeMailboxItems"])
	f.IncludeGuildBankItems:SetChecked(O["UI.Tabs.Search.IncludeGuildBankItems"])
	f.IncludeKnownRecipes:SetChecked(O["UI.Tabs.Search.IncludeKnownRecipes"])

	AltoholicSearchOptionsLootInfo:SetText(colors.green .. O.TotalLoots .. "|r " .. L["Loots"] .. " / " .. colors.green .. O.UnknownLoots .. "|r " .. L["Unknown"])
	AltoholicSearchOptionsLootInfo:SetText(format("%s%s|r %s / %s%s|r %s", colors.green, O.TotalLoots, L["Loots"], colors.green, O.UnknownLoots, L["Unknown"]))
	
	f = AltoholicMailOptions
	AltoholicMailOptions_SliderTimeToNextWarning:SetValue(O["UI.Mail.TimeToNextWarning"])
	f.GuildMailWarning:SetChecked(O["UI.Mail.GuildMailWarning"])
	f.AutoCompleteRecipient:SetChecked(O["UI.Mail.AutoCompleteRecipient"])
	
	f = AltoholicMiscOptions
	f.AHColorCoding:SetChecked(O["UI.AHColorCoding"])
	f.VendorColorCoding:SetChecked(O["UI.VendorColorCoding"])
	
	f = AltoholicAccountSharingOptions
	f.IsEnabled:SetChecked(O["UI.AccountSharing.IsEnabled"])
	
	f = AltoholicTooltipOptions
	f.ShowItemSource:SetChecked(O["UI.Tooltip.ShowItemSource"])
	f.ShowItemCount:SetChecked(O["UI.Tooltip.ShowItemCount"])
	f.ShowTotalItemCount:SetChecked(O["UI.Tooltip.ShowTotalItemCount"])
	f.ShowKnownRecipes:SetChecked(O["UI.Tooltip.ShowKnownRecipes"])
	f.ShowItemID:SetChecked(O["UI.Tooltip.ShowItemID"])
	f.ShowGatheringNodesCount:SetChecked(O["UI.Tooltip.ShowGatheringNodesCount"])
	f.ShowCrossFactionCount:SetChecked(O["UI.Tooltip.ShowCrossFactionCount"])
	f.ShowMergedRealmsCount:SetChecked(O["UI.Tooltip.ShowMergedRealmsCount"])
    f.ShowAllRealmsCount:SetChecked(O["UI.Tooltip.ShowAllRealmsCount"])
	f.ShowAllAccountsCount:SetChecked(O["UI.Tooltip.ShowAllAccountsCount"])
	f.ShowGuildBankCount:SetChecked(O["UI.Tooltip.ShowGuildBankCount"])
	f.IncludeGuildBankInTotal:SetChecked(O["UI.Tooltip.IncludeGuildBankInTotal"])
	f.ShowGuildBankCountPerTab:SetChecked(O["UI.Tooltip.ShowGuildBankCountPerTab"])
	
	f = AltoholicCalendarOptions
	f.WeekStartsOnMonday:SetChecked(O["UI.Calendar.WeekStartsOnMonday"])
	f.UseDialogBoxForWarnings:SetChecked(O["UI.Calendar.UseDialogBoxForWarnings"])
	f.WarningsEnabled:SetChecked(O["UI.Calendar.WarningsEnabled"])
end

function addon:UpdateMyMemoryUsage()
	DataStore:UpdateMemoryUsage(addonList, AltoholicMemoryOptions, format("%s:", L["Memory used"]))
end

local function ResizeScrollFrame(frame, width, height)
	-- just a small wrapper, nothing generic in here.
	
	local name = frame:GetName()
	_G[name]:SetWidth(width-45)
	_G[name.."_ScrollFrame"]:SetWidth(width-45)
	_G[name]:SetHeight(height-30)
	_G[name.."_ScrollFrame"]:SetHeight(height-30)
	_G[name.."_Text"]:SetWidth(width-80)
end

local OnSizeUpdate = {	-- custom resize functions
	AltoholicHelp = ResizeScrollFrame,
	AltoholicSupport = ResizeScrollFrame,
	AltoholicWhatsNew = ResizeScrollFrame,
}

local OptionsPanelWidth, OptionsPanelHeight
local lastOptionsPanelWidth = 0
local lastOptionsPanelHeight = 0

function addon:OnUpdate(self, mandatoryResize)
	OptionsPanelWidth = InterfaceOptionsFramePanelContainer:GetWidth()
	OptionsPanelHeight = InterfaceOptionsFramePanelContainer:GetHeight()
	
	if not mandatoryResize then -- if resize is not mandatory, allow exit
		if OptionsPanelWidth == lastOptionsPanelWidth and OptionsPanelHeight == lastOptionsPanelHeight then return end		-- no size change ? exit
	end
		
	lastOptionsPanelWidth = OptionsPanelWidth
	lastOptionsPanelHeight = OptionsPanelHeight
	
	local frameName = self:GetName()
	if frameName and OnSizeUpdate[frameName] then
		OnSizeUpdate[frameName](self, OptionsPanelWidth, OptionsPanelHeight)
	end
end
