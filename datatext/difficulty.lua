local addon, stats = ...
local config = bdCore.config["Stats"]

local difficulty = CreateFrame("frame","Instance Difficulty",UIParent)
difficulty:SetSize(70,20)
difficulty:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 120, 4)
bdCore:setBackdrop(difficulty)
bdCore:makeMovable(difficulty)
difficulty:Hide()
difficulty.text = difficulty:CreateFontString(nil)
difficulty.text:SetFont(bdCore.media.font,13)
difficulty.text:SetPoint("LEFT", difficulty, "LEFT", 2, 0)
difficulty.text:SetText(" ")

function difficulty:Update()
	if (config.difficulty) then
		difficulty:Show()
		local setting = select(3, GetInstanceInfo())
		local diff = GetRaidDifficultyID()

		if setting == 0 then
			difficulty.text:SetText("Raid:  ")
			setting = GetRaidDifficultyID()
		end
		if (setting == 1) then
			difficulty.text:SetText("Raid: 5")
		elseif setting == 2 then
			difficulty.text:SetText("Raid: 5H")
		elseif setting == 3 then
			difficulty.text:SetText("Raid: 10")
		elseif setting == 4 then
			difficulty.text:SetText("Raid: 25")
		elseif setting == 5 then
			difficulty.text:SetText("Raid: 10H")
		elseif setting == 6 then
			difficulty.text:SetText("Raid: 25H")
		elseif setting == 7 then
			difficulty.text:SetText("Raid: LFR")
		elseif setting == 8 then
			difficulty.text:SetText("Raid: CM")
		elseif setting == 9 then
			difficulty.text:SetText("Raid: 40")
		elseif setting == 11 then
			difficulty.text:SetText("Raid: HScen")
		elseif setting == 12 then
			difficulty.text:SetText("Raid: Scen")
		elseif setting == 14 then
			difficulty.text:SetText("Raid: N")
		elseif setting == 15 then
			difficulty.text:SetText("Raid: H")
		elseif setting == 16 then
			difficulty.text:SetText("Raid: M")
		end
		
		difficulty:SetWidth((string.len(difficulty.text:GetText())*4.5)+9)
		difficulty.moveContainer:SetWidth(difficulty.background:GetWidth())
	else
		difficulty:Hide()
	end
end

difficulty:RegisterEvent("PLAYER_ENTERING_WORLD")
difficulty:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
difficulty:RegisterEvent("GUILD_PARTY_STATE_UPDATED")
difficulty:SetScript("OnEvent", function() 
	difficulty:Update()
end)

difficulty:Update()

stats.difficulty = difficulty