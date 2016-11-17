function assert_tables_equal(expected, actual)
    for key,value in pairs(expected) do
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


describe("tests orderPairs", function()
    setup(function()
        require("ctf/tests/mock/minetest")
        require("ctf/tests/mock/vector")
        _G.ctf = {}
        require("ctf/core")
    end)

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

        it("modify check", function()
            local tbl = {a = 0,d = 1,x = 2}
            local nextFx,t,index = orderedPairs(tbl)
            tbl.a = 10
            tbl.d = 11
            tbl.x = 12

            local sum = 0
            for k,v in nextFx,t,index do
                sum = sum + v
            end
            assert.equal(3, sum)
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

    it("error on uninitiated pairs", function()
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


