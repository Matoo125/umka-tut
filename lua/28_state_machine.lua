-- =============================================================================
-- Exercise 28: Finite State Machine (FSM)
-- Concepts: Enumeration tables, state transition validation, branching
--           handlers, object methods, and deterministic event-driven workflows.
-- Run:      lua 28_state_machine.lua
-- =============================================================================

local State = {
    Idle = 1,
    Connecting = 2,
    Connected = 3,
    Disconnected = 4
}

local Event = {
    Connect = 1,
    Success = 2,
    Timeout = 3,
    Disconnect = 4,
    Reset = 5
}

local StateNames = {
    [State.Idle] = "Idle",
    [State.Connecting] = "Connecting",
    [State.Connected] = "Connected",
    [State.Disconnected] = "Disconnected"
}

local EventNames = {
    [Event.Connect] = "Connect",
    [Event.Success] = "Success",
    [Event.Timeout] = "Timeout",
    [Event.Disconnect] = "Disconnect",
    [Event.Reset] = "Reset"
}

local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(initialState)
    return setmetatable({ current = initialState or State.Idle }, StateMachine)
end

-- Process an incoming event and execute state transition if valid
function StateMachine:handle(e)
    local prevState = self.current
    if self.current == State.Idle then
        if e == Event.Connect then
            self.current = State.Connecting
        end
    elseif self.current == State.Connecting then
        if e == Event.Success then
            self.current = State.Connected
        elseif e == Event.Timeout then
            self.current = State.Disconnected
        end
    elseif self.current == State.Connected then
        if e == Event.Disconnect then
            self.current = State.Disconnected
        end
    elseif self.current == State.Disconnected then
        if e == Event.Reset then
            self.current = State.Idle
        end
    end

    if self.current ~= prevState then
        print(string.format("Transition: %s --(%s)--> %s", StateNames[prevState], EventNames[e], StateNames[self.current]))
        return true
    end
    print(string.format("Ignored:    %s --(%s)--> [Invalid in this state]", StateNames[prevState], EventNames[e]))
    return false
end

local function main()
    local fsm = StateMachine.new(State.Idle)

    print("=== Finite State Machine Simulation ===")
    print(string.format("Initial State: %s", StateNames[fsm.current]))

    fsm:handle(Event.Connect)
    fsm:handle(Event.Connect) -- Invalid when already connecting
    fsm:handle(Event.Success)
    fsm:handle(Event.Disconnect)
    fsm:handle(Event.Reset)
end

main()
