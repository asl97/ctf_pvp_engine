minetest = {}

after_ran = {}
function minetest.after(val, func)
    if after_ran[func] == nil then
        after_ran[func] = true
        func()
    end
end

return minetest
