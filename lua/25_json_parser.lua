-- =============================================================================
-- Exercise 25: JSON Lexer & Parser
-- Concepts: Token streams, recursive descent parsing, tables as dynamic object models
-- Run:      lua 25_json_parser.lua
-- =============================================================================

local function tokenize(src)
    local tokens = {}
    local i = 1
    local n = #src

    while i <= n do
        local ch = string.sub(src, i, i)

        if ch:match("%s") then
            i = i + 1
        elseif ch == "{" then
            table.insert(tokens, { kind = "LBRACE", val = "{" })
            i = i + 1
        elseif ch == "}" then
            table.insert(tokens, { kind = "RBRACE", val = "}" })
            i = i + 1
        elseif ch == ":" then
            table.insert(tokens, { kind = "COLON", val = ":" })
            i = i + 1
        elseif ch == "," then
            table.insert(tokens, { kind = "COMMA", val = "," })
            i = i + 1
        elseif ch == '"' then
            i = i + 1
            local startPos = i
            while i <= n and string.sub(src, i, i) ~= '"' do
                i = i + 1
            end
            local strVal = string.sub(src, startPos, i - 1)
            if i <= n and string.sub(src, i, i) == '"' then
                i = i + 1
            end
            table.insert(tokens, { kind = "STRING", val = strVal })
        elseif ch:match("[%d%-]") then
            local startPos = i
            while i <= n and string.sub(src, i, i):match("[%d%.]") do
                i = i + 1
            end
            local numStr = string.sub(src, startPos, i - 1)
            table.insert(tokens, { kind = "NUMBER", val = tonumber(numStr) })
        elseif ch == "t" or ch == "f" then
            local startPos = i
            while i <= n and string.sub(src, i, i):match("%a") do
                i = i + 1
            end
            local word = string.sub(src, startPos, i - 1)
            table.insert(tokens, { kind = "BOOL", val = (word == "true") })
        else
            i = i + 1
        end
    end

    table.insert(tokens, { kind = "EOF", val = "<EOF>" })
    return tokens
end

local function parseJSONObject(tokens)
    local result = {}
    local pos = 1

    if pos > #tokens or tokens[pos].kind ~= "LBRACE" then
        return nil, false
    end
    pos = pos + 1

    while pos <= #tokens and tokens[pos].kind ~= "RBRACE" do
        if tokens[pos].kind ~= "STRING" then
            return nil, false
        end
        local key = tokens[pos].val
        pos = pos + 1

        if pos > #tokens or tokens[pos].kind ~= "COLON" then
            return nil, false
        end
        pos = pos + 1

        if pos > #tokens then
            return nil, false
        end

        local tok = tokens[pos]
        if tok.kind == "STRING" or tok.kind == "NUMBER" or tok.kind == "BOOL" then
            result[key] = tok.val
        else
            return nil, false
        end
        pos = pos + 1

        if pos <= #tokens and tokens[pos].kind == "COMMA" then
            pos = pos + 1
        end
    end

    return result, true
end

local function repr(val)
    if type(val) == "string" then
        return string.format('"%s"', val)
    elseif type(val) == "number" then
        return string.format("%.2f", val)
    elseif type(val) == "boolean" then
        return tostring(val)
    end
    return "null"
end

local function main()
    local src = '{"lang": "Umka", "version": 1.6, "embedded": true, "author": "Vasiliy"}'
    local tokens = tokenize(src)
    local doc, ok = parseJSONObject(tokens)

    if not ok then
        print("Failed to parse JSON")
        return
    end

    local ks = {}
    for k in pairs(doc) do
        table.insert(ks, k)
    end
    table.sort(ks)

    print(string.format("Parsed %d JSON properties:", #ks))
    for _, k in ipairs(ks) do
        print(string.format("  %-10s : %s", k, repr(doc[k])))
    end
end

main()
