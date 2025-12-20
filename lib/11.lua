Connections = {}

do
    for line in io.lines("data/11.txt") do
        for input, outputs in string.gmatch(line, "(.+): (.+)") do
            local connection = {}
            for output in string.gmatch(outputs, "([^%s]+)%s?") do
                table.insert(connection, output)
            end
            Connections[input] = connection
        end
    end
end

Found_Paths = {}
function Get_Num_Paths(start, stop)
    local mem = (Found_Paths[start] or {})[stop]
    if mem ~= nil then return mem end

    if start == stop then return 1 end

    local paths = 0
    local next_connections = Connections[start]
    if next_connections ~= nil then
        for _, next in pairs(next_connections) do
            paths = paths + Get_Num_Paths(next, stop)
        end
    end

    if Found_Paths[start] == nil then Found_Paths[start] = {} end
    Found_Paths[start][stop] = paths
    return paths
end

do
    print("Part 1:", Get_Num_Paths("you", "out"))

    local p2a, p2b, p2c = Get_Num_Paths("svr", "fft"), Get_Num_Paths("fft", "dac"), Get_Num_Paths("dac", "out")
    local p2d, p2e, p2f = Get_Num_Paths("svr", "dac"), Get_Num_Paths("dac", "fft"), Get_Num_Paths("fft", "out")
    local part2 = (p2a * p2b * p2c) + (p2d * p2e * p2f)
    print("Part 2:", string.format("%d", part2))
end
