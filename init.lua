--registering priv
minetest.register_privilege("spill", {description = "Able to use all liquids.", give_to_singleplayer=false})

--list of all liquid nodes, feel free to add your own
local liquid_list = {
    --source and flowing liquids
    "default:water_source",
    "default:water_flowing",
    "default:river_water_source",
    "default:river_water_flowing",
    "default:lava_source",
    "default:lava_flowing",
    --buckets
    "bucket:bucket_lava",
    "bucket:bucket_water",
    "bucket:bucket_river_water",
}

--reads list, overrides nodes, adding priv check
for liquidcount = 1, #liquid_list do
    --checks if its a valid node/item
    if minetest.registered_items[liquid_list[liquidcount]] then
        --get old on_place behavior
        local old_place = minetest.registered_items[liquid_list[liquidcount]].on_place or function() end

        --override
        minetest.override_item(liquid_list[liquidcount], {
            on_place = function(itemstack, placer, pointed_thing)
                if not minetest.check_player_privs(placer:get_player_name(), {spill = true}) then
                    minetest.chat_send_player(placer:get_player_name(), "Spill priv required to use this node")
                    return
                else
                    if (minetest.get_pointed_thing_position(pointed_thing).y > 30) then
                        if not (minetest.check_player_privs(placer:get_player_name(), {server = true})) then
                            minetest.chat_send_player(placer:get_player_name(), "admins can only place at this height")
                            return
                        end
                    end
                    --return minetest.item_place(itemstack, placer, pointed_thing)
                    return old_place(itemstack, placer, pointed_thing)
                end
            end,
            --prevents liquids from spreading
            liquid_renewable = false,
        })
    end
end

--disables water from being used with the replacer tool, as that bypasses the spill priv
if minetest.get_modpath("replacer") then
    replacer.blacklist["default:water_source"] = true;
    replacer.blacklist["default:water_flowing"] = true;
    replacer.blacklist["default:lava_source"] = true;
    replacer.blacklist["default:lava_flowing"] = true;
    replacer.blacklist["default:river_water_source"] = true;
    replacer.blacklist["default:river_water_flowing"] = true;
end