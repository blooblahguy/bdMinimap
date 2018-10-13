-- config options here	

local defaults = {}
defaults[#defaults+1] = {size = {
	type="slider",
	value=300,
	step=2,
	min=50,
	max=600,
	label="Size",
	tooltip="Width and Height of Minimap",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}

defaults[#defaults+1] = {shape = {
	type="dropdown",
	value="Rectangle",
	options={"Rectangle","Square"},
	label="Minimap Shape",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}
defaults[#defaults+1] = {buttonpos = {
	type="dropdown",
	value="Bottom",
	options={"Disable","Top","Right","Bottom","Left"},
	label="Minimap Buttons position",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}
defaults[#defaults+1] = {mouseoverbuttonframe= {
	type="checkbox",
	value=false,
	label="Hide Minimap Button frame until mouseover"
}}
defaults[#defaults+1] = {showconfig= {
	type="checkbox",
	value=true,
	label="Show bdConfig button",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}

defaults[#defaults+1] = {xptracker= {
	type="checkbox",
	value=true,
	label="Enable XP/Rep tracker",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}

defaults[#defaults+1] = {showtime = {
	type="checkbox",
	value=true,
	label="Show Time",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}

defaults[#defaults+1] = {hideclasshall = {
	type="checkbox",
	value=false,
	label="Hide Class Hall Button",
	callback = function() bdCore:triggerEvent('bd_mm_reconfig') end
}}

bdConfigLib:RegisterModule({
	name = "Minimap"
}, defaults, BD_persistent)