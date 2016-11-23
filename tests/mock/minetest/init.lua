require('tests/mock/finally')

original_dofile = dofile
function _G.dofile(file)
    require('tests/mock/ctf'..file:match("(.-).[^%.]+$"))
end

minetest = {}

after_ran = {}
function minetest.after(val, func)
    finally.register_on_init(function()
        if after_ran[func] == nil then
            after_ran[func] = true
            func()
        end
    end)
end

minetest.deserialize = require('tests/mock/minetest/deserialize')

minetest.serialize = require('tests/mock/minetest/serialize')

function minetest.chat_send_all(msg) end

function minetest.chat_send_player(name, msg) end

function minetest.register_privilege(privs, definition) end

function minetest.get_modpath(name) return '.' end

function minetest.get_worldpath(name) return '.' end

function minetest.register_on_respawnplayer(func) finally.register_on_init(func) end

function minetest.register_on_newplayer(func) finally.register_on_init(func) end

function minetest.register_on_joinplayer(func) finally.register_on_init(func) end

function minetest.register_on_punchplayer(func) finally.register_on_init(func) end

function minetest.register_on_player_receive_fields(func) end

function minetest.setting_get(setting) end

function minetest.log(msg) end

return minetest
