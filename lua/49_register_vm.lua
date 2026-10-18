-- lua/49_register_vm.lua
-- Exercise 49: Register-Based Virtual Machine
--
-- Demonstrates a 3-address register virtual machine with 16 registers,
-- instruction decoding, disassembly, and iterative Fibonacci calculation.

local OP_HALT  = 0
local OP_LOADI = 1
local OP_MOV   = 2
local OP_ADD   = 3
local OP_SUB   = 4
local OP_MUL   = 5
local OP_CMP   = 6
local OP_JMP   = 7
local OP_JEQ   = 8
local OP_JLT   = 9
local OP_PRINT = 10

local function opName(op)
    if op == OP_HALT  then return "HALT"  end
    if op == OP_LOADI then return "LOADI" end
    if op == OP_MOV   then return "MOV"   end
    if op == OP_ADD   then return "ADD"   end
    if op == OP_SUB   then return "SUB"   end
    if op == OP_MUL   then return "MUL"   end
    if op == OP_CMP   then return "CMP"   end
    if op == OP_JMP   then return "JMP"   end
    if op == OP_JEQ   then return "JEQ"   end
    if op == OP_JLT   then return "JLT"   end
    if op == OP_PRINT then return "PRINT" end
    return "UNKNOWN"
end

local function disassemble(code)
    for i = 0, #code - 1 do
        local inst = code[i + 1]
        local name = opName(inst.op)
        if inst.op == OP_HALT then
            io.write(string.format(" %2d: %s\n", i, name))
        elseif inst.op == OP_LOADI then
            io.write(string.format(" %2d: %-6s R%d, %d\n", i, name, inst.rd, inst.imm))
        elseif inst.op == OP_MOV then
            io.write(string.format(" %2d: %-6s R%d, R%d\n", i, name, inst.rd, inst.rs1))
        elseif inst.op == OP_ADD or inst.op == OP_SUB or inst.op == OP_MUL then
            io.write(string.format(" %2d: %-6s R%d, R%d, R%d\n", i, name, inst.rd, inst.rs1, inst.rs2))
        elseif inst.op == OP_CMP then
            io.write(string.format(" %2d: %-6s R%d, R%d\n", i, name, inst.rs1, inst.rs2))
        elseif inst.op == OP_JMP or inst.op == OP_JEQ or inst.op == OP_JLT then
            io.write(string.format(" %2d: %-6s %d\n", i, name, inst.imm))
        elseif inst.op == OP_PRINT then
            io.write(string.format(" %2d: %-6s R%d\n", i, name, inst.rs1))
        end
    end
end

local function createVM()
    local vm = {
        regs = {},
        pc = 0,
        cmpLt = false,
        cmpEq = false,
        cycles = 0,
        running = false
    }
    for i = 0, 15 do
        vm.regs[i] = 0
    end
    return vm
end

local function runVM(vm, code)
    vm.running = true
    while vm.running do
        if vm.pc < 0 or vm.pc >= #code then
            io.write(string.format("Error: PC %d out of bounds\n", vm.pc))
            vm.running = false
            break
        end

        local inst = code[vm.pc + 1]
        vm.pc = vm.pc + 1
        vm.cycles = vm.cycles + 1

        local op = inst.op
        if op == OP_HALT then
            vm.running = false
        elseif op == OP_LOADI then
            vm.regs[inst.rd] = inst.imm
        elseif op == OP_MOV then
            vm.regs[inst.rd] = vm.regs[inst.rs1]
        elseif op == OP_ADD then
            vm.regs[inst.rd] = vm.regs[inst.rs1] + vm.regs[inst.rs2]
        elseif op == OP_SUB then
            vm.regs[inst.rd] = vm.regs[inst.rs1] - vm.regs[inst.rs2]
        elseif op == OP_MUL then
            vm.regs[inst.rd] = vm.regs[inst.rs1] * vm.regs[inst.rs2]
        elseif op == OP_CMP then
            vm.cmpLt = vm.regs[inst.rs1] < vm.regs[inst.rs2]
            vm.cmpEq = vm.regs[inst.rs1] == vm.regs[inst.rs2]
        elseif op == OP_JMP then
            vm.pc = inst.imm
        elseif op == OP_JEQ then
            if vm.cmpEq then
                vm.pc = inst.imm
            end
        elseif op == OP_JLT then
            if vm.cmpLt then
                vm.pc = inst.imm
            end
        elseif op == OP_PRINT then
            io.write(string.format("[OUTPUT] %d\n", vm.regs[inst.rs1]))
        end
    end
end

local function main()
    io.write("=== Register-Based Virtual Machine ===\n")
    io.write("Registers: 16 (R0..R15)\n")
    io.write("Program: Iterative Fibonacci(10)\n\n")

    local code = {
        {op = OP_LOADI, rd = 0, imm = 0},
        {op = OP_LOADI, rd = 1, imm = 1},
        {op = OP_LOADI, rd = 2, imm = 10},
        {op = OP_LOADI, rd = 3, imm = 0},
        {op = OP_CMP,   rs1 = 3, rs2 = 2},
        {op = OP_JEQ,   imm = 12},
        {op = OP_ADD,   rd = 4, rs1 = 0, rs2 = 1},
        {op = OP_MOV,   rd = 0, rs1 = 1},
        {op = OP_MOV,   rd = 1, rs1 = 4},
        {op = OP_LOADI, rd = 5, imm = 1},
        {op = OP_ADD,   rd = 3, rs1 = 3, rs2 = 5},
        {op = OP_JMP,   imm = 4},
        {op = OP_PRINT, rs1 = 0},
        {op = OP_HALT}
    }

    io.write("Disassembly:\n")
    disassemble(code)

    io.write("\nExecution:\n")
    local vm = createVM()
    runVM(vm, code)

    io.write(string.format("Cycles executed: %d\n", vm.cycles))
    io.write("Final registers:\n")
    io.write(string.format("  R0: %d\n", vm.regs[0]))
    io.write(string.format("  R1: %d\n", vm.regs[1]))
    io.write(string.format("  R2: %d\n", vm.regs[2]))
    io.write(string.format("  R3: %d\n", vm.regs[3]))
end

main()
