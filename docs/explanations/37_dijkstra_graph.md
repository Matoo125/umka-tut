# Exercise Graph Representation & Dijkstra's Shortest Path (`37_dijkstra_graph.um`)

### 🎯 Objective
Model a directed weighted graph using an adjacency list map and implement Dijkstra's algorithm to compute the minimum traversal cost and optimal route between vertices.

### 🧠 Core Concepts
- Adjacency list: Storing outgoing directed edges with weights using `map[str][]Edge`.
- Tentative distance table: Tracking minimum path distances initialized to a high sentinel `INF = 1000000000`.
- Greedy relaxation: Greedily selecting the unvisited node with minimum tentative cost, relaxing adjacent edges, and updating predecessor pointers (`prev[neighbor] = current`).
- Backtracking reconstruction: Following `prev` pointers backwards from the destination vertex to the source and reversing the slice to produce the forward route.

### ⚖️ Umka vs Lua
- **Umka**: Strongly typed struct `Edge = struct { to: str, weight: int }` inside `map[str][]Edge`.
- **Lua**: Nested tables storing `{ to = ..., weight = ... }`.

### ⚠️ Common Pitfalls
- Forgetting to register destination-only vertices in the graph's vertex universe leaves them unvisited.
- Attempting to backtrack when no valid route exists (`dist[target] == INF`).
