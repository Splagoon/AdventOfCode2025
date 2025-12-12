Machines = {}

do
    for line in io.lines("data/10.txt") do
        for indicators, buttons, joltages in string.gmatch(line, "%[(.+)%] ([^%%]+) {([^}]+)}") do
            local machine = { indicators = {}, buttons = {}, joltages = {} }

            for indicator in string.gmatch(indicators, ".") do
                if indicator == "#" then
                    table.insert(machine.indicators, true)
                else
                    table.insert(machine.indicators, false)
                end
            end

            for button_str in string.gmatch(buttons, "%(([^%)]+)%)") do
                local button = {}
                for num in string.gmatch(button_str, "(%d+),?") do
                    table.insert(button, tonumber(num))
                end
                table.insert(machine.buttons, button)
            end

            for joltage in string.gmatch(joltages, "(%d+),?") do
                table.insert(machine.joltages, tonumber(joltage))
            end

            table.insert(Machines, machine)
        end
    end
end

function table.copy(t)
    local res = {}
    for k, v in pairs(t) do
        res[k] = v
    end
    return res
end

function table.contains(t, v)
    for _, val in pairs(t) do
        if val == v then return true end
    end
    return false
end

function Tables_Match(a, b)
    if #a ~= #b then return false end

    for i = 1, #a do
        if a[i] ~= b[i] then return false end
    end

    return true
end

KeyedByValueMetatable = {
    __index = function(t, k)
        for key, value in pairs(t) do
            if Tables_Match(key, k) then return value end
        end
        return nil
    end
}

function Press_Buttons_Indicators(machine, presses)
    local indicators = {}
    for i = 1, #machine.indicators do
        indicators[i] = false
    end

    for b, n in pairs(presses) do
        if n % 2 == 1 then
            for _, i in pairs(machine.buttons[b]) do
                indicators[i + 1] = not indicators[i + 1]
            end
        end
    end
    return indicators
end

function Press_Buttons_Joltages(machine, presses)
    local joltages = {}
    for i = 1, #machine.joltages do
        joltages[i] = 0
    end

    for b, n in pairs(presses) do
        for _, i in pairs(machine.buttons[b]) do
            joltages[i + 1] = joltages[i + 1] + n
        end
    end
    return joltages
end

function Length(seq)
    local res = 0
    for i = 1, #seq do
        if seq[i] > 0 then res = res + 1 end
    end
    return res
end

function Hash(seq)
    local res = 0
    for i = 1, #seq do
        res = res + seq[i] * 10 ^ i
    end
    return res
end

function Generate_Combinations(n)
    local res = { { 0 }, { 1 } }

    for i = 2, n do
        for j = 1, #res do
            local new = table.copy(res[j])
            table.insert(res[j], 0)
            table.insert(new, 1)
            table.insert(res, new)
        end
    end

    return res
end

function Turn_On(machine)
    local candidates = Generate_Combinations(#machine.buttons)

    local best_found = nil
    for _, candidate in pairs(candidates) do
        local candidate_len = Length(candidate)
        if best_found == nil or candidate_len < best_found then
            local res = Press_Buttons_Indicators(machine, candidate)
            if Tables_Match(machine.indicators, res) then
                best_found = candidate_len
            end
        end
    end
    return best_found
end

function Joltages_Count(machine, buttons_to_press)
    local res = {}
    for i = 1, #machine.joltages do
        local count = 0
        for j, button in pairs(machine.buttons) do
            if buttons_to_press[j] == 1 and table.contains(button, i - 1) then
                count = count + 1
            end
        end
        table.insert(res, count)
    end
    return res
end

function Joltages_Parity(joltages)
    local res = {}
    for i, j in pairs(joltages) do
        res[i] = j % 2
    end
    return res
end

-- No I didn't come up with this myself
-- https://www.reddit.com/r/adventofcode/comments/1pk87hl/comment/ntlfais/
function Set_Joltages(machine)
    local parities = {}
    local values = {}
    setmetatable(parities, KeyedByValueMetatable)
    setmetatable(values, KeyedByValueMetatable)

    for _, buttons_to_press in pairs(Generate_Combinations(#machine.buttons)) do
        local joltages_count = Joltages_Count(machine, buttons_to_press)
        local joltages_parity = Joltages_Parity(joltages_count)
        local p = parities[joltages_parity]
        if p == nil then
            parities[joltages_parity] = { buttons_to_press }
        else
            table.insert(p, buttons_to_press)
        end
        values[buttons_to_press] = joltages_count
    end

    local function min_presses(joltages)
        local all_zero = true
        for _, j in pairs(joltages) do
            if j ~= 0 then all_zero = false end
            if j < 0 then return 9999999 end
        end
        if all_zero then return 0 end
        local output = 9999999
        local joltages_parity = Joltages_Parity(joltages)
        for _, buttons_to_press in pairs(parities[joltages_parity] or {}) do
            local joltage_drops = values[buttons_to_press]
            local next_joltages = {}
            for i = 1, #joltages do
                next_joltages[i] = (joltages[i] - joltage_drops[i]) / 2
            end
            output = math.min(output, Length(buttons_to_press) + 2 * min_presses(next_joltages))
        end
        return output
    end
    return min_presses(machine.joltages)
end

do
    local part1 = 0
    local part2 = 0
    for i, machine in pairs(Machines) do
        local iseq = Turn_On(machine)
        part1 = part1 + iseq
        local jseq = Set_Joltages(machine)
        print(string.format("Machine %d: %d", i, jseq))
        part2 = part2 + jseq
    end
    print("Part 1:", part1)
    print("Part 2:", part2)
end
