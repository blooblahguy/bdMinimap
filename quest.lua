local addonName, core = ...
local config = bdConfigLib.profile['Minimap']


ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOP", Minimap, "BOTTOM")


Minimap:Update()