require("tests/mock/finally")

function ctf.init() end
function ctf.clean_player_lists() end


local default_setting = {
    ["diplomacy"] = true,
    ["players_can_change_team"] = true,
    ["allocate_mode"] = 0,
    ["maximum_in_team"] = -1,
    ["default_diplo_state"] = "war",
    ["hud"] = true,
    ["autoalloc_on_joinplayer"] = true,
    ["friendly_fire"] = true,
}

function ctf.setting(name) return default_setting[name] end

function ctf.register_on_load(func)
    func({["teams"] = {}, ["players"] = {}})
end

function ctf.register_on_save(func)
    finally.register_on_init(func)
end

function ctf.register_on_init(func)
    finally.register_on_init(func)
end

function ctf.register_on_new_team(func)
    finally.register_on_init(func)
end

function ctf.register_on_territory_query(func)
    finally.register_on_init(func)
end

function ctf.register_on_new_game(func)
    finally.register_on_init(func)
end
