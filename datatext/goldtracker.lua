local addon, stats = ...
local config = bdCore.config["Stats"]

local goldtrack = CreateFrame("frame","Gold",UIParent)
goldtrack:SetSize(70,20)
goldtrack:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -220, 4)
bdCore:setBackdrop(goldtrack)
bdCore:makeMovable(goldtrack)
goldtrack:Hide()
goldtrack.text = goldtrack:CreateFontString(nil)
goldtrack.text:SetFont(bdCore.media.font,13)
goldtrack.text:SetPoint("LEFT", goldtrack, "LEFT", 2, 0)

goldtrack:SetScript("OnEnter", function() 
	ShowUIPanel(GameTooltip)
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
	
	local total = 0;
	for name, stored in pairs(bdCore.config.sv.goldtrack) do
		local money, cc = unpack(stored)
		total = total + money
	end
	total = goldtrack:returnMoney(total)
	GameTooltip:AddDoubleLine("Money",total,1,1,1, 1,1,1)
	GameTooltip:AddLine(" ")
	for name, stored in pairs(bdCore.config.sv.goldtrack) do
		local money, cc = unpack(stored)
		local moneystring = goldtrack:returnMoney(money)
		GameTooltip:AddDoubleLine("|c"..cc..name.."|r ",moneystring,1,1,1, 1,1,1)
	end	
	
				
	GameTooltip:Show()
end)
goldtrack:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

function goldtrack:returnMoney(money)
	local gold = floor(abs(money / 10000))
	local silver = floor(abs(mod(money / 100, 100)))
	local copper = floor(abs(mod(money, 100)))
	

	local moneyString = "";
	if (gold > 0) then
		moneyString = comma_value(gold).."|cFFF0D440g|r";
	end
	if (silver > 0) then
		moneyString = moneyString.." "..silver.."|cFFC0C0C0s|r"
	end
	if (copper > 0) then
		moneyString = moneyString.." "..copper.."|cFFF0D440c|r"
	end
	
	return moneyString;
end

function goldtrack:Update()
	if (config.goldtrack) then
		goldtrack:Show()
		local money = GetMoney()
		local name, r = UnitName("player")
		local class, classFileName = UnitClass("player")
		local color = RAID_CLASS_COLORS[classFileName]
		moneyString = goldtrack:returnMoney(money)
		
		goldtrack:SetWidth(string.len(moneyString)*1.78)
		goldtrack.moveContainer:SetWidth(goldtrack:GetWidth()+4)
		goldtrack.text:SetText(moneyString)
		
		bdCore.config.sv.goldtrack[name] = {money, color.colorStr}
	else
		goldtrack:Hide()
	end
end

goldtrack:RegisterEvent("PLAYER_ENTERING_WORLD")
goldtrack:RegisterEvent("PLAYER_MONEY")
goldtrack:SetScript("OnEvent", function() 
	goldtrack:Update()
end)

stats.goldtrack = goldtrack