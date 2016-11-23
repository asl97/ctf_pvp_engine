--- Lua module to serialize values as Lua code.
-- From: https://github.com/fab13n/metalua/blob/no-dll/src/lib/serialize.lua
-- License: MIT
-- @copyright 2006-2997 Fabien Fleutot <metalua@gmail.com>
-- @author Fabien Fleutot <metalua@gmail.com>
-- @author ShadowNinja <shadowninja@minetest.net>

local env = {
	loadstring = loadstring,
}

local safe_env = {
	loadstring = function() end,
}

local function deserialize(str, safe)
	if str:byte(1) == 0x1B then
		return nil, "Bytecode prohibited"
	end
	local f, err = loadstring(str)
	if not f then return nil, err end
	setfenv(f, safe and safe_env or env)

	local good, data = pcall(f)
	if good then
		return data
	else
		return nil, data
	end
end

return deserialize
