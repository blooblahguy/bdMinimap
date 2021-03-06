local addonName, core = ...
local config = bdConfigLib.profile['Minimap']
local ap_holder = core.ap_holder
local ap_lib = LibStub:GetLibrary("LibArtifactPower-1.0")

local holder = CreateFrame("Frame", "bdAP", UIParent)
holder:SetFrameStrata("LOW")
holder:SetFrameLevel(6)
holder:SetHeight(24)
bdCore:setBackdrop(holder)

-- use ap button
local ap_button = CreateFrame("Button", "bdAP_Button", holder, "SecureActionButtonTemplate")
ap_button:SetSize(20, 20)
ap_button:SetPoint("TOPRIGHT", holder, "TOPLEFT")
ap_button:SetAttribute("type", nil)
ap_button:SetAttribute("item", "item")
ap_button:Hide()
bdCore:setBackdrop(ap_button)

ap_button.t = ap_button:CreateTexture(nil, "OVERLAY")
ap_button.t:SetTexCoord(.1, .9, .1, .9)
ap_button.t:SetAllPoints()

-- progress bar
local ap_prog = CreateFrame("StatusBar", nil, holder)
ap_prog:SetAllPoints(holder)
ap_prog:SetStatusBarTexture(bdCore.media.flat)
ap_prog:SetValue(0)
ap_prog:SetStatusBarColor(.89, .8, .5)

-- text
holder.text = ap_prog:CreateFontString(nil, "OVERLAY")
holder.text:SetFont(bdCore.media.font, 14, "OUTLINE")
holder.text:SetPoint("CENTER", holder, "CENTER")
holder.text:SetTextColor(1,1,1)
holder.text:SetAlpha(0)
holder:SetScript("OnEnter", function() holder.text:SetAlpha(1) end)
holder:SetScript("OnLeave", function() holder.text:SetAlpha(0) end)

-- ap in bags bar
local ap_pend = CreateFrame("StatusBar", nil, holder)
ap_pend:SetAllPoints(holder)
ap_pend:SetStatusBarTexture(bdCore.media.flat)
ap_pend:SetValue(0)
ap_pend:SetStatusBarColor(.89, .8, .5)
ap_pend:SetAlpha(0.4)

-- tooltip scanning
local tooltip = CreateFrame('GameTooltip', 'bdAPScanner', UIParent, 'GameTooltipTemplate')
tooltip:SetOwner(UIParent, 'ANCHOR_NONE')

-- empowering cast
local numberize = core.numberize
local empowering = select(1, GetSpellInfo(228111))
local function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- update everything
function updateAP()
	if (InCombatLockdown()) then return end
	if (not config.aptracker or not C_ArtifactUI or not select(1, C_ArtifactUI.GetEquippedArtifactInfo()) ) then
		holder:Hide()
		Minimap:Update()
		return
	end

	holder:Show()

	local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
	if (not pointsSpent or not artifactTier) then return end
	local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent, artifactTier);

	ap_prog:SetMinMaxValues(0, xpForNextPoint)
	ap_pend:SetMinMaxValues(0, xpForNextPoint)
	ap_prog:SetValue(xp)

	local apBags = 0;
	local cur_button = nil
	local cur_item = nil
	for b = 0, 4 do
		for s = 1, GetContainerNumSlots(b) do
			local itemID = GetContainerItemID(b, s)
			local amount = ap_lib:GetArtifactPowerGrantedByItem(itemID)
			if (amount) then
				apBags = apBags + amount

				if (not cur_button) then
					cur_button = itemID
					cur_item = GetContainerItemLink(b, s)
				end
			end

			--[[if (id and IsArtifactPowerItem(id)) then
				tooltip:ClearLines()
				tooltip:SetHyperlink(item)

				for k = tooltip:NumLines(), 1, -1 do
					local million = (_G[tooltip:GetName()..'TextLeft'..k]:GetText() or ""):find("million")
					local billion = (_G[tooltip:GetName()..'TextLeft'..k]:GetText() or ""):find("billion")
					local ap = (_G[tooltip:GetName()..'TextLeft'..k]:GetText() or ""):match("(%d*%.?%d+)")

					if ap then
						if (not cur_button) then
							cur_button = id
							cur_item = item
						end

						ap = ap:gsub(",","")
						if (million) then ap = ap * 1000000 end
						if (billion) then ap = ap * 1000000000 end
						apBags = apBags + tonumber(ap)
						break;
					end
				end
			end--]]
		end
	end

	local anchor = Minimap.background
	local xoffset = 2
	local yoffset = 0
	if (bdXP and bdXP:IsShown()) then
		anchor = bdXP
		xoffset = 0
		yoffset = 2
	end

	if (apBags > 0) then
		holder:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 20 + xoffset, -yoffset)
		holder:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xoffset, -(20 + yoffset))

		ap_button.id = nil
		ap_button:Show()
		ap_button:SetAttribute("type", "item")   
		ap_button:SetAttribute("item", "item:"..cur_button)     
		ap_button.t:SetTexture(GetItemIcon(cur_button))
		if (MouseIsOver(ap_button)) then
			GameTooltip:Hide()
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(cur_item)
			GameTooltip:Show()
		end
		ap_button:SetScript("OnEnter", function()
			ShowUIPanel(GameTooltip)
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(cur_item)
			GameTooltip:Show()
		end)
		ap_button:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		holder.text:SetText(numberize(xp).." / "..numberize(xpForNextPoint).." - "..floor((xp/xpForNextPoint)*1000)/10 .."%" .. " (+"..numberize(apBags)..")")

		ap_pend:Show()
		ap_pend:SetValue(xp + apBags)
	else
		holder:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", xoffset, -yoffset)
		holder:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xoffset, -(20 + yoffset))

		holder.text:SetText(numberize(xp).." / "..numberize(xpForNextPoint).." - "..floor((xp/xpForNextPoint)*1000)/10 .."%")
		ap_pend:Hide()
		ap_button:Hide()
		ap_button.id = nil
		ap_button:SetAttribute("type", nil)
		ap_button:SetAttribute("item", nil) 
	end

	Minimap:Update()

	--print("current xp", comma_value(xp))
	--print("points for next", comma_value(xpForNextPoint))
	--print("ap in bags", comma_value(apBags))
end

bdCore:hookEvent("bd_mm_reconfig", updateAP)
holder:RegisterEvent("BAG_UPDATE")
holder:SetScript("OnEvent", updateAP)

