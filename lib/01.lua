Dial_Start = 50
Rotations = {}

do
    local input = io.open("data/01.txt", "r"):read("*a")
    for dir, amount in string.gmatch(input, "([LR])(%d+)\n") do
        amount = tonumber(amount)
        if dir == "L" then amount = amount * -1 end
        table.insert(Rotations, amount)
    end
end

do
    local part1 = 0
    local part2 = 0

    local dial_num = Dial_Start
    for _i, rotation in ipairs(Rotations) do
        while rotation ~= 0 do
            if rotation > 0 then
                rotation = rotation - 1
                dial_num = dial_num + 1
                if dial_num == 100 then dial_num = 0 end
            elseif rotation < 0 then
                rotation = rotation + 1
                dial_num = dial_num - 1
                if dial_num == -1 then dial_num = 99 end
            end

            if dial_num == 0 then
                part2 = part2 + 1
            end
        end

        if dial_num == 0 then part1 = part1 + 1 end
    end

    print("Part 1:", part1)
    print("Part 2:", part2)
end
