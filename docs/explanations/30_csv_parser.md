# Exercise CSV Table Parser & Query Filter (`30_csv_parser.um`)

### 🎯 Objective
Parse multi-line CSV datasets into structured 2D tables while correctly handling quoted fields with commas.

### 🧠 Core Concepts
- Stateful character scanning: Toggle `inQuotes` flag on `"` delimiters.
- 2D data representation: `CSVTable` containing header array `[]str` and rows `[]CSVRow`.
- Dynamic query filtering: Finding records matching column criteria.

### ⚖️ Umka vs Lua
- **Umka**: Character iteration over strings using index `str[i]`.
- **Lua**: String patterns or `str:sub(i, i)` character inspection.

### ⚠️ Common Pitfalls
- Splitting naively on `,` breaks on fields like `"Bob, Jr."` unless quotation state is tracked.
