local addon, map = ...

local defaults = {}
defaults[#defaults+1] = {size = {
	type="slider",
	value=300,
	step=2,
	min=50,
	max=400,
	label="Size",
	tooltip="Width and Height of Minimap",
	callback = function() Minimap:Update() end
}}

defaults[#defaults+1] = {shape = {
	type="dropdown",
	value="Rectangle",
	options={"Rectangle","Square"},
	label="Minimap Shape",
	callback = function() Minimap:Update() end
}}
defaults[#defaults+1] = {buttonpos = {
	type="dropdown",
	value="Bottom",
	options={"Disable","Top","Right","Bottom","Left"},
	label="Minimap Buttons position",
	callback = function() Minimap:Update() end
}}
defaults[#defaults+1] = {mouseoverbuttonframe= {
	type="checkbox",
	value=false,
	label="Hide Minimap Button frame until mouseover"
}}
defaults[#defaults+1] = {showconfig= {
	type="checkbox",
	value=true,
	label="Show bdConfig button",
	callback = function() Minimap:Update() end
}}

bdCore:addModule("Minimap", defaults)
local config = bdCore.config.profile['Minimap']

function GetMinimapShape() return "SQUARE" end

Minimap.background = CreateFrame("frame","bdMinimap",UIParent)
Minimap.background:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
Minimap.background:SetBackdrop({bgFile = bdCore.media.flat, edgeFile = bdCore.media.flat, edgeSize = 2})
Minimap.background:SetBackdropColor(0,0,0,0)
Minimap.background:SetBackdropBorderColor(unpack(bdCore.media.border))

function Minimap:Update()
	config = bdCore.config.profile['Minimap']
	if (config.shape == "Rectangle") then
		Minimap:SetMaskTexture("Interface\\Addons\\bdMinimap\\rectangle.tga")
		Minimap.background:SetSize(config.size, config.size*.75)
		Minimap:SetSize(config.size, config.size)
		Minimap:SetHitRectInsets(0, 0, config.size/8, config.size/8)
		Minimap:SetClampRectInsets(0, 0, -config.size/4, -config.size/4)
	else
		Minimap:SetMaskTexture(bdCore.media.flat)
		Minimap.background:SetSize(config.size, config.size)
		Minimap:SetSize(config.size, config.size)
		Minimap:SetHitRectInsets(0, 0, 0, 0)
		Minimap:SetClampRectInsets(0, 0, 0, 0)
	end
end
bdCore:hookEvent("bd_reconfig",function() Minimap:Update() end)
Minimap:EnableMouse(true)
Minimap:SetMaskTexture("Interface\\Addons\\bdMinimap\\rectangle.tga")
Minimap:SetArchBlobRingScalar(0);
Minimap:SetQuestBlobRingScalar(0);
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 40, 20)

-- hopefully the below stops shithead addons from making minimap not a square
Minimap:RegisterEvent("ADDON_LOADED")
Minimap:RegisterEvent("PLAYER_ENTERING_WORLD")
Minimap:RegisterEvent("LOADING_SCREEN_DISABLED")
Minimap:HookScript("OnEvent", function()
	function GetMinimapShape() return "SQUARE" end
	return
end)
--Minimap:SetClampedToScreen(true)
bdCore:makeMovable(Minimap)

local c = {Minimap:GetRegions()}
for i = 1, #c do
	if c[i].GetTexture then
		print(c[i]:GetTexture())
	end
end

local ignoreFrames = {}
local hideTextures = {}
local manualTarget = {}
manualTarget['MiniMapMailFrame'] = true
ignoreFrames['MinimapBackdrop'] = true
ignoreFrames['GameTimeFrame'] = true
ignoreFrames['MinimapVoiceChatFrame'] = true
--blizzFrames['QueueStatusMinimapButton'] = true
ignoreFrames['TimeManagerClockButton'] = true
hideTextures['Interface\\Minimap\\MiniMap-TrackingBorder'] = true
hideTextures['Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight'] = true
hideTextures['Interface\\Minimap\\UI-Minimap-Background'] = true

Minimap.buttonFrame = CreateFrame("frame",nil,Minimap)
Minimap.buttonFrame:SetPoint("TOPLEFT", Minimap.background, "BOTTOMLEFT", 2, -4)
Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", 0, -28)
Minimap.buttonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Minimap.buttonFrame:RegisterEvent("GARRISON_UPDATE")
Minimap.buttonFrame:RegisterEvent("PLAYER_XP_UPDATE")
Minimap.buttonFrame:RegisterEvent("PLAYER_LEVEL_UP")
Minimap.buttonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
Minimap.buttonFrame:RegisterEvent("UPDATE_FACTION")

local bdConfigButton = CreateFrame("button","bdCore_configButton", Minimap.buttonFrame)
bdConfigButton.text = bdConfigButton:CreateFontString(nil,"OVERLAY")
bdConfigButton.text:SetFont(bdCore.media.font,16)
bdConfigButton.text:SetTextColor(.4,.6,1)
bdConfigButton.text:SetText("bd")
bdConfigButton.text:SetJustifyH("CENTER")
bdConfigButton.text:SetPoint("CENTER", bdConfigButton, "CENTER", 1, -1)
bdConfigButton:SetScript("OnEnter", function(self) 
	self.text:SetTextColor(.6,.8,1) 
	ShowUIPanel(GameTooltip)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 6)
	GameTooltip:AddLine("Big Dumb Config")
	GameTooltip:Show()
end)
bdConfigButton:SetScript("OnLeave", function(self) 
	self.text:SetTextColor(.4,.6,1) 
	GameTooltip:Hide()
end)
bdConfigButton:SetScript("OnClick", function() bdCore:toggleConfig() end)

local function mmMouseover()
	if (not config.mouseoverbuttonframe) then Minimap.buttonFrame:Show(); return true end

	local over = false
	if (Minimap:IsMouseOver()) then over = true end
	if (Minimap.background:IsMouseOver()) then over = true end
	if (Minimap.buttonFrame:IsMouseOver()) then over = true end
	if (bdXP and bdXP:IsMouseOver()) then over = true end
	
	if (over) then 
		Minimap.buttonFrame:Show()
	else
		Minimap.buttonFrame:Hide()
	end
	
	return over
end
local mtotal = 0
Minimap:HookScript("OnUpdate",function(self,elapsed)
	mtotal = mtotal + elapsed
	if (mtotal > .05) then
		mtotal = 0;
		mmMouseover()
	end
end)
--bdCore:setBackdrop(Minimap.hoverZone)
Minimap:Update()

local function moveMinimapButtons()
	if (InCombatLockdown()) then return end
	if (config.buttonpos == "Disable") then return end
	
	
	if (config.buttonpos == "Top") then
		Minimap.buttonFrame:ClearAllPoints()
		Minimap.buttonFrame:SetPoint("BOTTOMLEFT", Minimap.background, "TOPLEFT", 2, 4)
		Minimap.buttonFrame:SetPoint("TOPRIGHT", Minimap.background, "TOPRIGHT", -2, 28)
	end
	if (config.buttonpos == "Right") then
		Minimap.buttonFrame:ClearAllPoints()
		Minimap.buttonFrame:SetPoint("TOPLEFT", Minimap.background, "TOPRIGHT", 4, -2)
		Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", 28, 2)
	end
	if (config.buttonpos == "Bottom") then
		Minimap.buttonFrame:ClearAllPoints()
		Minimap.buttonFrame:SetPoint("TOPLEFT", Minimap.background, "BOTTOMLEFT", 2, -4)
		Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", -2, -28)
		
		if (bdXP and bdXP:IsShown()) then
			Minimap.buttonFrame:SetPoint("TOPLEFT", bdXP, "BOTTOMLEFT", 0, -6)
			Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", bdXP, "BOTTOMRIGHT", 0, -30)
		end
	end
	if (config.buttonpos == "Left") then
		Minimap.buttonFrame:ClearAllPoints()
		Minimap.buttonFrame:SetPoint("TOPRIGHT", Minimap.background, "TOPLEFT", -4, -2)
		Minimap.buttonFrame:SetPoint("BOTTOMLEFT", Minimap.background, "BOTTOMLEFT", -28, 2)
	end
	
	
	if (config.showconfig) then
		ignoreFrames['bdCore_config'] = nil
		bdConfigButton:Show()
	else
		ignoreFrames['bdCore_config'] = true
		bdConfigButton:Hide()
	end
	
	local c = {Minimap.buttonFrame:GetChildren()}
	local d = {Minimap:GetChildren()}
	for k, v in pairs(d) do table.insert(c,v) end
	table.insert(c,_G["DugisOnOffButton"])
	local last = nil
	for i = 1, #c do
		local f = c[i]
		local n = f:GetName() or "";
		if ((manualTarget[n] and f:IsShown() ) or (
			f:GetName() and 
			f:IsShown() and 
			(strfind(n, "LibDB") or strfind(n, "Button") or strfind(n, "Btn")) and 
			not ignoreFrames[n]
		)) then 
			--print(f:GetName())
			if (not f.skinned) then
				f:SetSize(24,24)
				f:SetParent(Minimap.buttonFrame)
				local r = {f:GetRegions()}
				for o = 1, #r do
					if (r[o].GetTexture and r[o]:GetTexture()) then
						local tex = r[o]:GetTexture()
						r[o]:SetAllPoints(f)
						if (hideTextures[tex]) then
							r[o]:Hide()
						elseif (not strfind(tex,"WHITE8x8")) then
							local coord = table.concat({r[o]:GetTexCoord()})
							if (coord == "00011011") then
								r[o]:SetTexCoord(0.3, 0.7, 0.3, 0.7)
								if (n == "DugisOnOffButton") then
									r[o]:SetTexCoord(0.25, 0.75, 0.2, 0.7)								
								end
							end
						end
					end
				end
				
				f.bdbackground = f.bdbackground or CreateFrame("frame",nil,f)
				f.bdbackground:SetAllPoints(f)
				f.bdbackground:SetFrameStrata("BACKGROUND")
				bdCore:setBackdrop(f.bdbackground)
				f:SetHitRectInsets(0, 0, 0, 0)
				local oldscript = 
				f:HookScript("OnEnter",function(self)
					local newlines = {}
					for l = 1, 10 do
						local line = _G["GameTooltipTextLeft"..l]
						if (line and line:GetText()) then
							newlines[line:GetText()] = true
						end
					end
					
					GameTooltip:Hide()
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 6)
					for k, v in pairs(newlines) do
						GameTooltip:AddLine(k)
					end
					GameTooltip:Show()
				end)
				f.skinned = true
			end
			f:ClearAllPoints()
			if (config.buttonpos == "Top" or config.buttonpos == "Bottom") then
				if (last) then
					f:SetPoint("LEFT", last, "RIGHT", 6, 0)		
				else
					f:SetPoint("TOPLEFT", Minimap.buttonFrame, "TOPLEFT", 0, 0)
				end
			end
			if (config.buttonpos == "Right" or config.buttonpos == "Left") then
				if (last) then
					f:SetPoint("TOP", last, "BOTTOM", 0, -6)		
				else
					f:SetPoint("TOPLEFT", Minimap.buttonFrame, "TOPLEFT", 0, 0)
				end
			end
			

			last = f
		end
	end
end

Minimap.buttonFrame:SetScript("OnEvent",moveMinimapButtons)
local total = 0
Minimap.buttonFrame:SetScript("OnUpdate",function(self,elapsed)
	total = total + elapsed
	if (total > .5) then
		total = 0
		if (not InCombatLockdown()) then
			moveMinimapButtons()
		end
	end
end)

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