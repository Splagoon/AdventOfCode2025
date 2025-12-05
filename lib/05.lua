Fresh_Ranges = {}
Ingredients = {}

do
    local reading_ingredients = false
    for line in io.lines("data/05.txt") do
        if line == "" then
            reading_ingredients = true
        elseif reading_ingredients then
            table.insert(Ingredients, tonumber(line))
        else
            for range_start, range_end in string.gmatch(line, "(%d+)-(%d+)") do
                table.insert(Fresh_Ranges, { range_start = tonumber(range_start), range_end = tonumber(range_end) })
            end
        end
    end
end

function Is_Fresh(ingredient)
    for _, range in pairs(Fresh_Ranges) do
        if ingredient >= range.range_start and ingredient <= range.range_end then
            return true
        end
    end
    return false
end

function Overlaps(range1, range2)
    if range1.range_start <= range2.range_start and range1.range_end >= range2.range_start then
        return true
    end

    if range1.range_start <= range2.range_end and range1.range_end >= range2.range_end then
        return true
    end

    return false
end

function Merge_Ranges()
    local any_merged = false

    repeat
        any_merged = false
        for k1, range1 in pairs(Fresh_Ranges) do
            for k2, range2 in pairs(Fresh_Ranges) do
                if k1 ~= k2 then
                    if Overlaps(range1, range2) or Overlaps(range2, range1) then
                        range1.range_start = math.min(range1.range_start, range2.range_start)
                        range1.range_end = math.max(range1.range_end, range2.range_end)
                        Fresh_Ranges[k2] = nil
                        any_merged = true
                    end
                end
            end
        end
    until any_merged == false
end

do
    Merge_Ranges()

    local part1 = 0
    for _, ingredient in pairs(Ingredients) do
        if Is_Fresh(ingredient) then
            part1 = part1 + 1
        end
    end

    local part2 = 0
    for _, range in pairs(Fresh_Ranges) do
        part2 = part2 + range.range_end - range.range_start + 1
    end

    print("Part 1:", part1)
    print("Part 2:", string.format("%d", part2))
end
