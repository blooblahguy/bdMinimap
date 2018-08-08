local addon, stats = ...
local config = bdCore.config["Stats"]

local specloot = CreateFrame("frame","Spec/Loot",UIParent)
specloot:SetSize(70,20)
specloot:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 200, 4)
bdCore:setBackdrop(specloot)
bdCore:makeMovable(specloot)
specloot:Hide()
specloot.text = specloot:CreateFontString(nil)
specloot.text:SetFont(bdCore.media.font,13)
specloot.text:SetPoint("LEFT", specloot, "LEFT", 4, 0)

function specloot:Update()
	if (config.specloot) then
		specloot:Show()
		local specID = GetSpecialization()
		local lootID = GetLootSpecialization()
		if (not specID) then return end
		local id, specname, description, specicon, background, role, primaryStat = GetSpecializationInfo(specID)
		local id, lootname, description, looticon, background, role, class = GetSpecializationInfoByID(lootID)
		if (looticon == nil) then
			looticon = specicon
		end
		if (specicon and looticon) then
			local specstring = "Spec: |T"..specicon..":12:12:0:0:12:12|t  Loot: |T"..looticon..":12|t "
			
			specloot.text:SetText(specstring)
			specloot:SetWidth((string.len("Spec:  Loot: ")*5.6)+24)
			specloot.moveContainer:SetWidth(specloot:GetWidth()+4)
		end
	else
		specloot:Hide()
	end
end

specloot:RegisterEvent("PLAYER_ENTERING_WORLD")
specloot:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
specloot:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
specloot:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
specloot:SetScript("OnEvent", function(self, event)
	specloot:Update()
end)

stats.specloot = specloot