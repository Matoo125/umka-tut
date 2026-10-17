-- =============================================================================
-- Exercise 13: To-Do List Manager
-- Concepts: Tables as lists and records, table.insert, table.remove, linear search
-- Run:      lua 13_todo_list.lua
-- =============================================================================

local function printTasks(tasks)
    if #tasks == 0 then
        print("Task list is empty.")
        return
    end

    print("Tasks:")
    for _, t in ipairs(tasks) do
        local status = t.done and "[x]" or "[ ]"
        print(string.format("%d. %s %s", t.id, status, t.title))
    end
end

local function findTaskIndex(tasks, id)
    for i, t in ipairs(tasks) do
        if t.id == id then
            return i
        end
    end
    return nil
end

local function main()
    local tasks = {}
    local nextId = 1
    local running = true

    print("To-Do List Manager")
    print("Commands: 1 = Add, 2 = Complete, 3 = Delete, 4 = List, 0 = Exit")

    while running do
        io.write("Command: ")
        local cmd = io.read("*n")
        if not cmd then
            break
        end

        if cmd == 0 then
            print("Goodbye!")
            running = false
        elseif cmd == 1 then
            io.write("Task title: ")
            local title = io.read("*l")
            if not title or title == "" then
                title = io.read("*l")
            end
            table.insert(tasks, { id = nextId, title = title, done = false })
            print(string.format("Added task %d: %s", nextId, title))
            nextId = nextId + 1
        elseif cmd == 2 then
            io.write("Task ID to complete: ")
            local id = io.read("*n")
            local idx = findTaskIndex(tasks, id)
            if idx then
                tasks[idx].done = true
                print(string.format("Task %d marked as completed.", id))
            else
                print(string.format("Task %d not found.", id))
            end
        elseif cmd == 3 then
            io.write("Task ID to delete: ")
            local id = io.read("*n")
            local idx = findTaskIndex(tasks, id)
            if idx then
                table.remove(tasks, idx)
                print(string.format("Task %d deleted.", id))
            else
                print(string.format("Task %d not found.", id))
            end
        elseif cmd == 4 then
            printTasks(tasks)
        else
            print(string.format("Unknown command %d. Choose between 0 and 4.", cmd))
        end
    end
end

main()
