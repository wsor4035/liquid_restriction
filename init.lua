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
    --technic cans
    "technic:lava_can",
    "technic:water_can",
    --buckets
    "bucket:bucket_lava",
    "bucket:bucket_water",
    "bucket:bucket_river_water",
    --bucket_wooden
    "bucket_wooden:bucket_water",
    "bucket_wooden:bucket_river_water",
}

--settings
local lr_height = tonumber(minetest.settings:get("lr_height")) or 30
local lr_renew = minetest.settings:get_bool("lr_renew", false)

--function for handling priv settings
local function priv_selection(default_priv, setting)
    local priv = minetest.settings:get(setting)

    if not minetest.registered_privileges[priv] then
        return default_priv
    else
        return priv
    end
end

--reads list, overrides nodes, adding priv check
for liquidcount = 1, #liquid_list do
    --checks if its a valid node/item
    if minetest.registered_items[liquid_list[liquidcount]] then
        --get old on_place behavior
        local old_place = minetest.registered_items[liquid_list[liquidcount]].on_place or function() end

        --override
        minetest.override_item(liquid_list[liquidcount], {
            on_place = function(itemstack, placer, pointed_thing)
                local pname = placer:get_player_name()
                local default_priv = priv_selection("spill", "lr_default")
                local advanced_priv = priv_selection("server", "lr_advanced")

                if not minetest.check_player_privs(pname, priv_selection(default_priv, "lr_default")) then
                    minetest.chat_send_player(pname, default_priv .. " priv required to use this node")
                    return
                else
                    if (minetest.get_pointed_thing_position(pointed_thing).y > lr_height) then
                        if not (minetest.check_player_privs(pname, priv_selection("server", "lr_advanced"))) then
                            minetest.chat_send_player(pname, advanced_priv .. " priv requid at this height")
                            return
                        end
                    end
                    return old_place(itemstack, placer, pointed_thing)
                end
            end,
            --prevents liquids from spreading
            liquid_renewable = lr_renew,
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