local addon, stats = ...
local config = bdCore.config["Stats"]

local fightlength = CreateFrame("frame","Fight Length",UIParent)
fightlength:SetSize(34,20)
fightlength:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 200, 4)
bdCore:setBackdrop(fightlength)
bdCore:makeMovable(fightlength)
fightlength:Hide()
fightlength.text = fightlength:CreateFontString(nil)
fightlength.text:SetFont(bdCore.media.font,13)
fightlength.text:SetPoint("LEFT", fightlength, "LEFT", 3, 0)
fightlength.text:SetText("00:00")
local incombat = false
local combattime = 0;

fightlength:RegisterEvent("ENCOUNTER_START")
fightlength:RegisterEvent("ENCOUNTER_END")
fightlength:SetScript("OnEvent", function(self, event) 
	if (config.fightlength) then
		fightlength:Show()
		if (event == "ENCOUNTER_START") then
			incombat = true;
		else
			incombat = false;
		end
		
		if (incombat == true) then
			combattime = 0
			local start = GetTime()
			local interval = 0
			fightlength:SetScript("OnUpdate", function(self,elapsed)
				interval = interval + elapsed
				if (interval >= 0.1) then
					interval = 0
					
					local combattime = round(GetTime()-start)
					local stringtime = string.format("%.2d:%.2d", combattime/60%60, combattime%60)
					
					fightlength.text:SetText(stringtime)
				end
			end)
		else
			if (fightlength.text:GetText() ~= "00:00") then
				print("Combat ended at "..fightlength.text:GetText())
			end
			fightlength:SetScript("OnUpdate", function() return end)
		end
	else
		fightlength:Hide()
	end
end)

stats.fightlength = fightlength