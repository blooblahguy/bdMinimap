local addon, stats = ...
local config = bdCore.config["Stats"]

local bagtrack = CreateFrame("button","Bag Stats",UIParent)
bagtrack:SetSize(70,20)
bagtrack:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -4, 4)
bdCore:setBackdrop(bagtrack)
bdCore:makeMovable(bagtrack)
bagtrack:Hide()
bagtrack.text = bagtrack:CreateFontString(nil)
bagtrack.text:SetFont(bdCore.media.font,13)
bagtrack.text:SetPoint("LEFT", bagtrack, "LEFT", 4, 0)

bagtrack:SetScript("OnClick", function() 
	OpenAllBags()
end)


local function GetNumFreeSlots()
	local freeslots = 0
	local totalslots = 0
	for lbag=0,4 do
		local numFreeSlots, BagType = GetContainerNumFreeSlots(lbag)
		local numSlots = GetContainerNumSlots(lbag)
		freeslots = freeslots + numFreeSlots
		totalslots = totalslots + numSlots
	end
	return freeslots, totalslots
end

function bagtrack:Update()
	if (config.bagtrack) then
		bagtrack:Show()
		local freeslots,totalslots = GetNumFreeSlots()
		local bagstring = "Bags: "..freeslots.."/"..totalslots.." ";
		local numTracked = 0;
		local textlength = string.len(bagstring);
		
		for i = 1, MAX_WATCHED_TOKENS do
			local name, count, icon, itemID = GetBackpackCurrencyInfo(i)
			if (name) then
				bagstring = bagstring.." |T"..icon..":12|t "..count
				numTracked = numTracked + 1
				textlength = textlength + string.len(count)+2
			end
		end
		
		
		bagtrack.text:SetText(bagstring)
		bagtrack:SetWidth((textlength*5.5)+(numTracked*12))
		bagtrack.moveContainer:SetWidth(bagtrack:GetWidth()+4)
	else
		bagtrack:Hide()
	end
end

bagtrack:RegisterEvent("PLAYER_ENTERING_WORLD")
bagtrack:RegisterEvent("CHAT_MSG_LOOT")
bagtrack:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bagtrack:SetScript("OnEvent", function() 
	bagtrack:Update()
end)
local interval = 0
bagtrack:SetScript("OnUpdate", function(self,elapsed)
	interval = interval + elapsed
	if (interval >= 1) then
		interval = 0
		bagtrack:Update()
	end
end)

bagtrack:Update()

stats.bagtrack = bagtrack