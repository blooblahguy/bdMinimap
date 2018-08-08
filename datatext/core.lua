local addon, stats = ...

local sv = bdCore.config.sv

local defaults = {
	[1] = {goldtrack = {
		type = "checkbox",
		value = true,
		label = "Gold Tracker",
		tooltip = "The gold tracker tracks all the gold between your characters",
		callback = function() stats.goldtrack:Update() end
	}},
	[2] = {durability = {
		type = "checkbox",
		value = true,
		label = "Durability Tracker",
		tooltip = "Shows your average durability",
		callback = function() stats.durability:Update() end
	}},
	[3] = {difficulty = {
		type = "checkbox",
		value = true,
		label = "Raid Difficulty",
		tooltip = "Shows the raid difficulty you have set",
		callback = function() stats.difficulty:Update() end
	}},
	[4] = {fightlength = {
		type = "checkbox",
		value = true,
		label = "Fight Length",
		tooltip = "Shows a timer for how long you've been in combat",
	}},
	[5] = {latency = {
		type = "checkbox",
		value = true,
		label = "Latency",
		tooltip = "Shows your latency, and network details on mouseover",
		callback = function() stats.latency:Update() end
	}},
	[6] = {memory = {
		type = "checkbox",
		value = true,
		label = "Memory",
		tooltip = "Shows your FPS, and memory details on mouseover. Click to collect garbage",
		callback = function() stats.memory:Update() end
	}},
	[7] = {specloot = {
		type = "checkbox",
		value = true,
		label = "Spec and Loot",
		tooltip = "Shows your current spec and loot specialization",
		callback = function() stats.specloot:Update() end
	}},
	[8] = {bagtrack = {
		type = "checkbox",
		value = true,
		label = "Bag Stats",
		tooltip = "Shows your free bag space, as well as any currency that you are tracking",
		callback = function() stats.bagtrack:Update() end
	}},
	[9] = {timetracker = {
		type = "checkbox",
		value = true,
		label = "Time",
		tooltip = "Shows the time, click to open stopwatch",
		callback = function() stats.timetracker:Update() end
	}},
}

bdCore:addModule("Stats", defaults)