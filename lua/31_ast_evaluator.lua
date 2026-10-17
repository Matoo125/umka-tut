-- =============================================================================
-- Exercise 31: Arithmetic Expression Parser & AST Evaluator
-- Concepts: Recursive-descent operator-precedence parsing, AST trees,
--           recursive tree walking, infix pretty-printing, and evaluation.
-- Run:      lua 31_ast_evaluator.lua
-- =============================================================================

local NodeType = {
    Number = 1,
    BinaryOp = 2
}

local Parser = {}
Parser.__index = Parser

function Parser.new(src)
    return setmetatable({ src = src, pos = 1 }, Parser)
end

-- Returns current non-whitespace character without consuming it
function Parser:peek()
    while self.pos <= #self.src and self.src:sub(self.pos, self.pos) == ' ' do
        self.pos = self.pos + 1
    end
    if self.pos > #self.src then return '\0' end
    return self.src:sub(self.pos, self.pos)
end

-- Consumes and returns current character
function Parser:next()
    local ch = self:peek()
    if self.pos <= #self.src then
        self.pos = self.pos + 1
    end
    return ch
end

local parseExpr

-- Parses primary expressions: numbers or parenthesized subexpressions `(...)`
local function parsePrimary(p)
    local ch = p:peek()
    if ch == '(' then
        p:next() -- consume '('
        local node = parseExpr(p)
        if p:peek() == ')' then
            p:next() -- consume ')'
        end
        return node
    end
    if ch >= '0' and ch <= '9' then
        p:next()
        local val = tonumber(ch) + 0.0
        return { kind = NodeType.Number, val = val }
    end
    return nil
end

-- Parses multiplicative terms: `*` and `/` (higher precedence)
local function parseTerm(p)
    local left = parsePrimary(p)
    while true do
        local op = p:peek()
        if op == '*' or op == '/' then
            p:next()
            local right = parsePrimary(p)
            left = { kind = NodeType.BinaryOp, op = op, left = left, right = right }
        else
            break
        end
    end
    return left
end

-- Parses additive expressions: `+` and `-` (lower precedence)
parseExpr = function(p)
    local left = parseTerm(p)
    while true do
        local op = p:peek()
        if op == '+' or op == '-' then
            p:next()
            local right = parseTerm(p)
            left = { kind = NodeType.BinaryOp, op = op, left = left, right = right }
        else
            break
        end
    end
    return left
end

-- Evaluates the AST recursively
local function eval(n)
    if not n then return 0.0 end
    if n.kind == NodeType.Number then return n.val end
    local l = eval(n.left)
    local r = eval(n.right)
    if n.op == '+' then return l + r end
    if n.op == '-' then return l - r end
    if n.op == '*' then return l * r end
    if n.op == '/' then
        if r ~= 0 then return l / r else return 0.0 end
    end
    return 0.0
end

-- Pretty-prints the AST in explicit parenthesized infix form
local function printInfix(n)
    if not n then return end
    if n.kind == NodeType.Number then
        io.write(string.format("%.0f", n.val))
    else
        io.write("(")
        printInfix(n.left)
        io.write(string.format(" %s ", n.op))
        printInfix(n.right)
        io.write(")")
    end
end

local function main()
    local exprStr = "3 + 5 * ( 2 + 4 )"
    local p = Parser.new(exprStr)
    local ast = parseExpr(p)

    print(string.format("Source Expression: %s", exprStr))
    io.write("AST Infix Tree:    ")
    printInfix(ast)
    io.write("\n")
    print(string.format("Evaluated Result:  %.2f", eval(ast)))
end

main()
