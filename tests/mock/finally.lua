finally = {}

finally.registered_on_init = {}
function finally.register_on_init(func)
    table.insert(finally.registered_on_init, func)
end

function finally.run()
    for val, func in pairs(finally.registered_on_init) do
        func()
    end
    finally.registered_on_init = {}
end
