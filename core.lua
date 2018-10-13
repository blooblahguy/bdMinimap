local addonName, core = ...
local config = bdConfigLib.profile['Minimap']

function GetMinimapShape() return "SQUARE" end

Minimap.background = CreateFrame("frame", "bdMinimap", Minimap)
Minimap.background:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
Minimap.background:SetBackdrop({bgFile = bdCore.media.flat, edgeFile = bdCore.media.flat, edgeSize = 2})
Minimap.background:SetBackdropColor(0,0,0,0)
Minimap.background:SetBackdropBorderColor(unpack(bdCore.media.border))

local framerate = Minimap:CreateFontString(nil, "OVERLAY")
framerate:SetFont(bdCore.media.font, 10)
framerate:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 2, -2)
Minimap:HookScript("OnUpdate", function(self)
	framerate:SetText(math.floor(GetFramerate()))
end)

--[[local bf_holder = CreateFrame("Frame", nil, UIParent)
bf_holder:SetPoint("TOPLEFT", Minimap.background, "BOTTOMLEFT")
bf_holder:SetPoint("TOPRIGHT", Minimap.background, "BOTTOMRIGHT")--]]

function Minimap:Update()
	config = bdCore.config.profile['Minimap']
	if (bdXP) then 
		bdXP:Update()
	end

	-- show/hide time
	if not IsAddOnLoaded("Blizzard_TimeManager") then
		LoadAddOn('Blizzard_TimeManager')
	end
	if (config.showtime) then
		TimeManagerClockButton:SetAlpha(1)
		TimeManagerClockButton:Show()
	else
		TimeManagerClockButton:SetAlpha(0)
		TimeManagerClockButton:Hide()
	end

	-- Hide Class Hall Button
	

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

	if (config.buttonpos == "Disable") then
		Minimap.buttonFrame:ClearAllPoints()
		Minimap.buttonFrame:Hide()
	else 
		Minimap.buttonFrame:ClearAllPoints()

		if (config.buttonpos == "Top") then
			Minimap.buttonFrame:SetPoint("BOTTOMLEFT", Minimap.background, "TOPLEFT", 2, 4)
			Minimap.buttonFrame:SetPoint("TOPRIGHT", Minimap.background, "TOPRIGHT", -2, 28)
		elseif (config.buttonpos == "Right") then
			Minimap.buttonFrame:SetPoint("TOPLEFT", Minimap.background, "TOPRIGHT", 4, -2)
			Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", 28, 2)
		elseif (config.buttonpos == "Bottom") then
			Minimap.buttonFrame:SetPoint("TOPLEFT", Minimap.background, "BOTTOMLEFT", 2, -4)
			Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", -2, -28)
			
			if (bdAP and bdAP:IsShown()) then
				Minimap.buttonFrame:SetPoint("TOPLEFT", bdAP, "BOTTOMLEFT", 0, -6)
				Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", bdAP, "BOTTOMRIGHT", 0, -30)
			elseif (config.xptracker) then
				Minimap.buttonFrame:SetPoint("TOPLEFT", bdXP, "BOTTOMLEFT", 0, -6)
				Minimap.buttonFrame:SetPoint("BOTTOMRIGHT", bdXP, "BOTTOMRIGHT", 0, -30)
			end
		elseif (config.buttonpos == "Left") then
			Minimap.buttonFrame:SetPoint("TOPRIGHT", Minimap.background, "TOPLEFT", -4, -2)
			Minimap.buttonFrame:SetPoint("BOTTOMLEFT", Minimap.background, "BOTTOMLEFT", -28, 2)
		end
	end
end
bdCore:hookEvent("bd_reconfig",function() Minimap:Update() end)
bdCore:hookEvent("bd_mm_reconfig",function() Minimap:Update() end)
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
manualTarget['COHCMinimapButton'] = true
manualTarget['ZygorGuidesViewerMapIcon'] = true

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
	if (bdAP and bdAP:IsMouseOver()) then over = true end
	
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
	-- table.insert(c,_G["DugisOnOffButton"])
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
				f:SetScale(1)
				f.SetSize = bdCore.noop
				f.SetWidth = bdCore.noop
				f.SetHeight = bdCore.noop
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

			-- sometimes a frame can get in here twice, don't let it
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

-- thank you to xcoords
local bdCoords = CreateFrame("frame", nil, WorldMapFrame)
bdCoords.text = bdCoords:CreateFontString(nil, "OVERLAY")
bdCoords.text:SetFont(bdCore.media.font, 14)
bdCoords.text:SetAllPoints()
bdCoords.text:SetJustifyH("CENTER")
bdCoords:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM")
bdCoords:SetFrameStrata("TOOLTIP")
bdCoords:SetSize(300, 40)
bdCoords:SetScript("OnUpdate", function(self)
	-- Player
	local uiMapID = C_Map.GetBestMapForUnit("player")
	local position = C_Map.GetPlayerMapPosition(uiMapID, "player")

	if (not position) then return end
	
	local pX, pY = position:GetXY()
	local nick = '';

	if (not pX) then return end
	pX = pX*100
	pY = pY*100
	pX = math.floor(pX*10)/10
	pY = math.floor(pY*10)/10
	if pX == 0.0 or pY == 0.0 then
		Nick = "N/A";
	else
		Nick = UnitName("player")
		pX = string.format("%.1f", pX)
		pY = string.format("%.1f", pY)
		Nick = Nick .. ": |cffffffff" .. pX .. ", " .. pY;
	end

	-- Cursor
	local width, height, scale = WorldMapFrame:GetWidth(), WorldMapFrame:GetHeight(), WorldMapFrame:GetEffectiveScale();
	local cX, cY = WorldMapFrame:GetCenter()
	local left, bottom = cX - width / 2, cY + height /2;

	cX, cY = GetCursorPosition();
	cX, cY = (cX / scale - left) / width * 100, (bottom - cY / scale) / height * 100;
	
	if cX < 0 or cX > 100 or cY < 0 or cY > 100 then
		cursor = "N/A"
	else
		--cX = cX*100
		--cY = cY*100
		cX = math.floor(cX*10)/10
		cY = math.floor(cY*10)/10
		cX = string.format("%.1f", cX)
		cY = string.format("%.1f", cY)
		cursor = "Cursor: |cffffffff" .. cX .. ", " .. cY;
	end

	self.text:SetText(Nick .. "|r  -  " .. cursor .. "|r");

	if (WorldMapFrameSizeUpButton and not WorldMapFrameSizeUpButton.hooked) then
		WorldMapFrameSizeUpButton.hooked = true
		WorldMapFrameSizeUpButton:HookScript("OnClick", coordsResize)
	end
	if (not WorldMapFrame.hooked) then
		WorldMapFrame.hooked = true
		WorldMapFrame:HookScript("OnShow", coordsResize)
	end
end)


-- todo; these globals changes
function coordsResize()
	if WORLDMAP_SETTINGS and WORLDMAP_WINDOWED_SIZE and (WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE) then
		bdCoords:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM", 0, 20)
	else 
		bdCoords:SetPoint("BOTTOM", WorldMapFrame, "BOTTOM", 0, 10)
	end
end


