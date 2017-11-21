-- BAG_UPDATE PLAYER_REGEN_ENABLED

for bag = 0, NUM_BAG_SLOTS do        
	for slot = 1, GetContainerNumSlots(bag) do            
		local itemIdx = GetContainerItemID(bag, slot)            
		local itemSpellc = GetItemSpell(itemIdx)
		local acxc = {GetContainerItemInfo(bag, slot)}
		if acxc[1] ~= nil then
			if itemSpellc and itemSpellc == aura_env.empowering or acxc[1] == 1041434 or acxc[1] == 1041435 then
				local icon = GetItemIcon(itemIdx)                
				WeakAuras.regions[aura_env.id].region:SetTexture(icon)               
				aura_env.button:Show()                
				aura_env.button:SetAttribute("type", "item")                
				aura_env.button:SetAttribute("item", "item:"..itemIdx)               
				return true
			end            
		end
	end
end
WeakAuras.regions[aura_env.id].region:SetTexture(nil)
aura_env.button:SetAttribute("type", nil)
aura_env.button:SetAttribute("item", nil) 
aura_env.button:Hide()

aura_env.empowering = select(1, GetSpellInfo(228111))

-- Create button and fill WA region
aura_env.button = CreateFrame("Button", "UseArtifactButton", WeakAuras.regions[aura_env.id].region, "SecureActionButtonTemplate")
aura_env.button:SetAllPoints(WeakAuras.regions[aura_env.id].region)

function()
    local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
    
    local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent, artifactTier);
    
    
    return xp, xpForNextPoint, true
end
function()
    if (C_ArtifactUI.GetEquippedArtifactInfo()) then
        local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
        return xp
    end

end
function()
    
    
    if (C_ArtifactUI.GetEquippedArtifactInfo()) then
        
        
        local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
        
        local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent, artifactTier);
        
        
        local shortnum = function(v)
            if v <= 9999 then
                return v
            elseif v >= 1000000000 then
                return format("%.3f B", v/1000000000)           
            elseif v >= 1000000 then
                return format("%.0f m", v/1000000)
            elseif v >= 10000 then
                return format("%.1f k", v/1000)
            end
        end
        
        ret = shortnum(xpForNextPoint)
        rettt =  shortnum(xp)
        
        return rettt .." / " .. ret
        
    end
end

function()
    
    if (C_ArtifactUI.GetEquippedArtifactInfo()) then
        
        
        
        
        local itemID, altItemID, name, icon, xp, pointsSpent, quality, artifactAppearanceID, appearanceModID, itemAppearanceID, altItemAppearanceID, altOnTop, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo();
        
        local xpForNextPoint = C_ArtifactUI.GetCostForPointAtRank(pointsSpent, artifactTier);
        
        
        
        
        return string.format("%.2f", xp / xpForNextPoint * 100)
        
        
    end
    
end



local _, ns = ...

local tooltip = CreateFrame('GameTooltip', 'iipArtifactScanner', UIParent, 'GameTooltipTemplate')
tooltip:SetOwner(UIParent, 'ANCHOR_NONE')

local bu = CreateFrame('Button', nil, UIParent, 'SecureActionButtonTemplate')
bu:SetSize(21, 21)
bu:SetFrameLevel(0)
bu:SetAttribute('type', 'item')
bu:SetPoint('CENTER', UIParent, 'CENTER', 0, 8)
--bu:Hide()

bu.t = bu:CreateTexture()
bu.t:SetTexCoord(.1, .9, .1, .9)
bu.t:SetAllPoints()

bu.cd = CreateFrame('Cooldown', nil, bu, 'CooldownFrameTemplate')
bu.cd:SetAllPoints()

bu.text = bu:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
bu.text:SetPoint('RIGHT', bu, 'LEFT', -7, 1)

local cooldown = function()
	if  bu.id then
		local start, cd = GetItemCooldown(bu.id)
		bu.cd:SetCooldown(start, cd)
	end
end

local hide = function()
	bu.id = nil
	bu:SetAttribute('item', nil)
	--bu:Hide()
	bu.t:SetTexture''
	bu.text:SetText''
end

local show = function(id, ap)
	print("show")
	bu.id = id
	bu:SetAttribute('item', 'item:'..id)
	bu:ClearAllPoints()
	bu:Show()
	bu.t:SetTexture(GetItemIcon(id))
	bu.text:SetText(string.format('%d %s'..' +', ap, 'Artifact Power'))

end

local scan = function()
	hide()
	for i = 0, 4 do
		for j = 1, GetContainerNumSlots(i) do
			local item = GetContainerItemLink(i, j)
			local id   = GetContainerItemID(i, j)
			if id then
				tooltip:ClearLines()
				tooltip:SetHyperlink(item)
				local two = _G[tooltip:GetName()..'TextLeft2']
				if two and two:GetText() then
					if strmatch(two:GetText(), 'Artifact Power') then
						local four = _G[tooltip:GetName()..'TextLeft4']:GetText()
						four = gsub(four, ',', '')  --  strip BreakUpLargeNumbers
						local ap = string.match(four, '%d+')
						if ap then show(id, ap) break end
					end
				end
			end
		end
	end
end

bu:SetScript('OnEnter', function()
	GameTooltip:SetOwner(bu, 'ANCHOR_TOP')
	if bu.id then GameTooltip:SetItemByID(bu.id) end
end)

bu:SetScript('OnLeave', function() GameTooltip:Hide() end)

local f = CreateFrame'Frame'
f:RegisterEvent'BAG_UPDATE_COOLDOWN'
f:RegisterEvent'SPELL_UPDATE_COOLDOWN'
f:RegisterEvent'BAG_UPDATE_DELAYED'
f:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)

function f:BAG_UPDATE_COOLDOWN()   cooldown() end
function f:SPELL_UPDATE_COOLDOWN() cooldown() end
function f:BAG_UPDATE_DELAYED()
	if InCombatLockdown() then
		f:RegisterEvent'PLAYER_REGEN_ENABLED'
	else
		scan()
	end
end
function f:PLAYER_REGEN_ENABLED()
	scan()
	f:UnregisterEvent'PLAYER_REGEN_ENABLED'
end