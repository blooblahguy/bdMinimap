local name, addon = ...
local bar = CreateFrame("frame", "bdXP", UIParent)
local defaults = {}

-- function bar:Draw()
	-- bar:SetWidth(C['xp']['width'])
	-- bar:SetHeight(C['xp']['height'])
	
	-- bar.xp:SetWidth(C['xp']['width'])
	-- bar.xp:SetHeight(C['xp']['height'])
	
	-- bar.rxp:SetWidth(C['xp']['width'])
	-- bar.rxp:SetHeight(C['xp']['height'])
-- end
	local anchor = Minimap.background or Minimap or UIParent
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 2, 0)
	bar:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -2, -14)
	bar:SetFrameStrata("LOW")
	bar:SetFrameLevel(6)
	bar:SetBackdrop({bgFile = bdCore.media.flat, insets = {top = -2, left = -2, bottom = -2, right = -2}})
	bar:SetBackdropColor(unpack(bdCore.media.border))
	--bar:Hide()

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

	bar:SetScript("OnEvent", function(self,event)
		xp = UnitXP("player")
		mxp = UnitXPMax("player")
		rxp = GetXPExhaustion("player")
		name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
		
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
	end)
