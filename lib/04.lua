Rolls = {}

function Hash(pos)
    return pos.y * 100000 + pos.x
end

do
    local x, y = 1, 1
    local input = io.open("data/04.txt", "r"):read("*a")
    for char in string.gmatch(input, ".") do
        if char == "@" then
            local pos = { x = x, y = y }
            Rolls[Hash(pos)] = pos
        elseif char == "\n" then
            x, y = 0, y + 1
        end
        x = x + 1
    end
end

function Is_Reachable(roll)
    local adjacent = 0
    for _i, delta in ipairs({
        { x = -1, y = -1 }, { x = 0, y = -1 }, { x = 1, y = -1 },
        { x = -1, y = 0 }, { x = 1, y = 0 },
        { x = -1, y = 1 }, { x = 0, y = 1 }, { x = 1, y = 1 },
    }) do
        if Rolls[Hash({ x = roll.x + delta.x, y = roll.y + delta.y })] ~= nil then
            adjacent = adjacent + 1
            if adjacent >= 4 then return false end
        end
    end
    return true
end

do
    local part1 = 0
    local part2 = 0

    while true do
        local to_remove = {}
        local any_removed = false
        for _, roll in pairs(Rolls) do
            if Is_Reachable(roll) then
                part2 = part2 + 1
                to_remove[Hash(roll)] = true
                any_removed = true
            end
        end
        if part1 == 0 then part1 = part2 end
        for key, _ in pairs(to_remove) do
            Rolls[key] = nil
        end
        if not any_removed then
            break
        end
    end
    print("Part 1:", part1)
    print("Part 2:", part2)
end
