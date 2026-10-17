-- =============================================================================
-- Exercise 27: Event Bus & Pub-Sub Dispatcher
-- Concepts: First-class functions, callback arrays, event registry tables,
--           object methods, and decoupled publish/subscribe architecture.
-- Run:      lua 27_event_bus.lua
-- =============================================================================

local EventBus = {}
EventBus.__index = EventBus

function EventBus.new()
    return setmetatable({ handlers = {} }, EventBus)
end

-- Register a callback function for a specific event topic
function EventBus:on(event, handler)
    if not self.handlers[event] then
        self.handlers[event] = {}
    end
    table.insert(self.handlers[event], handler)
end

-- Broadcast an event topic and payload to all registered listeners
function EventBus:emit(event, data)
    local list = self.handlers[event]
    if list then
        for _, h in ipairs(list) do
            h(event, data)
        end
    end
end

-- --- Subscriber Handlers ---

local function onUserLogin(event, data)
    print(string.format("[Auth Service] User logged in: %s", data))
end

local function onAuditLog(event, data)
    print(string.format("[Audit Log] Event '%s' triggered with payload: '%s'", event, data))
end

local function onUserLogout(event, data)
    print(string.format("[Auth Service] User logged out: %s", data))
end

local function main()
    local bus = EventBus.new()

    -- Register multiple subscribers to event topics
    bus:on("user:login", onUserLogin)
    bus:on("user:login", onAuditLog)
    bus:on("user:logout", onUserLogout)
    bus:on("user:logout", onAuditLog)

    -- Publish events
    print("=== Dispatching Events ===")
    bus:emit("user:login", "alice")
    bus:emit("user:logout", "alice")
end

main()
