Problems1 = {}
Problems2 = {}

function Pivot_Table(t)
    local r = {}
    for _, row in pairs(t) do
        for x, column in pairs(row) do
            local new_row = r[x]
            if new_row == nil then
                new_row = {}
                r[x] = new_row
            end

            table.insert(new_row, column)
        end
    end
    return r
end

function Trim_Number(str)
    for n in string.gmatch(str, "%s*(%d+)%s*") do
        return tonumber(n)
    end
end

function Str_Explode(str)
    local res = {}
    for c in string.gmatch(str, ".") do
        table.insert(res, c)
    end
    return res
end

function Str_Unexplode(t)
    local res = ""
    for _, c in pairs(t) do
        res = res .. c
    end
    return res
end

do
    local raw_problems = {}
    local raw_lines = {}
    for line in io.lines("data/06.txt", "*L") do
        table.insert(raw_lines, line)
    end

    -- Last line will tell us the column widths
    local column_widths = {}
    do
        local column_i = 1
        for padding in string.gmatch(raw_lines[#raw_lines], "[*+]([%s\n]+)") do
            column_widths[column_i] = string.len(padding)
            column_i = column_i + 1
        end
    end

    for _, line in pairs(raw_lines) do
        local row = {}
        local i = 1
        for _, column_width in pairs(column_widths) do
            table.insert(row, string.sub(line, i, i + column_width - 1))
            i = i + column_width + 1
        end
        table.insert(raw_problems, row)
    end

    -- Pivot the table
    local problems = Pivot_Table(raw_problems)

    -- Part 1
    for y = 1, #problems do
        local new_row = {}
        for x = 1, #problems[y] - 1 do
            new_row[x] = Trim_Number(problems[y][x])
        end
        new_row[#problems[y]] = problems[y][#problems[y]]
        Problems1[y] = new_row
    end

    -- Part 2
    for y = 1, #problems do
        local numbers = {}
        for x = 1, #problems[y] - 1 do
            numbers[x] = Str_Explode(problems[y][x])
        end
        local new_numbers = Pivot_Table(numbers)
        local new_row = {}
        for i, n in pairs(new_numbers) do
            new_row[i] = Trim_Number(Str_Unexplode(n))
        end
        new_row[#new_row + 1] = problems[y][#problems[y]]
        Problems2[y] = new_row
    end
end

function Solve_Problem(problem)
    local operator = string.sub(problem[#problem], 1, 1)
    local solution = problem[1]
    for i = 2, #problem - 1 do
        if operator == "+" then
            solution = solution + problem[i]
        elseif operator == "*" then
            solution = solution * problem[i]
        end
    end
    return solution
end

do
    local part1 = 0
    for _, problem in pairs(Problems1) do
        part1 = part1 + Solve_Problem(problem)
    end
    print("Part 1:", part1)

    local part2 = 0
    for _, problem in pairs(Problems2) do
        part2 = part2 + Solve_Problem(problem)
    end
    print("Part 2:", part2)
end
