Banks = {}

do
    for line in io.lines("data/03.txt") do
        local bank = {}
        for char in string.gmatch(line, "%d") do
            table.insert(bank, tonumber(char))
        end
        table.insert(Banks, bank)
    end
end

function Seek_Best(bank, start_idx, end_idx)
    local best = 0
    for i = start_idx, end_idx do
        if best < 1 or bank[i] > bank[best] then
            best = i
        end
    end
    return best
end

function Best_Joltage(bank, num_batteries)
    local best_found = 0
    local search_start = 1
    local batteries_left = num_batteries

    for _battery = 1, num_batteries do
        local best_idx = Seek_Best(bank, search_start, #bank - batteries_left + 1)
        batteries_left = batteries_left - 1
        search_start = best_idx + 1
        best_found = best_found + bank[best_idx] * 10 ^ (batteries_left)
    end

    return best_found
end

-- Part 1
do
    local part1 = 0
    local part2 = 0
    for _i, bank in ipairs(Banks) do
        part1 = part1 + Best_Joltage(bank, 2)
        part2 = part2 + Best_Joltage(bank, 12)
    end
    print("Part 1:", part1)
    print("Part 2:", string.format("%d", part2))
end
