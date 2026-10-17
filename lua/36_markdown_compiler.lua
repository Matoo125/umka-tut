-- =============================================================================
-- Exercise 36: Markdown to HTML Compiler
-- Concepts: Line-by-line block parsing, prefix detection, list grouping state
--           machines, character-by-character inline scanner, and HTML generation.
-- Run:      lua 36_markdown_compiler.lua
-- =============================================================================

-- Returns true if string s begins with the specified prefix
local function startsWith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

-- Scans text character by character to convert **bold** and `code` inline tokens
local function formatInline(text)
    local out = ""
    local inBold = false
    local inCode = false

    local i = 1
    while i <= #text do
        if i + 1 <= #text and text:sub(i, i + 1) == "**" and not inCode then
            if inBold then
                out = out .. "</strong>"
                inBold = false
            else
                out = out .. "<strong>"
                inBold = true
            end
            i = i + 2
        elseif text:sub(i, i) == "`" and not inBold then
            if inCode then
                out = out .. "</code>"
                inCode = false
            else
                out = out .. "<code>"
                inCode = true
            end
            i = i + 1
        else
            out = out .. text:sub(i, i)
            i = i + 1
        end
    end
    return out
end

-- Compiles a multi-line Markdown document into clean HTML
local function compileMarkdown(source)
    local lines = {}
    for line in source:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local html = ""
    local inList = false

    for _, line in ipairs(lines) do
        if #line == 0 then
            if inList then
                html = html .. "</ul>\n"
                inList = false
            end
        elseif startsWith(line, "### ") then
            if inList then html = html .. "</ul>\n"; inList = false end
            local content = line:sub(5)
            html = html .. "<h3>" .. formatInline(content) .. "</h3>\n"
        elseif startsWith(line, "## ") then
            if inList then html = html .. "</ul>\n"; inList = false end
            local content = line:sub(4)
            html = html .. "<h2>" .. formatInline(content) .. "</h2>\n"
        elseif startsWith(line, "# ") then
            if inList then html = html .. "</ul>\n"; inList = false end
            local content = line:sub(3)
            html = html .. "<h1>" .. formatInline(content) .. "</h1>\n"
        elseif startsWith(line, "> ") then
            if inList then html = html .. "</ul>\n"; inList = false end
            local content = line:sub(3)
            html = html .. "<blockquote>" .. formatInline(content) .. "</blockquote>\n"
        elseif startsWith(line, "- ") then
            if not inList then
                html = html .. "<ul>\n"
                inList = true
            end
            local content = line:sub(3)
            html = html .. "  <li>" .. formatInline(content) .. "</li>\n"
        else
            if inList then html = html .. "</ul>\n"; inList = false end
            html = html .. "<p>" .. formatInline(line) .. "</p>\n"
        end
    end

    if inList then
        html = html .. "</ul>\n"
        inList = false
    end

    return html
end

local function main()
    local md = "# Umka Language\n" ..
               "Umka is a **statically typed** embeddable scripting language.\n" ..
               "## Features\n" ..
               "- Clean Go-like syntax\n" ..
               "- Fast execution with `bytecode` VM\n" ..
               "- Built-in array and hash map collections\n" ..
               "> Simplicity is prerequisite for reliability.\n"

    print(string.format("=== Markdown Source ===\n%s", md))
    local compiled = compileMarkdown(md)
    io.write(string.format("=== Compiled HTML Output ===\n%s", compiled))
end

main()
