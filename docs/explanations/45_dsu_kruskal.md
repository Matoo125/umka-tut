# Exercise 45: Disjoint-Set Union (DSU) & Kruskal's MST

## Objective

Implement an optimized **Disjoint-Set Union (DSU / Union-Find)** data structure with **Path Compression** and **Union by Rank** in Umka and Lua, applying it to compute the **Minimum Spanning Tree (MST)** of a weighted undirected graph via **Kruskal's Algorithm**.

---

## Core Concepts

### 1. Disjoint-Set Forest (Union-Find)
A DSU data structure partitions $N$ elements into non-overlapping subsets and supports two primary operations:
- `find(x)`: Identifies the representative leader of the subset containing $x$.
- `union(a, b)`: Merges the subsets containing $a$ and $b$ if they belong to different components.

### 2. Algorithmic Optimizations
1. **Path Compression**:
   During `find(x)`, as we traverse up the parent chain to find the root, we rewire every visited node's parent pointer directly to the root:
   $$\text{parent}[x] \leftarrow \text{find}(\text{parent}[x])$$
   This flattens the tree depth for future operations.
2. **Union by Rank**:
   When combining two trees with roots $r_A$ and $r_B$, attach the root with smaller `rank` under the root with larger `rank`. If ranks are equal, increment the winner's rank by 1.
3. **Time Complexity**:
   Combining path compression with union-by-rank guarantees an amortized time complexity of $O(\alpha(N))$ per operation, where $\alpha$ is the Inverse Ackermann function ($\alpha(N) < 5$ for all practical inputs).

### 3. Kruskal's Algorithm for Minimum Spanning Trees
A Minimum Spanning Tree of a connected, undirected graph with $V$ vertices is a subgraph that connects all $V$ vertices with exactly $V - 1$ edges while minimizing the sum of edge weights.
1. Sort all $E$ edges in non-decreasing order of weight.
2. Initialize a DSU containing $V$ isolated components.
3. For each candidate edge $(u, v, w)$:
   - Check if $u$ and $v$ belong to different components: `union(u, v)`.
   - If `true`: Add edge to the MST (no cycle formed).
   - If `false`: Reject edge (adding it would introduce a cycle).
4. Terminate when $V - 1$ edges have been accepted.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **DSU Struct** | Typed struct `type DSU = struct { parent, rank: []int; components: int }` | Table metatable `DSU = {}` with `self.parent`, `self.rank` |
| **0-Based Vertex Indexing** | Vertices $0 \dots N-1$ directly index `parent[x]` | Vertices $0 \dots N-1$ mapped to 1-based arrays via `x + 1` |
| **Edge Sorting** | In-place insertion sort on `^[]Edge` with secondary tie-breakers | Built-in `table.sort(edges, compFn)` |
| **Pass-by-Pointer** | Slices passed by pointer (`^[]Edge`) to mutate arrays in-place | Tables passed by reference automatically |

---

## Sample Run & Output

```text
=== Kruskal's Minimum Spanning Tree (MST) & Disjoint-Set ===
Graph Vertices: 5 (A=0, B=1, C=2, D=3, E=4)
Total Graph Edges: 7

Sorted Candidate Edges:
  (0-1, w=1)
  (1-2, w=2)
  (0-2, w=3)
  (1-3, w=3)
  (2-4, w=4)
  (3-4, w=5)
  (1-4, w=6)

Kruskal's MST Selection:
  + Accepted (0-1, w=1)
  + Accepted (1-2, w=2)
  - Rejected (0-2, w=3) -> Cycle detected
  + Accepted (1-3, w=3)
  + Accepted (2-4, w=4)
  - Rejected (3-4, w=5) -> Cycle detected
  - Rejected (1-4, w=6) -> Cycle detected

Minimum Spanning Tree Edges:
  Edge: 0 - 1 (Weight: 1)
  Edge: 1 - 2 (Weight: 2)
  Edge: 1 - 3 (Weight: 3)
  Edge: 2 - 4 (Weight: 4)

Total MST Weight: 10
Disjoint-Set components: 1 (Fully connected)
```

---

## Common Pitfalls

1. **Cycle Detection Without DSU**: Using BFS/DFS to check for cycles on each edge insertion takes $O(V)$ per edge, degrading Kruskal's complexity from $O(E \log E)$ to $O(E \cdot V)$. DSU reduces cycle checks to near-instantaneous $O(\alpha(V))$.
2. **Path Compression Return Value**: Ensure `find(x)` returns the root after updating `parent[x] = find(parent[x])`. Returning the old parent defeats path compression.
3. **1-Based vs 0-Based Indices in Lua**: When vertex identifiers start from 0, mapping them to 1-based table arrays must be consistent across `parent` and `rank` accesses (`idx = x + 1`).
