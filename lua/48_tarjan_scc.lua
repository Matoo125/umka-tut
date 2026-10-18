-- 48_tarjan_scc.lua - Tarjan's Strongly Connected Components (SCC) in Lua

local Graph = {}
Graph.__index = Graph

function Graph.new(n)
    local self = setmetatable({}, Graph)
    self.n = n
    self.adj = {}
    -- Vertices 0 to n-1 mapped to 1-based arrays: vertex i at index i + 1
    for i = 0, n - 1 do
        self.adj[i + 1] = {}
    end
    return self
end

function Graph:addEdge(u, v)
    table.insert(self.adj[u + 1], v)
end

local function min(a, b)
    return a < b and a or b
end

local function findSCC(g)
    local components = {}
    local ids = {}
    local low = {}
    local onStack = {}
    local stack = {}
    local timer = 0

    for i = 0, g.n - 1 do
        ids[i + 1] = -1
        low[i + 1] = 0
        onStack[i + 1] = false
    end

    local function dfs(u)
        ids[u + 1] = timer
        low[u + 1] = timer
        timer = timer + 1
        table.insert(stack, u)
        onStack[u + 1] = true

        for _, v in ipairs(g.adj[u + 1]) do
            if ids[v + 1] == -1 then
                dfs(v)
                low[u + 1] = min(low[u + 1], low[v + 1])
            elseif onStack[v + 1] then
                low[u + 1] = min(low[u + 1], ids[v + 1])
            end
        end

        -- If u is root of an SCC, pop stack
        if low[u + 1] == ids[u + 1] then
            local comp = {}
            while true do
                local w = table.remove(stack)
                onStack[w + 1] = false
                table.insert(comp, w)
                if w == u then
                    break
                end
            end
            table.insert(components, comp)
        end
    end

    for i = 0, g.n - 1 do
        if ids[i + 1] == -1 then
            dfs(i)
        end
    end

    return components
end

local function main()
    print("=== Tarjan's Strongly Connected Components (SCC) ===")
    print("Graph: 8 vertices, 10 directed edges")
    print("Edges:")
    print("  0 -> 1, 1 -> 2, 2 -> 0")
    print("  2 -> 3, 3 -> 4, 4 -> 3")
    print("  4 -> 5, 5 -> 6, 6 -> 7, 7 -> 5\n")

    local g = Graph.new(8)
    -- Cycle 0-1-2
    g:addEdge(0, 1)
    g:addEdge(1, 2)
    g:addEdge(2, 0)

    -- Cross edge 2 -> 3
    g:addEdge(2, 3)

    -- Cycle 3-4
    g:addEdge(3, 4)
    g:addEdge(4, 3)

    -- Cross edge 4 -> 5
    g:addEdge(4, 5)

    -- Cycle 5-6-7
    g:addEdge(5, 6)
    g:addEdge(6, 7)
    g:addEdge(7, 5)

    print("Executing Tarjan's Single-Pass DFS...\n")

    local comps = findSCC(g)

    print(string.format("Identified %d Strongly Connected Components:", #comps))
    for i, comp in ipairs(comps) do
        local parts = {}
        for _, v in ipairs(comp) do
            table.insert(parts, tostring(v))
        end
        print(string.format("  SCC #%d: [ %s ] (Size: %d)", i, table.concat(parts, " "), #comp))
    end
    print("")

    print(string.format("All vertices accounted for across %d disjoint SCC components.", #comps))
    print("Tarjan's SCC analysis completed successfully.")
end

main()
