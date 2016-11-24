package.path = '../../?.lua;' .. -- tests root
               '../?.lua;' .. -- mod root
                package.path

describe("diplomacy tests:", function()
    setup(function()
        require("tests/mock/ctf/init")
        require("tests/mock/ctf/core")
        require("ctf/diplomacy")
    end)

    teardown(function()
        finally.run()
    end)

    it("get default when diplo table is undefine", function()
        assert.equal("war", ctf.diplo.get("A", "B"))
    end)

    it("setting status", function()
        ctf.diplo.set("A", "B", "peace")
        assert.equal("peace", ctf.diplo.get("A", "B"))
    end)

    it("flip order get", function()
        assert.equal("peace", ctf.diplo.get("B", "A"))
    end)

    it("get default when diplo table is define", function()
        assert.equal("war", ctf.diplo.get("C", "D"))
    end)

    it("resetting status", function()
        ctf.diplo.set("A", "B", "war")
        assert.equal("war", ctf.diplo.get("A", "B"))
    end)

    it("flip order resetting status", function()
        ctf.diplo.set("B", "A", "peace")
        assert.equal("peace", ctf.diplo.get("B", "A"))
    end)

    describe("team:", function()
        setup(function()
            require("tests/mock/ctf/teams")
        end)

        it("check request", function()
            assert.equal("test", ctf.diplo.check_requests("A", "B"))
        end)

        it("cancel_requests", function()
            ctf.diplo.cancel_requests("A", "B")
            assert.equal(0, #ctf.team("B").log)
        end)
    end)

end)
