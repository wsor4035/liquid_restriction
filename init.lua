--registering priv
minetest.register_privilege("spill", {description = "Able to use all liquids.", give_to_singleplayer=false})

--list of all liquid nodes, feel free to add your own
local liquid_list = {
    "default:water_source",
    "default:river_water_source",
    "default:lava_source",
}

--list of liquid nodes in buckets, feel free to add your own
local liquid_bucket_list = {
    "bucket:bucket_lava",
    "bucket:bucket_water",
    "bucket:bucket_river_water",
}

--reads list, overrides nodes, adding priv check
for liquidcount = 1, #liquid_list do
    minetest.override_item(liquid_list[liquidcount], {
        on_place = function(itemstack, placer, pointed_thing)
            if not minetest.check_player_privs(placer:get_player_name(), {spill = true}) then
                minetest.chat_send_player(placer:get_player_name(), "Spill priv required to use this node")
                return
            else
                return minetest.item_place(itemstack, placer, pointed_thing)
            end
        end
	})
end

--reads list, overrides nodes, adding priv check
for liquidbucketcount = 1, #liquid_bucket_list do
    minetest.override_item(liquid_bucket_list[liquidbucketcount], {
        on_place = function(itemstack, placer, pointed_thing)
            if not minetest.check_player_privs(placer:get_player_name(), {spill = true}) then
                minetest.chat_send_player(placer:get_player_name(), "Spill priv required to use this node")
                return itemstack
            else
                return minetest.item_place(itemstack, placer, pointed_thing)
            end
        end
    })
end
