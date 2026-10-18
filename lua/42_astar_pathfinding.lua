-- 42_astar_pathfinding.lua - A* Grid Pathfinding with Heuristics in Lua

local function abs(x)
    return math.abs(x)
end

local function manhattan(a, b)
    return abs(a.x - b.x) + abs(a.y - b.y)
end

local function pointEquals(a, b)
    return a.x == b.x and a.y == b.y
end

local function pointKey(p)
    return p.y * 1000 + p.x
end

local function main()
    print("=== A* Grid Pathfinding ===")

    local w = 8
    local h = 8
    local grid = {
        "########",
        "#S.....#",
        "#.###..#",
        "#...#..#",
        "#...#..#",
        "#..##..#",
        "#.....E#",
        "########"
    }

    local start = { x = 1, y = 1 }
    local goal  = { x = 6, y = 6 }

    print("Source Grid:")
    for y = 1, h do
        print(grid[y])
    end
    print("")

    -- Open set of frontier nodes
    local openSet = {
        {
            pt = start,
            g = 0,
            h = manhattan(start, goal),
            f = manhattan(start, goal)
        }
    }

    local cameFrom = {}
    local gScore = {}
    local closedSet = {}

    gScore[pointKey(start)] = 0
    local found = false

    local dx = {  0,  0, -1, 1 }
    local dy = { -1,  1,  0, 0 }

    while #openSet > 0 do
        -- Find node in openSet with lowest f score (tie-break on lowest h)
        local bestIdx = 1
        for i = 2, #openSet do
            if openSet[i].f < openSet[bestIdx].f or
               (openSet[i].f == openSet[bestIdx].f and openSet[i].h < openSet[bestIdx].h) then
                bestIdx = i
            end
        end

        local current = openSet[bestIdx]

        if pointEquals(current.pt, goal) then
            found = true
            break
        end

        table.remove(openSet, bestIdx)
        closedSet[pointKey(current.pt)] = true

        -- Explore 4 neighbors
        for d = 1, 4 do
            local nx = current.pt.x + dx[d]
            local ny = current.pt.y + dy[d]

            -- Boundary checks (0-indexed coordinates match grid indices 1..w)
            if nx >= 0 and nx < w and ny >= 0 and ny < h then
                -- Obstacle check: Lua 1-based indexing
                local row = grid[ny + 1]
                local cell = row:sub(nx + 1, nx + 1)

                if cell ~= '#' then
                    local neighbor = { x = nx, y = ny }
                    local nKey = pointKey(neighbor)

                    if not closedSet[nKey] then
                        local tentativeG = current.g + 1

                        local isBetter = false
                        if gScore[nKey] == nil or tentativeG < gScore[nKey] then
                            isBetter = true
                        end

                        if isBetter then
                            cameFrom[nKey] = current.pt
                            gScore[nKey] = tentativeG
                            local hDist = manhattan(neighbor, goal)
                            local fTotal = tentativeG + hDist

                            local foundInOpen = false
                            for i = 1, #openSet do
                                if pointEquals(openSet[i].pt, neighbor) then
                                    openSet[i].g = tentativeG
                                    openSet[i].f = fTotal
                                    openSet[i].h = hDist
                                    foundInOpen = true
                                    break
                                end
                            end

                            if not foundInOpen then
                                table.insert(openSet, {
                                    pt = neighbor,
                                    g = tentativeG,
                                    h = hDist,
                                    f = fTotal
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    if not found then
        print("No path found to goal.")
        return
    end

    -- Reconstruct path
    local path = {}
    local curr = goal
    while not pointEquals(curr, start) do
        table.insert(path, curr)
        curr = cameFrom[pointKey(curr)]
    end
    table.insert(path, start)

    -- Reverse path so it goes from start to goal
    local reversed = {}
    for i = #path, 1, -1 do
        table.insert(reversed, path[i])
    end
    path = reversed

    print(string.format("A* Search: Path found! Length: %d steps\n", #path - 1))

    -- Render Solved Grid
    local isPath = {}
    for i = 2, #path - 1 do
        isPath[pointKey(path[i])] = true
    end

    print("Solved Grid:")
    for y = 0, h - 1 do
        local line = {}
        for x = 0, w - 1 do
            local p = { x = x, y = y }
            if isPath[pointKey(p)] then
                table.insert(line, "*")
            else
                table.insert(line, grid[y + 1]:sub(x + 1, x + 1))
            end
        end
        print(table.concat(line, ""))
    end

    print("")
    io.write("Path Coordinates:\n  ")
    for i = 1, #path do
        if i > 1 then
            io.write(" -> ")
        end
        io.write(string.format("(%d,%d)", path[i].x, path[i].y))
    end
    print("\n")
    print("Pathfinding completed successfully.")
end

main()
