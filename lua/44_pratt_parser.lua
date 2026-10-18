-- 44_pratt_parser.lua - Pratt Parser (Top-Down Operator Precedence) in Lua

local TokenType = {
    TOK_INT    = 1,
    TOK_PLUS   = 2,
    TOK_MINUS  = 3,
    TOK_MUL    = 4,
    TOK_DIV    = 5,
    TOK_POWER  = 6,
    TOK_LPAREN = 7,
    TOK_RPAREN = 8,
    TOK_EOF    = 9
}

local NodeKind = {
    NODE_NUM    = 1,
    NODE_UNARY  = 2,
    NODE_BINARY = 3
}

local Parser = {}
Parser.__index = Parser

function Parser.new(tokens)
    local self = setmetatable({}, Parser)
    self.tokens = tokens
    self.pos = 1
    return self
end

function Parser:peek()
    if self.pos <= #self.tokens then
        return self.tokens[self.pos]
    end
    return { tokType = TokenType.TOK_EOF, val = 0 }
end

function Parser:next()
    local tok = self:peek()
    if self.pos <= #self.tokens then
        self.pos = self.pos + 1
    end
    return tok
end

local function getLbp(t)
    local tt = t.tokType
    if tt == TokenType.TOK_PLUS or tt == TokenType.TOK_MINUS then
        return 10
    elseif tt == TokenType.TOK_MUL or tt == TokenType.TOK_DIV then
        return 20
    elseif tt == TokenType.TOK_POWER then
        return 30
    end
    return 0
end

function Parser:parseExpr(rbp)
    local tok = self:next()
    local left = nil

    -- Null Denotation (nud)
    local tt = tok.tokType
    if tt == TokenType.TOK_INT then
        left = {
            kind = NodeKind.NODE_NUM,
            val = tok.val
        }
    elseif tt == TokenType.TOK_MINUS then
        local operand = self:parseExpr(40)
        left = {
            kind = NodeKind.NODE_UNARY,
            op = TokenType.TOK_MINUS,
            left = operand
        }
    elseif tt == TokenType.TOK_LPAREN then
        local expr = self:parseExpr(0)
        local closeParen = self:next()
        if closeParen.tokType ~= TokenType.TOK_RPAREN then
            print("Error: Expected ')'")
        end
        left = expr
    else
        print(string.format("Error: Unexpected token in nud"))
        return nil
    end

    -- Left Denotation (led) loop
    while rbp < getLbp(self:peek()) do
        local opTok = self:next()
        local nextRbp = getLbp(opTok)
        if opTok.tokType == TokenType.TOK_POWER then
            nextRbp = nextRbp - 1
        end

        local rightNode = self:parseExpr(nextRbp)
        left = {
            kind = NodeKind.NODE_BINARY,
            op = opTok.tokType,
            left = left,
            right = rightNode
        }
    end

    return left
end

local function intPow(base, exp)
    local res = 1
    for _ = 1, exp do
        res = res * base
    end
    return res
end

local function eval(n)
    if not n then return 0 end

    if n.kind == NodeKind.NODE_NUM then
        return n.val
    elseif n.kind == NodeKind.NODE_UNARY then
        local v = eval(n.left)
        if n.op == TokenType.TOK_MINUS then
            return -v
        end
        return v
    elseif n.kind == NodeKind.NODE_BINARY then
        local l = eval(n.left)
        local r = eval(n.right)
        local op = n.op
        if op == TokenType.TOK_PLUS then
            return l + r
        elseif op == TokenType.TOK_MINUS then
            return l - r
        elseif op == TokenType.TOK_MUL then
            return l * r
        elseif op == TokenType.TOK_DIV then
            if r == 0 then
                print("Error: Division by zero")
                return 0
            end
            return math.floor(l / r)
        elseif op == TokenType.TOK_POWER then
            return intPow(l, r)
        end
    end
    return 0
end

local function printInfix(n)
    if not n then return "" end

    if n.kind == NodeKind.NODE_NUM then
        return tostring(n.val)
    elseif n.kind == NodeKind.NODE_UNARY then
        return string.format("(-%s)", printInfix(n.left))
    elseif n.kind == NodeKind.NODE_BINARY then
        local opStr = "?"
        local op = n.op
        if op == TokenType.TOK_PLUS then opStr = "+"
        elseif op == TokenType.TOK_MINUS then opStr = "-"
        elseif op == TokenType.TOK_MUL then opStr = "*"
        elseif op == TokenType.TOK_DIV then opStr = "/"
        elseif op == TokenType.TOK_POWER then opStr = "^"
        end
        return string.format("(%s %s %s)", printInfix(n.left), opStr, printInfix(n.right))
    end
    return ""
end

local function tokenize(s)
    local tokens = {}
    local i = 1
    local len = #s

    while i <= len do
        local ch = s:sub(i, i)
        if ch == " " or ch == "\t" or ch == "\n" then
            i = i + 1
        elseif ch >= "0" and ch <= "9" then
            local num = 0
            while i <= len and s:sub(i, i) >= "0" and s:sub(i, i) <= "9" do
                num = num * 10 + (string.byte(s, i) - string.byte("0"))
                i = i + 1
            end
            table.insert(tokens, { tokType = TokenType.TOK_INT, val = num })
        else
            if ch == "+" then table.insert(tokens, { tokType = TokenType.TOK_PLUS, val = 0 })
            elseif ch == "-" then table.insert(tokens, { tokType = TokenType.TOK_MINUS, val = 0 })
            elseif ch == "*" then table.insert(tokens, { tokType = TokenType.TOK_MUL, val = 0 })
            elseif ch == "/" then table.insert(tokens, { tokType = TokenType.TOK_DIV, val = 0 })
            elseif ch == "^" then table.insert(tokens, { tokType = TokenType.TOK_POWER, val = 0 })
            elseif ch == "(" then table.insert(tokens, { tokType = TokenType.TOK_LPAREN, val = 0 })
            elseif ch == ")" then table.insert(tokens, { tokType = TokenType.TOK_RPAREN, val = 0 })
            end
            i = i + 1
        end
    end

    table.insert(tokens, { tokType = TokenType.TOK_EOF, val = 0 })
    return tokens
end

local function parseAndRun(exprStr)
    local tokens = tokenize(exprStr)
    local parser = Parser.new(tokens)
    local ast = parser:parseExpr(0)
    local result = eval(ast)
    local treeStr = printInfix(ast)
    print(string.format("Expression: %s", exprStr))
    print(string.format("  AST:    %s", treeStr))
    print(string.format("  Result: %d", result))
end

local function main()
    print("=== Pratt Parser (Top-Down Operator Precedence) ===")

    -- 1. Standard precedence
    parseAndRun("3 + 4 * 2")
    print("")

    -- 2. Right-associative exponentiation: 2 ^ 3 ^ 2 = 512
    parseAndRun("2 ^ 3 ^ 2")
    print("")

    -- 3. Unary minus and grouping: -5 + (10 - 2) * 3 = 19
    parseAndRun("-5 + (10 - 2) * 3")
    print("")

    print("Pratt parsing and evaluation completed successfully.")
end

main()
