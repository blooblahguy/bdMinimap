local addon, stats = ...
local config = bdCore.config["Stats"]

local timetracker = CreateFrame("frame","Time",UIParent)
timetracker:SetSize(30,20)
timetracker:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 4)
bdCore:setBackdrop(timetracker)
bdCore:makeMovable(timetracker)
timetracker:Hide()
timetracker.text = timetracker:CreateFontString(nil)
timetracker.text:SetFont(bdCore.media.font,13)
timetracker.text:SetPoint("LEFT", timetracker, "LEFT", 2, 0)

function timetracker:Update()
	if (config.timetracker) then
		timetracker:Show()
	else
		timetracker:Hide()
	end
end

timetracker:RegisterEvent("PLAYER_ENTERING_WORLD")
timetracker:SetScript("OnEvent", function() 
	timetracker:Update()
end)

LoadAddOn('Blizzard_TimeManager')
TimeManagerClockTicker:ClearAllPoints()
TimeManagerClockTicker:SetAllPoints(timetracker)
TimeManagerClockTicker:SetParent(timetracker)
TimeManagerClockTicker:SetFont(bdCore.media.font, 13)
TimeManagerClockTicker:SetJustifyH('CENTER')

TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetParent(timetracker)
TimeManagerClockButton:SetAllPoints(timetracker)
select(1, TimeManagerClockButton:GetRegions()):Hide()

timetracker:Update()

stats.timetracker = timetracker