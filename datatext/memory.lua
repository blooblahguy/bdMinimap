local addon, stats = ...
local config = bdCore.config["Stats"]

local memory = CreateFrame("button","Memory",UIParent)
memory:SetSize(40,20)
memory:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 6, 4)
bdCore:setBackdrop(memory)
bdCore:makeMovable(memory)
memory:Hide()
memory.text = memory:CreateFontString(nil)
memory.text:SetFont(bdCore.media.font,13)
memory.text:SetPoint("LEFT", memory, "LEFT", 2, 0)

local function formatMemory(bytes)
	bytes = bytes > 0 and bytes * 1024 or 0.001

	local s = {'B', 'Kb', 'MB', 'GB', 'TB'}
	local e = floor(abs(log(bytes)/log(1024))) or 0
	return format('%.1f '..s[e+1], (bytes/1024^e))
end
local colorfps = function(number)
	if number >= 30 then
		return '|cff00ff00'
	elseif number < 30 then
		return '|cffffff00'
	elseif number < 15 then
		return '|cffff0000'
	end
end
local FormatMemoryNumber = function(number)
	if number > 1000 then
		return string.format('%.2f mb', number / 1000)
	else
		return string.format('%.1f kb', number)
	end
end

memory:SetScript("OnClick", function()
	local before = 0

	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local mem = GetAddOnMemoryUsage(i)
			tinsert (memory, {select(2, GetAddOnInfo(i)), mem})
			before = before + mem
		end
	end
	
	collectgarbage("collect")
	
	local after = 0

	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local mem = GetAddOnMemoryUsage(i)
			tinsert (memory, {select(2, GetAddOnInfo(i)), mem})
			after = after + mem
		end
	end
	
	print("Cleaned out "..formatMemory(before-after).." of addon garbage")
end)

memory:SetScript("OnEnter", function() 
	if InCombatLockdown() then return end
	UpdateAddOnMemoryUsage()
	ShowUIPanel(GameTooltip)
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")

	local memory = {}
	local total = 0

	for i = 1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local mem = GetAddOnMemoryUsage(i)
			tinsert (memory, {select(2, GetAddOnInfo(i)), mem})
			total = total + mem
		end
	end

	table.sort(memory, function(a, b)
		return a[2] > b[2]
	end)

	--fixTooltip(self)
	GameTooltip:AddDoubleLine('Total Usage', formatMemory(total), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddLine(' ')
	for i = 1, #memory do
		GameTooltip:AddDoubleLine(memory[i][1], formatMemory(memory[i][2]), 1, 1, 1, bdCore:colorGradient(1 - memory[i][2]/total))
	end
	GameTooltip:Show()
end)
memory:SetScript("OnLeave", function()
	GameTooltip:Hide()
end)

function memory:Update()
	if (config.memory) then
		memory.text:SetText(string.format('%s%d|r fps', colorfps(GetFramerate()), GetFramerate()))
		memory:SetWidth((string.len(round(GetFramerate(),0))*5.5)+26)
		memory.moveContainer:SetWidth(memory.background:GetWidth())
		memory:Show()
	else
		memory:Hide()
	end
end

local interval = 0
memory:SetScript('OnUpdate', function(self, elapsed)
	interval = interval + elapsed
	if interval >= 1 then
		interval = 0
		memory:Update()
	end
end)

memory:Update()

stats.memory = memory