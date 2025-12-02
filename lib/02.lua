Ranges = {}

do
    local input = io.open("data/02.txt", "r"):read("*a")
    for range_start, range_end in string.gmatch(input, "(%d+)-(%d+)[,\n]") do
        table.insert(Ranges, { range_start = tonumber(range_start), range_end = tonumber(range_end) })
    end
end

function Check_Pattern(str, n)
    if string.len(str) % n > 0 then
        return true
    end

    local chunk_size = string.len(str) / n
    local first_chunk = string.sub(str, 1, chunk_size)
    for i = 1, n - 1 do
        local nth_start = chunk_size * i
        local nth_chunk = string.sub(str, nth_start + 1, nth_start + chunk_size)
        if first_chunk ~= nth_chunk then return true end
    end

    return false
end

function Check_Id1(id)
    return Check_Pattern(tostring(id), 2)
end

function Check_Id2(id)
    local str_id = tostring(id)
    for i = 2, string.len(str_id) do
        if not Check_Pattern(str_id, i) then return false end
    end
    return true
end

do
    local part1 = 0
    local part2 = 0
    for _i, range in ipairs(Ranges) do
        local id = range.range_start
        while id <= range.range_end do
            if not Check_Id1(id) then
                part1 = part1 + id
            end
            if not Check_Id2(id) then
                part2 = part2 + id
            end
            id = id + 1
        end
    end
    print("Part 1:", part1)
    print("Part 2:", part2)
end
