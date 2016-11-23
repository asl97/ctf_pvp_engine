package.path = '../../?.lua;' .. -- tests root
               '../?.lua;' .. -- mod root
                package.path

describe('init coverage', function()
    setup(function()
        require("tests/mock/finally")
        require("tests/mock/minetest/init")
    end)

    teardown(function()
        finally.run()
    end)

    it('load init', function()
        require("ctf/init")
    end)

    it('check overriden minetest.chat_send_all', function()
        minetest.chat_send_all('test')
    end)
end)
