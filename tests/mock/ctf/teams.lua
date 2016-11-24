teams = {}

function ctf.team(name)
    if teams[name] then
        return teams[name]
    end
    t = {}
    t.log = {}
    sample = {["team"] = "A",
              ["type"] = "request",
              ["mode"] = "diplo",
              ["msg"] = "test",
    }
    table.insert(t.log, sample)
    teams[name] = t
    return t
end

