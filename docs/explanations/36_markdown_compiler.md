# Exercise Markdown to HTML Compiler (`36_markdown_compiler.um`)

### 🎯 Objective
Build a two-pass Markdown-to-HTML compiler that transforms block-level syntax (headings, lists, blockquotes, paragraphs) and inline markup (bold `**`, code `` ` ``) into clean, standard HTML markup.

### 🧠 Core Concepts
- Two-pass compiler architecture: Stage 1 processes structural line blocks; Stage 2 scans text character-by-character for inline delimiters.
- List grouping state machine: Maintaining `inList: bool` across consecutive `- ` items to correctly open `<ul>` and close with `</ul>` on non-list items or EOF.
- Stateful inline scanning: Parsing paired tokens (`**` for `<strong>`, `` ` `` for `<code>`) without executing regex engines.
- String slicing: Extracting prefix-stripped content slices with `slice(line, offset, len(line))`.

### ⚖️ Umka vs Lua
- **Umka**: Character loops over strings using `text[i]` and slicing `slice(s, start, end)`.
- **Lua**: String index manipulation using `s:sub(i, i)` and 1-based indexing.

### ⚠️ Common Pitfalls
- Failing to close an active `inList` when hitting document EOF drops the trailing `</ul>` tag.
- Not resetting list state on blank empty lines.
