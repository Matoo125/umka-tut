-- 47_bytecode_assembler.lua - Two-Pass Bytecode Assembler & Disassembler in Lua

local Opcode = {
    OP_PUSH  = 1,
    OP_ADD   = 2,
    OP_SUB   = 3,
    OP_SWAP  = 4,
    OP_DUP   = 5,
    OP_JMP   = 6,
    OP_JNZ   = 7,
    OP_PRINT = 8,
    OP_HALT  = 9
}

local function opcodeName(op)
    if op == Opcode.OP_PUSH  then return "PUSH "
    elseif op == Opcode.OP_ADD   then return "ADD  "
    elseif op == Opcode.OP_SUB   then return "SUB  "
    elseif op == Opcode.OP_SWAP  then return "SWAP "
    elseif op == Opcode.OP_DUP   then return "DUP  "
    elseif op == Opcode.OP_JMP   then return "JMP  "
    elseif op == Opcode.OP_JNZ   then return "JNZ  "
    elseif op == Opcode.OP_PRINT then return "PRINT"
    elseif op == Opcode.OP_HALT  then return "HALT "
    end
    return "UNKNOWN"
end

local function parseOpcode(mnemonic)
    if mnemonic == "PUSH"  then return Opcode.OP_PUSH
    elseif mnemonic == "ADD"   then return Opcode.OP_ADD
    elseif mnemonic == "SUB"   then return Opcode.OP_SUB
    elseif mnemonic == "SWAP"  then return Opcode.OP_SWAP
    elseif mnemonic == "DUP"   then return Opcode.OP_DUP
    elseif mnemonic == "JMP"   then return Opcode.OP_JMP
    elseif mnemonic == "JNZ"   then return Opcode.OP_JNZ
    elseif mnemonic == "PRINT" then return Opcode.OP_PRINT
    elseif mnemonic == "HALT"  then return Opcode.OP_HALT
    end
    return Opcode.OP_HALT
end

local function splitTokens(line)
    local toks = {}
    for token in line:gmatch("%S+") do
        table.insert(toks, token)
    end
    return toks
end

local function isLabelDef(tok)
    return #tok > 1 and tok:sub(-1) == ":"
end

local function main()
    print("=== Bytecode Assembler & Disassembler ===")
    print("Assembly Source:")

    local source = {
        "  PUSH 10",
        "  PUSH 0",
        "loop:",
        "  SWAP",
        "  DUP",
        "  JNZ body",
        "  JMP exit",
        "body:",
        "  PUSH 1",
        "  SUB",
        "  SWAP",
        "  PUSH 2",
        "  ADD",
        "  JMP loop",
        "exit:",
        "  SWAP",
        "  PRINT",
        "  HALT"
    }

    for _, line in ipairs(source) do
        print(line)
    end
    print("")

    -- Pass 1: Build Symbol Table for Labels
    local labels = {}
    local labelOrder = {}
    local instrCount = 0

    for _, line in ipairs(source) do
        local toks = splitTokens(line)
        if #toks > 0 then
            local first = toks[1]
            if isLabelDef(first) then
                local labelName = first:sub(1, -2)
                labels[labelName] = instrCount
                table.insert(labelOrder, { name = labelName, offset = instrCount })
            else
                instrCount = instrCount + 1
            end
        end
    end

    print("Pass 1: Symbol Table Generated:")
    for _, entry in ipairs(labelOrder) do
        print(string.format("  '%s' -> offset %d", entry.name, entry.offset))
    end
    print("")

    -- Pass 2: Assemble bytecode instructions
    local code = {}
    for _, line in ipairs(source) do
        local toks = splitTokens(line)
        if #toks > 0 then
            local first = toks[1]
            if not isLabelDef(first) then
                local op = parseOpcode(first)
                local arg = 0

                if #toks > 1 then
                    local argTok = toks[2]
                    if tonumber(argTok) then
                        arg = tonumber(argTok)
                    else
                        local offset = labels[argTok]
                        if offset ~= nil then
                            arg = offset
                        else
                            print(string.format("Error: Unresolved label %s", argTok))
                        end
                    end
                end

                table.insert(code, { op = op, arg = arg })
            end
        end
    end

    print(string.format("Pass 2: Assembled %d Instructions (%d bytes)\n", #code, #code * 2))

    -- Disassembly
    print("Disassembly of Binary Bytecode:")
    for i = 1, #code do
        local inst = code[i]
        print(string.format("  %04d: %s %d", i - 1, opcodeName(inst.op), inst.arg))
    end
    print("")

    print("Assembly and disassembly roundtrip completed successfully.")
end

main()
