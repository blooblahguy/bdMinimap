local addonName, core = ...
local config = bdConfigLib:GetSave('Minimap')
local xp_holder = core.xp_holder

local bar = CreateFrame("frame", "bdXP", UIParent)
bar:SetPoint("TOPLEFT", Minimap.background, "BOTTOMLEFT", 2, 0)
bar:SetPoint("BOTTOMRIGHT", Minimap.background, "BOTTOMRIGHT", -2, -20)
bar:SetFrameStrata("LOW")
bar:SetFrameLevel(6)
bdCore:setBackdrop(bar)

bar.xp = CreateFrame('StatusBar', nil, bar)
bar.xp:SetAllPoints(bar)
bar.xp:SetStatusBarTexture(bdCore.media.flat)
bar.xp:SetValue(0)

bar.rxp = CreateFrame('StatusBar', nil, bar)
bar.rxp:SetAllPoints(bar)
bar.rxp:SetStatusBarTexture(bdCore.media.flat)
bar.rxp:SetValue(0)
bar.rxp:SetStatusBarColor(.2, .4, 0.8, 1)
bar.rxp:SetAlpha(0.4)
bar.rxp:Hide()

bar:SetScript("OnEnter", function() bar.xp.text:SetAlpha(1) end)
bar:SetScript("OnLeave", function() bar.xp.text:SetAlpha(0) end)

local numberize = function(v)
	if v <= 9999 then return v end
	if v >= 1000000000 then
		local value = string.format("%.1fb", v/1000000000)
		return value
	elseif v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end
core.numberize = numberize

bar.bg = bar:CreateTexture("bg", 'BORDER')
bar.bg:SetAllPoints(bar)
bar.bg:SetTexture(bdCore.media.flat)
bar.bg:SetVertexColor(unpack(bdCore.media.backdrop))
		
bar.xp.text = bar.xp:CreateFontString("XP Text")
bar.xp.text:SetAllPoints()
bar.xp.text:SetJustifyH("CENTER")
bar.xp.text:SetJustifyV("CENTER")
bar.xp.text:SetFont(bdCore.media.font, 12, "OUTLINE")
bar.xp.text:SetAlpha(0)

bar:RegisterEvent("PLAYER_XP_UPDATE")
bar:RegisterEvent("PLAYER_LEVEL_UP")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
--bar:RegisterEvent("UPDATE_EXHAUSTION");
bar:RegisterEvent("UPDATE_FACTION")

function bar:Update()
	local bar = self
	local xp = UnitXP("player")
	local mxp = UnitXPMax("player")
	local rxp = GetXPExhaustion("player")
	local name, standing, minrep, maxrep, value = GetWatchedFactionInfo()

	if (config.xptracker) then
	
		bar:Show()
		bar.xp:SetMinMaxValues(0,mxp)
		if UnitLevel("player") == MAX_PLAYER_LEVEL or IsXPUserDisabled == true then
			if name then
				bar.xp:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 1)
				bar.xp:SetMinMaxValues(minrep,maxrep)
				bar.xp:SetValue(value)
				bar.xp.text:SetText(value-minrep.." / "..maxrep-minrep.." - "..floor(((value-minrep)/(maxrep-minrep))*1000)/10 .."% - ".. name)
			else
				bar:Hide()
			end
		else
			bar.xp:SetStatusBarColor(.4, .1, 0.6, 1)
			bar.xp:SetValue(xp)
			if rxp then
				bar.xp.text:SetText(numberize(xp).." / "..numberize(mxp).." - "..floor((xp/mxp)*1000)/10 .."%" .. " (+"..numberize(rxp)..")")
				bar.xp:SetMinMaxValues(0,mxp)
				bar.rxp:SetMinMaxValues(0, mxp)
				bar.xp:SetStatusBarColor(.2, .4, 0.8, 1)
				bar.xp:SetValue(xp)
				if (rxp+xp) >= mxp then
					bar.rxp:SetValue(mxp)
				else
					bar.rxp:SetValue(xp+rxp)
				end
				bar.rxp:Show()
			elseif xp > 0 and mxp > 0 then
				bar.xp.text:SetText(numberize(xp).." / "..numberize(mxp).." - "..floor((xp/mxp)*1000)/10 .."%")
				bar.rxp:Hide()
			end
		end
	else
		bar:Hide()
	end
end

bar:SetScript("OnEvent", bar.Update)
