Presents = {}
Trees = {}

do
    local input = io.open("data/12.txt", "r"):read("*a")
    for present_inputs, tree_inputs in string.gmatch(input, "([^x]+\n)(%d+x.+)") do
        for present_index, present_layout in string.gmatch(present_inputs, "(%d+):\n([#.\n]+)") do
            local x, y, present = 1, 1, { w = 0, h = 0, layout = {} }
            for c in string.gmatch(present_layout, ".") do
                if c == "\n" then
                    if present.w == 0 then present.w = x - 1 end
                    x = 1
                    y = y + 1
                else
                    if c == "#" then
                        table.insert(present.layout, { x = x, y = y })
                    end
                    x = x + 1
                end
            end
            present.h = y - 2
            Presents[tonumber(present_index)] = present
        end

        for tree_w, tree_h, presents in string.gmatch(tree_inputs, "(%d+)x(%d+): ([^\n]+)\n") do
            local tree = { w = tonumber(tree_w), h = tonumber(tree_h), presents = {} }
            for present_index in string.gmatch(presents, "(%d+) ?") do
                table.insert(tree.presents, tonumber(present_index))
            end
            table.insert(Trees, tree)
        end
    end
end

function Sum_Areas(present_indexes)
    local res = 0
    for _, p in pairs(present_indexes) do
        res = res + #Presents[p].layout
    end
    return res
end

function Expand_Present_Indexes(presents)
    local res = {}
    for i, n in pairs(presents) do
        for _ = 1, n do
            table.insert(res, i - 1)
        end
    end
    return res
end

function Can_Fit_Presents(tree)
    local expanded_indexes = Expand_Present_Indexes(tree.presents)
    -- Yes this is as naive as it looks
    return Sum_Areas(expanded_indexes) < tree.w * tree.h * 0.9
end

do
    local part1 = 0
    for i, tree in pairs(Trees) do
        if Can_Fit_Presents(tree) then part1 = part1 + 1 end
    end
    print("Part 1:", part1)
end
