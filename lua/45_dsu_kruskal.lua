-- 45_dsu_kruskal.lua - Disjoint-Set Union & Kruskal's MST in Lua

local DSU = {}
DSU.__index = DSU

function DSU.new(n)
    local self = setmetatable({}, DSU)
    self.parent = {}
    self.rank = {}
    self.components = n
    -- 0-indexed vertices mapped to 1-based arrays: vertex i is at index i + 1
    for i = 0, n - 1 do
        self.parent[i + 1] = i
        self.rank[i + 1] = 0
    end
    return self
end

function DSU:find(x)
    local idx = x + 1
    if self.parent[idx] ~= x then
        -- Path compression
        self.parent[idx] = self:find(self.parent[idx])
    end
    return self.parent[idx]
end

function DSU:union(a, b)
    local rootA = self:find(a)
    local rootB = self:find(b)

    if rootA == rootB then
        return false
    end

    local idxA = rootA + 1
    local idxB = rootB + 1

    -- Union by rank
    if self.rank[idxA] < self.rank[idxB] then
        self.parent[idxA] = rootB
    elseif self.rank[idxA] > self.rank[idxB] then
        self.parent[idxB] = rootA
    else
        self.parent[idxB] = rootA
        self.rank[idxA] = self.rank[idxA] + 1
    end

    self.components = self.components - 1
    return true
end

local function sortEdges(edges)
    table.sort(edges, function(a, b)
        if a.weight ~= b.weight then
            return a.weight < b.weight
        end
        if a.u ~= b.u then
            return a.u < b.u
        end
        return a.v < b.v
    end)
end

local function main()
    print("=== Kruskal's Minimum Spanning Tree (MST) & Disjoint-Set ===")

    local numVertices = 5
    print(string.format("Graph Vertices: %d (A=0, B=1, C=2, D=3, E=4)", numVertices))

    local edges = {
        { u = 0, v = 1, weight = 1 },
        { u = 1, v = 2, weight = 2 },
        { u = 0, v = 2, weight = 3 },
        { u = 1, v = 3, weight = 3 },
        { u = 2, v = 4, weight = 4 },
        { u = 3, v = 4, weight = 5 },
        { u = 1, v = 4, weight = 6 }
    }

    print(string.format("Total Graph Edges: %d\n", #edges))

    sortEdges(edges)

    print("Sorted Candidate Edges:")
    for _, e in ipairs(edges) do
        print(string.format("  (%d-%d, w=%d)", e.u, e.v, e.weight))
    end
    print("")

    local dsu = DSU.new(numVertices)
    local mst = {}
    local totalWeight = 0

    print("Kruskal's MST Selection:")
    for _, e in ipairs(edges) do
        if dsu:union(e.u, e.v) then
            table.insert(mst, e)
            totalWeight = totalWeight + e.weight
            print(string.format("  + Accepted (%d-%d, w=%d)", e.u, e.v, e.weight))
        else
            print(string.format("  - Rejected (%d-%d, w=%d) -> Cycle detected", e.u, e.v, e.weight))
        end
    end
    print("")

    print("Minimum Spanning Tree Edges:")
    for _, e in ipairs(mst) do
        print(string.format("  Edge: %d - %d (Weight: %d)", e.u, e.v, e.weight))
    end
    print("")

    print(string.format("Total MST Weight: %d", totalWeight))
    print(string.format("Disjoint-Set components: %d (Fully connected)", dsu.components))
end

main()
