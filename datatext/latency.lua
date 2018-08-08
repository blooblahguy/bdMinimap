local addon, stats = ...
local config = bdCore.config["Stats"]

local latency = CreateFrame("frame","Latency",UIParent)
latency:SetSize(40,20)
latency:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 4)
bdCore:setBackdrop(latency)
bdCore:makeMovable(latency)
latency:Hide()
latency.text = latency:CreateFontString(nil)
latency.text:SetFont(bdCore.media.font,13)
latency.text:SetPoint("LEFT", latency, "LEFT", 2, 0)

local function formatbandwith(number) 
	return round(number,2).."kb/s"
end

local colorlag = function(number)
	if number <= 100 then
		return '|cff00ff00'..number.."|r ms"
	elseif number <= 200 then
		return '|cffffff00'..number.."|r ms"
	else
		return '|cffff0000'..number.."|r ms"
	end
end

local mouseover = false

latency:SetScript("OnEnter", function() 
	latency:Tooltip()
	mouseover = true
end)
latency:SetScript("OnLeave", function()
	GameTooltip:Hide()
	mouseover = false
end)

function latency:Tooltip()
	ShowUIPanel(GameTooltip)
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
	
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()

	GameTooltip:AddDoubleLine("Latency",colorlag(latencyHome+latencyWorld),1,1,1, 1,1,1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("Home Latency",colorlag(latencyHome),1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine("World Latency",colorlag(latencyWorld),1,1,1, 1,1,1)
	
	GameTooltip:AddDoubleLine("Bandwidth In",formatbandwith(bandwidthIn),1,1,1, 1,1,1)
	GameTooltip:AddDoubleLine("Bandwidth Out",formatbandwith(bandwidthOut),1,1,1, 1,1,1)
	
	GameTooltip:Show()
end

function latency:Update()
	if (config.latency) then
		latency:Show()
		if (mouseover) then
			latency:Tooltip()
		end
		local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
		
		latency.text:SetText(colorlag(latencyHome))
		latency:SetWidth((string.len(latencyHome)*5.5)+24)
		latency.moveContainer:SetWidth(latency.background:GetWidth())
	else
		latency:Hide()
	end
end

latency:RegisterEvent("PLAYER_ENTERING_WORLD")
latency:RegisterEvent("PLAYER_MONEY")
local interval = 0
latency:SetScript("OnUpdate", function(self, elapsed) 
	interval = interval + elapsed
	if (interval >= 1) then
		interval = 0
		latency:Update()
	end
end)

latency:Update()
stats.latency = latency