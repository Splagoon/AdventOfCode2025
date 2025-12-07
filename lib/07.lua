Manifold = {}
Max_X = 0
Max_Y = 0

Vector2 = {}
function Vector2.new(x, y)
    local vector2 = { x = x, y = y }
    vector2.offset = function(self, dx, dy)
        return Vector2.new(self.x + dx, self.y + dy)
    end
    return vector2
end

Manifold.mt = {}
function Manifold.mt.__index(obj, index)
    return rawget(obj, index.x + index.y * 100000) or 0
end

function Manifold.mt.__newindex(obj, index, value)
    rawset(obj, index.x + index.y * 100000, value)
end

setmetatable(Manifold, Manifold.mt)

do
    local y = 0
    for line in io.lines("data/07.txt") do
        y = y + 1
        local x = 0
        for char in string.gmatch(line, ".") do
            x = x + 1
            local pos = Vector2.new(x, y)
            if char == "S" then
                Manifold[pos] = 1
            elseif char == "^" then
                Manifold[pos] = -1
            end
        end
        Max_X = x
    end
    Max_Y = y
end

do
    local part1 = 0
    for y = 1, Max_Y - 1 do
        for x = 1, Max_X do
            local pos = Vector2.new(x, y)
            local next_pos = pos:offset(0, 1)
            local space = Manifold[pos]
            if space > 0 then
                if Manifold[next_pos] < 0 then
                    part1 = part1 + 1
                    local next_left = next_pos:offset(-1, 0)
                    local next_right = next_pos:offset(1, 0)
                    Manifold[next_left] = Manifold[next_left] + space
                    Manifold[next_right] = Manifold[next_right] + space
                else
                    Manifold[next_pos] = Manifold[next_pos] + space
                end
            end
        end
    end

    local part2 = 0
    for x = 1, Max_X do
        part2 = part2 + (Manifold[Vector2.new(x, Max_Y)] or 0)
    end

    print("Part 1:", part1)
    print("Part 2:", part2)
end
