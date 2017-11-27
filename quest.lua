local addonName, core = ...
local config = bdCore.config.profile['Minimap']


ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOP", Minimap, "BOTTOM")


Minimap:Update()