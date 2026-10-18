# Exercise 48: Tarjan's Strongly Connected Components (SCC)

## Objective

Implement **Tarjan's Strongly Connected Components (SCC)** algorithm in Umka and Lua. In a directed graph, a strongly connected component is a maximal set of vertices such that every vertex in the component is reachable from every other vertex. Tarjan's algorithm partitions any directed graph into its SCCs in linear $O(V + E)$ time using a single-pass Depth-First Search (DFS) with low-link values and a stack.

---

## Core Concepts

### 1. Strongly Connected Components (SCC)
In undirected graphs, connected components are trivial to find via simple BFS/DFS. In directed graphs, reachability is asymmetric: vertex $u$ may reach $v$, but $v$ might not reach $u$.
An SCC is a subgraph where mutual reachability holds for all pairs:
$$\forall u, v \in C, \quad u \rightsquigarrow v \text{ and } v \rightsquigarrow u$$

### 2. Tarjan's Discovery IDs and Low-Link Values
During DFS traversal:
- `ids[u]`: An incrementing counter indicating when vertex $u$ was first visited.
- `low[u]`: The lowest discovery ID reachable from $u$ by traversing tree edges and back-edges to nodes currently stored on the recursion stack.

### 3. The SCC Stack Invariant
- Nodes are pushed onto a tracking stack when visited.
- `onStack[u]` indicates whether node $u$ is currently on the stack.
- When an edge $(u, v)$ is explored:
  - If $v$ is unvisited: Recurse into $v$, then update `low[u] = min(low[u], low[v])`.
  - If $v$ is already visited and `onStack[v]` is true: Update `low[u] = min(low[u], ids[v])`.
- When DFS finishes exploring all outgoing edges of $u$:
  - If `low[u] == ids[u]`, then $u$ is the "root" of an SCC.
  - All vertices down to $u$ on the stack are popped to form the complete SCC component.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Adjacency Lists** | 2D dynamic slice `[][]int` initialized with `make([][]int, n)` | Table of vertex arrays `self.adj[u + 1]` |
| **Loop Condition** | Requires explicit boolean expression: `for true { ... }` | Standard `while true do ... end` |
| **Stack Removal** | `s.stack = delete(s.stack, len(s.stack) - 1)` | `table.remove(stack)` |
| **Component Storage** | Slice of slices `[][]int` | Table of tables `components = {}` |

---

## Sample Run & Output

```text
=== Tarjan's Strongly Connected Components (SCC) ===
Graph: 8 vertices, 10 directed edges
Edges:
  0 -> 1, 1 -> 2, 2 -> 0
  2 -> 3, 3 -> 4, 4 -> 3
  4 -> 5, 5 -> 6, 6 -> 7, 7 -> 5

Executing Tarjan's Single-Pass DFS...

Identified 3 Strongly Connected Components:
  SCC #1: [ 7 6 5 ] (Size: 3)
  SCC #2: [ 4 3 ] (Size: 2)
  SCC #3: [ 2 1 0 ] (Size: 3)

All vertices accounted for across 3 disjoint SCC components.
Tarjan's SCC analysis completed successfully.
```

---

## Common Pitfalls

1. **Cross-Edges to Completed SCCs**: When inspecting an already visited neighbor $v$, only update `low[u]` if `onStack[v]` is `true`. Updating `low[u]` for cross-edges pointing to previously finalized SCCs corrupts root detection.
2. **Infinite Loop in Umka**: In Umka, `for { ... }` is invalid syntax and produces a parser error; write `for true { ... }` or use an explicit termination flag.
3. **Low-Link Update Target**: For back-edges, update with `ids[v]`, not `low[v]`, adhering to Tarjan's original invariant and avoiding cycle misclassification.
