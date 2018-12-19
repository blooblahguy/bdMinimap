local addonName, core = ...
local config = bdConfigLib:GetSave('Minimap')


ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOP", Minimap, "BOTTOM")


Minimap:Update()