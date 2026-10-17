-- 38_stack_vm.lua - Stack-Based Bytecode Virtual Machine in Lua

local Opcode = {
    OP_PUSH   = 1,
    OP_ADD    = 2,
    OP_SUB    = 3,
    OP_MUL    = 4,
    OP_DIV    = 5,
    OP_CMP_EQ = 6,
    OP_CMP_LT = 7,
    OP_JMP    = 8,
    OP_JNZ    = 9,
    OP_DUP    = 10,
    OP_OVER   = 11,
    OP_SWAP   = 12,
    OP_DROP   = 13,
    OP_PRINT  = 14,
    OP_HALT   = 15
}

local VM = {}
VM.__index = VM

function VM.new()
    local self = setmetatable({}, VM)
    self.stack = {}
    self.sp = 0
    self.ip = 1
    self.running = false
    return self
end

function VM:push(val)
    if self.sp >= 128 then
        print("Error: Stack overflow")
        self.running = false
        return
    end
    self.sp = self.sp + 1
    self.stack[self.sp] = val
end

function VM:pop()
    if self.sp <= 0 then
        print("Error: Stack underflow")
        self.running = false
        return 0
    end
    local val = self.stack[self.sp]
    self.sp = self.sp - 1
    return val
end

function VM:run(program)
    self.sp = 0
    self.ip = 1
    self.running = true

    while self.running and self.ip >= 1 and self.ip <= #program do
        local inst = program[self.ip]
        self.ip = self.ip + 1

        local op = inst.op
        if op == Opcode.OP_PUSH then
            self:push(inst.arg)

        elseif op == Opcode.OP_ADD then
            local b = self:pop()
            local a = self:pop()
            self:push(a + b)

        elseif op == Opcode.OP_SUB then
            local b = self:pop()
            local a = self:pop()
            self:push(a - b)

        elseif op == Opcode.OP_MUL then
            local b = self:pop()
            local a = self:pop()
            self:push(a * b)

        elseif op == Opcode.OP_DIV then
            local b = self:pop()
            local a = self:pop()
            if b == 0 then
                print("Error: Division by zero")
                self.running = false
            else
                self:push(math.floor(a / b))
            end

        elseif op == Opcode.OP_CMP_EQ then
            local b = self:pop()
            local a = self:pop()
            self:push(a == b and 1 or 0)

        elseif op == Opcode.OP_CMP_LT then
            local b = self:pop()
            local a = self:pop()
            self:push(a < b and 1 or 0)

        elseif op == Opcode.OP_JMP then
            -- Convert 0-based target index from bytecode spec to 1-based Lua index
            self.ip = inst.arg + 1

        elseif op == Opcode.OP_JNZ then
            local cond = self:pop()
            if cond ~= 0 then
                -- Convert 0-based target index to 1-based Lua index
                self.ip = inst.arg + 1
            end

        elseif op == Opcode.OP_DUP then
            local val = self:pop()
            self:push(val)
            self:push(val)

        elseif op == Opcode.OP_OVER then
            local b = self:pop()
            local a = self:pop()
            self:push(a)
            self:push(b)
            self:push(a)

        elseif op == Opcode.OP_SWAP then
            local b = self:pop()
            local a = self:pop()
            self:push(b)
            self:push(a)

        elseif op == Opcode.OP_DROP then
            self:pop()

        elseif op == Opcode.OP_PRINT then
            local val = self:pop()
            print(string.format("Result: %d", val))

        elseif op == Opcode.OP_HALT then
            self.running = false

        else
            print(string.format("Error: Unknown opcode %s", tostring(op)))
            self.running = false
        end
    end
end

local function main()
    print("=== Stack-Based Bytecode VM ===")

    -- Program 1: Arithmetic Expression Evaluation
    -- Computes: (7 + 3) * 4 - 5 = 35
    print("Running Program 1: (7 + 3) * 4 - 5")
    local p1 = {
        { op = Opcode.OP_PUSH,  arg = 7 },
        { op = Opcode.OP_PUSH,  arg = 3 },
        { op = Opcode.OP_ADD,   arg = 0 },
        { op = Opcode.OP_PUSH,  arg = 4 },
        { op = Opcode.OP_MUL,   arg = 0 },
        { op = Opcode.OP_PUSH,  arg = 5 },
        { op = Opcode.OP_SUB,   arg = 0 },
        { op = Opcode.OP_PRINT, arg = 0 },
        { op = Opcode.OP_HALT,  arg = 0 }
    }

    local vm = VM.new()
    vm:run(p1)

    -- Program 2: Triangular sum of 5: 5 + 4 + 3 + 2 + 1 = 15
    print("Running Program 2: Triangular sum of 5")
    local p2 = {
        { op = Opcode.OP_PUSH,  arg = 0 },
        { op = Opcode.OP_PUSH,  arg = 5 },
        { op = Opcode.OP_DUP,   arg = 0 },
        { op = Opcode.OP_JNZ,   arg = 5 },
        { op = Opcode.OP_JMP,   arg = 12 },
        { op = Opcode.OP_SWAP,  arg = 0 },
        { op = Opcode.OP_OVER,  arg = 0 },
        { op = Opcode.OP_ADD,   arg = 0 },
        { op = Opcode.OP_SWAP,  arg = 0 },
        { op = Opcode.OP_PUSH,  arg = 1 },
        { op = Opcode.OP_SUB,   arg = 0 },
        { op = Opcode.OP_JMP,   arg = 2 },
        { op = Opcode.OP_DROP,  arg = 0 },
        { op = Opcode.OP_PRINT, arg = 0 },
        { op = Opcode.OP_HALT,  arg = 0 }
    }

    vm:run(p2)
    print("VM execution completed successfully.")
end

main()
