local load_time_start = os.clock()
local RANGE = 0.6

minetest.register_node("trashcan:trashcan", {
	description = "Trash can",
	tiles = {"default_steel_block.png","default_steel_block.png","trashcan.png"},
	groups = {snappy=1,bendy=2,cracky=1},
	sounds = default.node_sound_stone_defaults(),
	paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
		},
	},
	on_punch = function(pos, node, puncher)
		if node.name == "trashcan:trashcan" then --why should this be checked???
			local objs = minetest.env:get_objects_inside_radius({x=pos.x, y=pos.y+0.3, z=pos.z}, RANGE)
			minetest.chat_send_player(puncher:get_player_name(), 'Garbage removed!')
			for _, obj in pairs(objs) do
				obj:remove()
				minetest.sound_play("trashcan", {pos = pos, gain = 1.0, max_hear_distance = 10})
			end
			print("[trashcan] someone used a trashcan at ("..pos.x..", "..pos.y..", "..pos.z..")")
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext","Trash can")
	end,
})

minetest.register_craft({
	output = 'trashcan:trashcan',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

print(string.format("[trashcan] loaded after ca. %.2fs", os.clock() - load_time_start))
