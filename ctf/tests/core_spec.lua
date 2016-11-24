package.path = '../../?.lua;' .. -- tests root
               '../?.lua;' .. -- mod root
                package.path

function assert_tables_equal(expected, actual)
    for key, value in pairs(expected) do
        assert.equal(expected[key], actual[key])
    end
    for key, value in pairs(actual) do
        assert.equal(expected[key], actual[key])
    end
end

function assert_keysets_are_equal(sample, actual)
    for key in pairs(sample) do
        assert.not_nil(actual[key])
    end
    for key in pairs(actual) do
        assert.not_nil(sample[key])
    end
end

describe("core tests:", function()
    setup(function()
        require("tests/mock/finally")
        require("tests/mock/minetest/init")
        require("tests/mock/vector")
        require("tests/mock/ctf/init")

        require('ctf/core')

        -- slient print from code
        original_print = print
        _G.print = function()end
    end)

    teardown(function()
        finally.run()

        -- restore print
        _G.print = original_print
    end)

    describe("orderPairs", function()
        it("next function", function()
            local tbl = {}
            tbl.b = 0
            tbl.a = 1
            tbl.c = 2
            local nextFx, t, index = orderedPairs(tbl)
            assert.equal("a", nextFx(t, index))
            assert.equal("b", nextFx(t, "a"))
            assert.equal("c", nextFx(t, "b"))
            assert.is_nil(nextFx(t, "c"))
        end)

        it("return nil on empty table", function()
            local tbl = {}
            local nextFx, t, index = orderedPairs(tbl)
            assert.is_nil(nextFx(t, index))
        end)

        describe('iterate', function()
            it("keys in order", function()
                local tbl = {}
                tbl.c = 0
                tbl.a = 1
                tbl.b = 2
                tbl.z = 9
                tbl.o = 4

                local result = ""
                for k,v in orderedPairs(tbl) do
                    result = result .. "(" .. k .. ";" .. v .. ")"
                end
                assert.equal('(a;1)(b;2)(c;0)(o;4)(z;9)', result)
            end)

            it("table reference", function()
                local tbl = {a = 0,d = 1,x = 2}
                local nextFx,t,index = orderedPairs(tbl)

                local result = ""
                for k,v in nextFx,t,index do
                    result = result .. "(" .. k .. ";" .. v .. ")"
                end
                assert.equal('(a;0)(d;1)(x;2)', result)
            end)

            it("allow modify check", function()
                local tbl = {a = 0,d = 1,x = 2}
                local nextFx,t,index = orderedPairs(tbl)
                tbl.a = 10
                tbl.d = 11
                tbl.x = 12

                local sum = 0
                for k,v in nextFx,t,index do
                    sum = sum + v
                end
                assert.equal(33, sum)
            end)
        end)

        it("index and cleanup", function()
            local tbl = {}
            tbl.a = 0
            tbl.c = 1
            tbl.b = 2
            local nextFx, t, index = orderedPairs(tbl)
            local temp = nextFx(t,index)
            assert_keysets_are_equal({a=0,c=0,b=0,__orderedIndex={}},t)
            temp = nextFx(t,temp)
            temp = nextFx(t,temp)
            nextFx(t,temp)
            assert_keysets_are_equal({a=0,c=0,b=0},t)
        end)

        it("access using state on new pairs", function()
            local tbl = {}
            tbl.b = 0
            tbl.a = 1
            tbl.c = 2
            local nextFx, t, index = orderedPairs(tbl)
            assert.error(function()
                nextFx(t, "b")
            end)
        end)
    end)

    describe("vector", function()
        it("distanceSQ", function()
            assert.equal(61, vector.distanceSQ({x = 42, y = 54, z = 47}, {x = 45, y = 50, z = 53}))
            assert.equal(3, vector.distanceSQ({x=0,y=0,z=0},{x=1,y=1,z=1}))
            assert.equal(3, vector.distanceSQ({x=1,y=1,z=1},{x=0,y=0,z=0}))
            assert.equal(3, vector.distanceSQ({x=1,y=0,z=1},{x=0,y=1,z=0}))
            assert.equal(3, vector.distanceSQ({x=0,y=1,z=0},{x=1,y=0,z=1}))
        end)
    end)

    describe("register function:", function()
        function dummy() end

        it('on load', function()
            ctf.register_on_load(dummy)
        end)

        it('on save', function()
            ctf.register_on_save(dummy)
        end)

        it('on init', function()
            ctf.register_on_init(dummy)
        end)

        it('on new team', function()
            ctf.register_on_new_team(dummy)
        end)

        it('on territory query', function()
            ctf.register_on_territory_query(dummy)
        end)

        it('on new game', function()
            ctf.register_on_new_game(dummy)
        end)
    end)

    describe("core function:", function()
        it("init", function()
            ctf.init()
        end)

        it("load without ctf exists", function()
            if io.open(minetest.get_worldpath().."/ctf.txt", "r") then
                os.remove(minetest.get_worldpath().."/ctf.txt")
            end
            file = io.open(minetest.get_worldpath().."/ctf.txt", "r")
            assert.is_nil(file)
            ctf.load()
        end)

        it("save", function()
            ctf.save()
        end)

        it("load with ctf exists", function()
            if not io.open(minetest.get_worldpath().."/ctf.txt", "r") then
                ctf.save()
            end
            file = io.open(minetest.get_worldpath().."/ctf.txt", "r")
            assert.is_not_nil(file)
            file:close()
            ctf.load()
        end)

        it("postinit on_load", function()
            if not io.open(minetest.get_worldpath().."/ctf.txt", "r") then
                ctf.save()
            end
            file = io.open(minetest.get_worldpath().."/ctf.txt", "r")
            assert.is_not_nil(file)
            file:close()
            ctf.register_on_load(function(loaddata)
                preinit_table=loaddata
            end)
            ctf.init()
            ctf.register_on_load(function(loaddata)
                postinit_table=loaddata
            end)
            assert.is_not_nil(preinit_table)
            assert.is_not_nil(postinit_table)
            assert_tables_equal(preinit_table, postinit_table)
        end)

        it("reset", function()
            if not io.open(minetest.get_worldpath().."/ctf.txt", "r") then
                ctf.save()
            end
            file = io.open(minetest.get_worldpath().."/ctf.txt", "r")
            assert.is_not_nil(file)
            file:close()
            ctf.reset()
            file = io.open(minetest.get_worldpath().."/ctf.txt", "r")
            assert.is_nil(file)
        end)

        it("setting", function()
            ctf.init()
            ctf.setting("diplomacy")
        end)
    end)

    describe("print function (coverage):", function()
        it("error", function()
            ctf.error('test','test')
        end)

        it("log", function()
            ctf.log('test','test')
            ctf.log(nil,'test')
        end)

        it("action", function()
            ctf.action('test','test')
            ctf.action(nil,'test')
        end)

        it("warning", function()
            ctf.warning('test','test')
        end)
    end)
end)

