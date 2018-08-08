local addon, stats = ...
local config = bdCore.config["Stats"]

local durability = CreateFrame("frame","Durability",UIParent)
durability:SetSize(70,20)
durability:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -330, 4)
bdCore:setBackdrop(durability)
bdCore:makeMovable(durability)
durability:Hide()
durability.text = durability:CreateFontString(nil)
durability.text:SetFont(bdCore.media.font,13)
durability.text:SetPoint("LEFT", durability, "LEFT", 2, 0)

function durability:Update()
	if (config.durability) then
		durability:Show()
		local average = 0;
		local total = 0;
		local totalmax = 0;
		for i = 1, 16 do
			local durability, max = GetInventoryItemDurability(i)
			if (durability) then
				total = total + durability
				totalmax = totalmax + max
			end
		end
		
		durability.text:SetText(round(total/totalmax*100).."%")
		durability:SetWidth((string.len(durability.text:GetText())*5.5)+9)
		durability.moveContainer:SetWidth(durability.background:GetWidth())
	else
		durability:Hide()
	end
end

durability:RegisterEvent("PLAYER_ENTERING_WORLD")
durability:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
durability:SetScript("OnEvent", function() 
	durability:Update()
end)

durability:Update()
stats.durability = durability