-- =============================================================================
-- Exercise 15: Reverse Polish Notation (RPN) Calculator
-- Concepts: Object-oriented stack with metatables, multi-value returns, token parsing
-- Run:      printf '5\n3\n4\n+\n2\n*\n' | lua 15_rpn_calculator.lua
-- =============================================================================

local RpnStack = {}
RpnStack.__index = RpnStack

function RpnStack.new()
    return setmetatable({ items = {} }, RpnStack)
end

function RpnStack:push(val)
    table.insert(self.items, val)
end

function RpnStack:pop()
    local n = #self.items
    if n == 0 then
        return 0.0, false
    end
    local val = table.remove(self.items)
    return val, true
end

function RpnStack:len()
    return #self.items
end

local function evaluateRPN(tokens)
    local st = RpnStack.new()

    for _, tok in ipairs(tokens) do
        if tok == "+" or tok == "-" or tok == "*" or tok == "/" then
            local b, okB = st:pop()
            local a, okA = st:pop()
            if not okA or not okB then
                return 0.0, false
            end

            if tok == "+" then
                st:push(a + b)
            elseif tok == "-" then
                st:push(a - b)
            elseif tok == "*" then
                st:push(a * b)
            elseif tok == "/" then
                if b == 0.0 then
                    return 0.0, false
                end
                st:push(a / b)
            end
        else
            local val = tonumber(tok)
            if not val then
                return 0.0, false
            end
            st:push(val)
        end
    end

    if st:len() ~= 1 then
        return 0.0, false
    end

    local result = st:pop()
    return result, true
end

local function main()
    io.write("RPN Calculator\n")
    io.write("Enter number of tokens: ")
    local rest = io.read("*a") or ""
    local tokens = {}
    for tok in string.gmatch(rest, "%S+") do
        table.insert(tokens, tok)
    end

    if #tokens == 0 then
        io.write("Invalid token count.\n")
        return
    end

    local n = tonumber(tokens[1])
    if not n or n <= 0 then
        io.write("Invalid token count.\n")
        return
    end

    table.remove(tokens, 1) -- remove count
    io.write(string.format("Enter %d tokens separated by whitespace:\n", n))

    local res, ok = evaluateRPN(tokens)
    if ok then
        io.write(string.format("Result: %.4f\n", res))
    else
        io.write("Evaluation error: invalid RPN expression.\n")
    end
end

main()
