
--[[ Instance Difficulty - From FreeUI by Haleth]]
local difftext = {}

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("CHALLENGE_MODE_START")
rd:RegisterEvent("CHALLENGE_MODE_COMPLETED")
rd:RegisterEvent("CHALLENGE_MODE_RESET")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
rd:RegisterEvent("ZONE_CHANGED_NEW_AREA")
local rdt = rd:CreateFontString(nil, "OVERLAY")
rdt:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", -4, 6)
rdt:SetFont(bdCore.media.font, 14, "OUTLINE")
rdt:SetJustifyH("RIGHT")
rdt:SetTextColor(.7,.7,.7)
rd:SetScript("OnEvent", function()
	local difficulty = select(3, GetInstanceInfo())
	local numplayers = select(9, GetInstanceInfo())
	local mplusdiff = select(1, C_ChallengeMode.GetActiveKeystoneInfo()) or "";

	if (difficulty == 1) then
		rdt:SetText("5")
	elseif difficulty == 2 then
		rdt:SetText("5H")
	elseif difficulty == 3 then
		rdt:SetText("10")
	elseif difficulty == 4 then
		rdt:SetText("25")
	elseif difficulty == 5 then
		rdt:SetText("10H")
	elseif difficulty == 6 then
		rdt:SetText("25H")
	elseif difficulty == 7 then
		rdt:SetText("LFR")
	elseif difficulty == 8 then
		rdt:SetText("M+"..mplusdiff)
	elseif difficulty == 9 then
		rdt:SetText("40")
	elseif difficulty == 11 then
		rdt:SetText("HScen")
	elseif difficulty == 12 then
		rdt:SetText("Scen")
	elseif difficulty == 14 then
		rdt:SetText("N:"..numplayers)
	elseif difficulty == 15 then
		rdt:SetText("H:"..numplayers)
	elseif difficulty == 16 then
		rdt:SetText("M")
	elseif difficulty == 17 then
		rdt:SetText("LFR:"..numplayers)
	elseif difficulty == 23 then
		rdt:SetText("M+")
	elseif difficulty == 24 then
		rdt:SetText("TW")
	else
		rdt:SetText("")
	end
end)

MinimapCluster:EnableMouse(false)
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap.background, "TOPRIGHT", -2, -2)
GarrisonLandingPageMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:SetParent(Minimap)

Minimap:RegisterEvent("PLAYER_ENTERING_WORLD")
Minimap:HookScript("OnEvent", function(self, event)
	if (event == "PLAYER_ENTERING_WORLD") then
		bdCore:makeMovable(UIErrorsFrame)	
	end
end)

local dummy = function() end
local frames = {
	"MiniMapVoiceChatFrame",
	"MiniMapWorldMapButton",
	"MinimapZoneTextButton",
	"MiniMapMailBorder",
	"MiniMapInstanceDifficulty",
	"MinimapNorthTag",
	"MinimapZoomOut",
	"MinimapZoomIn",
	"MinimapBackdrop",
	"GameTimeFrame",
	"GuildInstanceDifficulty",
	"MiniMapChallengeMode",
	"MinimapBorderTop",
	"MinimapBorder",
	"MiniMapTracking",
}
for i = 1, (getn(frames)) do
	_G[frames[i]]:Hide()
	_G[frames[i]].Show = dummy
end

--local zone = GetZoneText()
--[[
local subzoneText = GetSubZoneText()

local subzonetext = Minimap:CreateFontString(nil)
subzonetext:SetFont(bdCore.media.font,14,"OUTLINE")
subzonetext:SetPoint("BOTTOMLEFT", Minimap.background, "BOTTOMLEFT", 4, 4)
subzonetext:SetText(GetSubZoneText())
subzonetext:SetTextColor(.8,.8,.8,1)

Minimap:RegisterEvent("ZONE_CHANGED")
Minimap:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Minimap:RegisterEvent("ZONE_CHANGED_INDOORS")
Minimap:SetScript("OnEvent",function()
	if (string.len(GetSubZoneText()) > 0) then
		subzonetext:SetText(GetSubZoneText())
	else
		subzonetext:SetText(GetZoneText())
	end
end)
--]]
-- ZoneTextString:SetTextColor(1,1,1)
--[[
QueueStatusMinimapButton:Show()
QueueStatusMinimapButton:SetSize(30, 30)
QueueStatusMinimapButtonIcon:SetSize(30, 30)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("TOPRIGHT", Minimap.background, "TOPRIGHT", -2, -1)--]]
--MinimapNorthTag:SetAlpha(0)

--MiniMapMailIcon:SetTexture('Interface\\Minimap\\TRACKING\\Mailbox')
--[[MiniMapMailIcon:SetAllPoints(MiniMapMailFrame)
MiniMapMailIcon:SetTexCoord(0.3,0.7,0.3,0.7)
MiniMapMailIcon:SetRotation(rad(-36))--]]

function dropdownOnClick(self)
	GameTooltip:Hide()
	DropDownList1:ClearAllPoints()
	DropDownList1:SetPoint('TOPLEFT', Minimap.background, 'TOPRIGHT', 2, 0)
end

Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
	if delta > 0 then
		MinimapZoomIn:Click()
	elseif delta < 0 then
		MinimapZoomOut:Click()
	end
end)

Minimap:SetScript('OnMouseUp', function (self, button)
	if button == 'RightButton' then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, Minimap.background, (Minimap:GetWidth()), (Minimap.background:GetHeight()-2))
		GameTooltip:Hide()
	elseif button == 'MiddleButton' then
		if not IsAddOnLoaded("Blizzard_Calendar") then
			LoadAddOn('Blizzard_Calendar')
		end
		Calendar_Toggle()
	else
		Minimap_OnClick(self)
	end
end)

local mailupdate = CreateFrame("frame")
mailupdate:RegisterEvent("MAIL_CLOSED")
mailupdate:RegisterEvent("MAIL_INBOX_UPDATE")
mailupdate:SetScript("OnEvent",function(self, event)
	if (event == "MAIL_CLOSED") then
		CheckInbox();
	else
		InboxFrame_Update()
		OpenMail_Update()
	end
end)
MiniMapMailIcon:SetTexture(nil)
MiniMapMailFrame.mail = MiniMapMailFrame:CreateFontString(nil,"OVERLAY")
MiniMapMailFrame.mail:SetFont(bdCore.media.font, 16)
MiniMapMailFrame.mail:SetText("M")
MiniMapMailFrame.mail:SetJustifyH("CENTER")
MiniMapMailFrame.mail:SetPoint("CENTER",MiniMapMailFrame,"CENTER",1,-1)
MiniMapMailFrame:RegisterEvent("UPDATE_PENDING_MAIL")
MiniMapMailFrame:RegisterEvent("MAIL_INBOX_UPDATE")
MiniMapMailFrame:RegisterEvent("MAIL_CLOSED")
MiniMapMailBorder:Hide()

if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn('Blizzard_TimeManager')
end
select(1, TimeManagerClockButton:GetRegions()):Hide()
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOMLEFT",Minimap.background,"BOTTOMLEFT",5,-2)
TimeManagerClockTicker:SetFont(bdCore.media.font, 16,"OUTLINE")
TimeManagerClockTicker:SetAllPoints(TimeManagerClockButton)
TimeManagerClockTicker:SetJustifyH('LEFT')
TimeManagerClockTicker:SetShadowColor(0,0,0,0)