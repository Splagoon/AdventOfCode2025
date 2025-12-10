Corners = {}

do
    for line in io.lines("data/09.txt") do
        for x, y in string.gmatch(line, "(%d+),(%d+)") do
            local corner = { x = tonumber(x), y = tonumber(y) }
            table.insert(Corners, corner)
        end
    end
end

function Line_Intersects_Polygon(line_start, line_end)
    if line_end.x < line_start.x or line_end.y < line_start.y then
        line_start, line_end = line_end, line_start
    end

    for i = 1, #Corners do
        local c1 = Corners[i]
        local c2 = Corners[(i % #Corners) + 1]

        if c2.x < c1.x or c2.y < c1.y then
            c1, c2 = c2, c1
        end

        -- Vertical
        if c1.x == c2.x then
            -- Horizontal
            if line_start.y == line_end.y then
                if line_start.x <= c1.x and line_end.x >= c1.x and line_start.y >= c1.y and line_start.y <= c2.y then
                    return true
                end
            end
        end

        -- Horizontal
        if c1.y == c2.y then
            -- Vertical
            if line_start.x == line_end.x then
                if line_start.y <= c1.y and line_end.y >= c1.y and line_start.x >= c1.x and line_start.x <= c2.x then
                    return true
                end
            end
        end
    end

    return false
end

function Is_Valid_Rect(c1, c2)
    local min = { x = math.min(c1.x, c2.x), y = math.min(c1.y, c2.y) }
    local max = { x = math.max(c1.x, c2.x), y = math.max(c1.y, c2.y) }

    local n1, n2 = { x = min.x + 1, y = min.y + 1 }, { x = max.x - 1, y = min.y + 1 }
    local s1, s2 = { x = min.x + 1, y = max.y - 1 }, { x = max.x - 1, y = max.y - 1 }
    local w1, w2 = { x = min.x + 1, y = min.y + 1 }, { x = min.x + 1, y = max.y - 1 }
    local e1, e2 = { x = max.x - 1, y = min.y + 1 }, { x = max.x - 1, y = max.y - 1 }

    return not (
        Line_Intersects_Polygon(n1, n2) or
        Line_Intersects_Polygon(s1, s2) or
        Line_Intersects_Polygon(w1, w2) or
        Line_Intersects_Polygon(e1, e2)
    )
end

do
    print("Checking rectangles...")
    local part1 = 0
    local part2 = 0
    local total = (#Corners) ^ 2
    local current = 0
    for _, corner1 in pairs(Corners) do
        for _, corner2 in pairs(Corners) do
            current = current + 1
            if current % 10000 == 0 then
                print(string.format("Progress: %.2f%%", current / total * 100))
            end
            local width = math.abs(corner1.x - corner2.x) + 1
            local height = math.abs(corner1.y - corner2.y) + 1
            local area = width * height

            if area > part1 then part1 = area end

            if area > part2 and Is_Valid_Rect(corner1, corner2) then
                part2 = area
            end
        end
    end

    print("Part 1:", part1)
    print("Part 2:", part2)
end
