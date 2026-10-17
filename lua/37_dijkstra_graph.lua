-- =============================================================================
-- Exercise 37: Graph Representation & Dijkstra's Shortest Path
-- Concepts: Adjacency list graph model, edge weighting, greedy vertex
--           relaxation, distance table tracking, and optimal route backtracking.
-- Run:      lua 37_dijkstra_graph.lua
-- =============================================================================

local INF = 1000000000

local Graph = {}
Graph.__index = Graph

function Graph.new()
    return setmetatable({
        adj = {},
        vertices = {}
    }, Graph)
end

-- Registers a vertex in the adjacency map and vertex array if not present
function Graph:addVertex(v)
    if not self.adj[v] then
        self.adj[v] = {}
        table.insert(self.vertices, v)
    end
end

-- Adds a directed weighted edge from source to target
function Graph:addEdge(from, to, weight)
    self:addVertex(from)
    self:addVertex(to)
    table.insert(self.adj[from], { to = to, weight = weight })
end

-- Executes Dijkstra's algorithm to compute minimum cost and reconstruct optimal route
function Graph:findShortestPath(start, target)
    local dist = {}
    local prev = {}
    local visited = {}

    for _, v in ipairs(self.vertices) do
        dist[v] = INF
        visited[v] = false
    end
    dist[start] = 0

    for _ = 1, #self.vertices do
        local minDist = INF
        local u = nil

        for _, v in ipairs(self.vertices) do
            if not visited[v] and dist[v] < minDist then
                minDist = dist[v]
                u = v
            end
        end

        if not u or u == target then
            break
        end

        visited[u] = true
        local edges = self.adj[u]

        for _, e in ipairs(edges) do
            if not visited[e.to] then
                local alt = dist[u] + e.weight
                if alt < dist[e.to] then
                    dist[e.to] = alt
                    prev[e.to] = u
                end
            end
        end
    end

    print(string.format("Shortest Path from %s to %s:", start, target))
    if dist[target] == INF then
        print("  No path exists.")
        return
    end

    -- Reconstruct path by tracing predecessor pointers backwards
    local path = {}
    local curr = target
    while curr do
        table.insert(path, curr)
        if curr == start then break end
        curr = prev[curr]
    end

    -- Reverse path into forward chronological order
    local n = #path
    for i = 1, n // 2 do
        path[i], path[n - i + 1] = path[n - i + 1], path[i]
    end

    io.write("  Route: ")
    for i = 1, #path do
        io.write(path[i])
        if i < #path then
            io.write(" -> ")
        end
    end
    io.write(string.format("\n  Total Cost: %d\n", dist[target]))
end

local function main()
    local g = Graph.new()

    -- Directed graph setup:
    -- A -> B (4), A -> C (2)
    -- C -> B (1), B -> D (5), C -> D (8), C -> E (10)
    -- B -> E (2), E -> D (1)
    g:addEdge("A", "B", 4)
    g:addEdge("A", "C", 2)
    g:addEdge("C", "B", 1)
    g:addEdge("B", "D", 5)
    g:addEdge("C", "D", 8)
    g:addEdge("C", "E", 10)
    g:addEdge("B", "E", 2)
    g:addEdge("E", "D", 1)

    print("=== Dijkstra's Shortest Path Algorithm ===")
    g:findShortestPath("A", "D")
    g:findShortestPath("C", "E")
end

main()
