# Exercise 42: A* Grid Pathfinding with Heuristics

## Objective

Implement the **A\* (A-Star) search algorithm** in Umka and Lua to compute the optimal path across a 2D tile grid around obstacles. Use the Manhattan distance admissible heuristic function to prune the search space, reconstruct the shortest path via predecessor backtrack links, and visually display the solved navigation path on an ASCII grid map.

---

## Core Concepts

### 1. A* Cost Evaluation Function
At each step, A* selects the unvisited node that minimizes the estimated total path cost:
$$f(n) = g(n) + h(n)$$
- **Exact Path Cost $g(n)$**: The true traversal cost from the starting node $S$ to candidate node $n$.
- **Heuristic Estimate $h(n)$**: An admissible, optimistic estimate of the distance from node $n$ to the goal $E$.
- **Admissibility**: A heuristic is admissible if it never overestimates the true remaining cost ($h(n) \le h^*(n)$). An admissible heuristic guarantees that A* finds an optimal shortest path.

### 2. Manhattan Distance on 4-Way Grids
In a grid allowing movement only in orthogonal directions (Up, Down, Left, Right):
$$h(a, b) = |a_x - b_x| + |a_y - b_y|$$
Since diagonal moves are prohibited and step cost is 1, Manhattan distance is strictly admissible and monotonic.

### 3. Open Set vs. Closed Set
- **Open Set**: Priority collection of candidate frontier nodes waiting to be expanded.
- **Closed Set**: Nodes that have already been evaluated; preventing redundant revisitation.
- **Predecessor Map (`cameFrom`)**: Stores the optimal predecessor for each visited point, enabling retroactive back-tracing from goal to start once the search completes.

---

## Umka vs. Lua Implementation Nuances

| Feature | Umka | Lua |
| :--- | :--- | :--- |
| **Grid Data & Strings** | Array of strings `[8]str`; characters accessed by index `grid[y][x]` | Table of strings; characters accessed via `row:sub(x, x)` |
| **Point Hash Keys** | Encoded as unique integer `p.y * 1000 + p.x` in `map[int]Point` | Encoded as integer key in standard hash table `cameFrom[key]` |
| **Membership Testing** | Built-in `validkey(map, key)` tests map presence | Standard `table[key] ~= nil` check |
| **Built-in `abs()`** | Built-in `abs(int)` operates on numeric types | `math.abs(n)` |

---

## Visual Output & Path Trajectory

```text
=== A* Grid Pathfinding ===
Source Grid:
########
#S.....#
#.###..#
#...#..#
#...#..#
#..##..#
#.....E#
########

A* Search: Path found! Length: 10 steps

Solved Grid:
########
#S.....#
#*###..#
#*..#..#
#*..#..#
#*.##..#
#*****E#
########

Path Coordinates:
  (1,1) -> (1,2) -> (1,3) -> (1,4) -> (1,5) -> (1,6) -> (2,6) -> (3,6) -> (4,6) -> (5,6) -> (6,6)

Pathfinding completed successfully.
```

---

## Common Pitfalls

1. **Inadmissible Heuristics**: Using Euclidean distance or multiplied factors on grid steps can overestimate remaining cost or break admissibility, resulting in suboptimal routes.
2. **Path Reversal**: Backtracking through `cameFrom` links produces the trajectory in reverse (Goal $\to$ Start). Always reverse the sequence before printing coordinates or applying movement.
3. **Array Shifting on Deletion**: When extracting the minimum from a slice, `openSet = delete(openSet, bestIdx)` cleanly removes the element. In Lua, `table.remove(openSet, bestIdx)` preserves array continuity.
