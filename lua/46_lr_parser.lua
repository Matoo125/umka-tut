-- 46_lr_parser.lua - LR Shift-Reduce Parser State Machine in Lua

local ActionType = {
    ACT_SHIFT  = 1,
    ACT_REDUCE = 2,
    ACT_ACCEPT = 3,
    ACT_ERROR  = 4
}

local function getAction(state, tok)
    if state == 0 then
        if tok == "id" then
            return { actType = ActionType.ACT_SHIFT, val = 2 }
        end
    elseif state == 1 then
        if tok == "+" then
            return { actType = ActionType.ACT_SHIFT, val = 4 }
        elseif tok == "$" then
            return { actType = ActionType.ACT_ACCEPT, val = 0 }
        end
    elseif state == 2 then
        return { actType = ActionType.ACT_REDUCE, val = 3 }
    elseif state == 3 then
        return { actType = ActionType.ACT_REDUCE, val = 2 }
    elseif state == 4 then
        if tok == "id" then
            return { actType = ActionType.ACT_SHIFT, val = 2 }
        end
    elseif state == 5 then
        return { actType = ActionType.ACT_REDUCE, val = 1 }
    end

    return { actType = ActionType.ACT_ERROR, val = 0 }
end

local function getGoto(state, nonTerm)
    if state == 0 then
        if nonTerm == "E" then return 1 end
        if nonTerm == "T" then return 3 end
    elseif state == 4 then
        if nonTerm == "T" then return 5 end
    end
    return -1
end

local function formatStateStack(states)
    local s = "[ "
    for i = 1, #states do
        s = s .. string.format("%d ", states[i])
    end
    s = s .. "]"
    return s
end

local function formatSymbolStack(syms)
    local s = "[ "
    for i = 1, #syms do
        s = s .. syms[i] .. " "
    end
    s = s .. "]"
    return s
end

local function main()
    print("=== LR Shift-Reduce Parser State Machine ===")
    print("Grammar Rules:")
    print("  (1) E -> E + T")
    print("  (2) E -> T")
    print("  (3) T -> id\n")

    local rules = {
        [0] = { lhs = "S'", rhsLen = 1, desc = "S' -> E" },
        [1] = { lhs = "E",  rhsLen = 3, desc = "E -> E + T" },
        [2] = { lhs = "E",  rhsLen = 1, desc = "E -> T" },
        [3] = { lhs = "T",  rhsLen = 1, desc = "T -> id" }
    }

    local inputTokens = { "id", "+", "id", "+", "id", "$" }

    print("Parsing Input: id + id + id\n")
    print(string.format("%-4s  %-16s %-20s %s", "Step", "State Stack", "Symbol Stack", "Action"))
    print("------------------------------------------------------------")

    local stateStack = { 0 }
    local symbolStack = { "$" }
    local ip = 1
    local step = 0
    local running = true
    local success = false

    while running do
        local currState = stateStack[#stateStack]
        local currTok = inputTokens[ip]
        local act = getAction(currState, currTok)

        local stateStr = formatStateStack(stateStack)
        local symStr = formatSymbolStack(symbolStack)

        if act.actType == ActionType.ACT_SHIFT then
            local actDesc = string.format("Shift %d", act.val)
            print(string.format("%2d    %-16s %-20s %s", step, stateStr, symStr, actDesc))
            table.insert(symbolStack, currTok)
            table.insert(stateStack, act.val)
            ip = ip + 1

        elseif act.actType == ActionType.ACT_REDUCE then
            local ruleIdx = act.val
            local r = rules[ruleIdx]
            local actDesc = string.format("Reduce (%d) %s", ruleIdx, r.desc)
            print(string.format("%2d    %-16s %-20s %s", step, stateStr, symStr, actDesc))

            -- Pop rhsLen symbols and states
            for _ = 1, r.rhsLen do
                table.remove(symbolStack)
                table.remove(stateStack)
            end

            -- Consult GOTO table
            local topState = stateStack[#stateStack]
            local nextState = getGoto(topState, r.lhs)
            if nextState == -1 then
                print(string.format("Error: GOTO state invalid for (%d, %s)", topState, r.lhs))
                running = false
            else
                table.insert(symbolStack, r.lhs)
                table.insert(stateStack, nextState)
            end

        elseif act.actType == ActionType.ACT_ACCEPT then
            print(string.format("%2d    %-16s %-20s %s", step, stateStr, symStr, "Accept"))
            running = false
            success = true

        elseif act.actType == ActionType.ACT_ERROR then
            print(string.format("%2d    %-16s %-20s %s", step, stateStr, symStr, "Syntax Error"))
            running = false
        end

        step = step + 1
    end

    print("")
    if success then
        print("Parse Result: SUCCESS (Input fully accepted by grammar)")
    else
        print("Parse Result: FAILED")
    end
end

main()
