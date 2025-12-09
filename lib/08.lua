Junctions = {}
Junction_Pairs = {}
Circuits = {}
Num_Connections = 1000

function Are_Junctions_In_Order(a, b)
    if a.x < b.x then
        return true
    elseif a.x > b.x then
        return false
    end

    if a.y < b.y then
        return true
    elseif a.y > b.y then
        return false
    end

    if a.z < b.z then
        return true
    else
        return false
    end
end

function Distance_Squared(a, b)
    return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 + (a.z - b.z) ^ 2
end

function Get_Circuit_For_Junction(j)
    for i, circuit in pairs(Circuits) do
        for _, j2 in pairs(circuit) do
            if j2 == j then
                return i, circuit
            end
        end
    end
end

do
    local junctions = {}
    for line in io.lines("data/08.txt") do
        for x, y, z in string.gmatch(line, "(%d+),(%d+),(%d+)") do
            local junction = {
                x = tonumber(x), y = tonumber(y), z = tonumber(z)
            }
            table.insert(junctions, junction)
            table.insert(Circuits, { junction })
        end
    end

    for i1, junction1 in pairs(junctions) do
        for i2, junction2 in pairs(junctions) do
            if i1 ~= i2 and Are_Junctions_In_Order(junction1, junction2) then
                table.insert(Junction_Pairs, { a = junction1, b = junction2 })
            end
        end
    end

    table.sort(Junction_Pairs, function(a, b)
        return Distance_Squared(a.a, a.b) < Distance_Squared(b.a, b.b)
    end)
end

function Print_Part1()
    table.sort(Circuits, function(a, b)
        return #a > #b
    end)
    print("Part 1:", #Circuits[1] * #Circuits[2] * #Circuits[3])
end

for _, pair in pairs(Junction_Pairs) do
    local _, circuit_a = Get_Circuit_For_Junction(pair.a)
    local cb, circuit_b = Get_Circuit_For_Junction(pair.b)
    if circuit_a ~= circuit_b then
        for _, junction in pairs(circuit_b) do
            table.insert(circuit_a, junction)
        end
        table.remove(Circuits, cb)
    end

    Num_Connections = Num_Connections - 1
    if Num_Connections == 0 then
        Print_Part1()
    end

    if #Circuits == 1 then
        print("Part 2:", pair.a.x * pair.b.x)
        break
    end
end
