-- =============================================================================
-- Exercise 11: Dialogue Engine
-- Concepts: State machines, node branching, conditional choices, endings
-- Run:      printf '1\n1\n1\n1\n1\n' | lua 11_dialogue.lua
-- =============================================================================

local nodeIntro      = 1
local nodeTraveler   = 2
local nodeRude       = 3
local nodeNameLena   = 4
local nodeRefuseName = 5
local nodeGate       = 6
local nodeCell       = 7
local nodeMarket     = 8
local nodeEnd        = 9

local function printState(trust, hasPass)
    io.write(string.format("\n[trust=%d, pass=%s]\n\n", trust, tostring(hasPass)))
end

local function showNode(node, trust, hasPass)
    if node == nodeIntro then
        io.write("Guard: Halt. Why are you here?\n")
        io.write("1. I'm a traveler.\n")
        io.write("2. None of your business.\n")
    elseif node == nodeTraveler then
        io.write("Guard: Then state your name.\n")
        io.write("1. Lena.\n")
        io.write("2. I'd rather not.\n")
    elseif node == nodeRude then
        io.write("Guard: That's the wrong tone for this gate.\n")
        io.write("1. Apologize.\n")
        io.write("2. Double down.\n")
    elseif node == nodeNameLena then
        io.write("Guard: Lena? I know that name. What is your business in the city?\n")
        io.write("1. Trade.\n")
        if hasPass then
            io.write("2. Show the merchant pass.\n")
        else
            io.write("2. Admit you have no papers.\n")
        end
    elseif node == nodeRefuseName then
        io.write("Guard: No name, no entry.\n")
        io.write("1. Leave peacefully.\n")
        io.write("2. Argue.\n")
    elseif node == nodeGate then
        io.write("Guard: Everything seems in order. You may enter.\n")
        io.write("1. Enter the city.\n")
    elseif node == nodeCell then
        io.write("Guard: I've heard enough. Take a night in the cell.\n")
        io.write("1. Accept your fate.\n")
    elseif node == nodeMarket then
        io.write("Narrator: You step into the market as the city wakes around you.\n")
        io.write("1. Finish.\n")
    elseif node == nodeEnd then
        if trust >= 2 then
            io.write("Ending: You earned a warm welcome.\n")
        elseif hasPass then
            io.write("Ending: Papers opened the gate, if not hearts.\n")
        elseif trust <= -1 then
            io.write("Ending: Your journey stops at the city jail.\n")
        else
            io.write("Ending: You leave the gate behind and try elsewhere.\n")
        end
    end
end

local function maxChoice(node)
    if node == nodeGate or node == nodeCell or node == nodeMarket then
        return 1
    end
    return 2
end

local function applyChoice(node, choice, trust, hasPass)
    if node == nodeIntro then
        if choice == 1 then
            return nodeTraveler, trust + 1, hasPass
        end
        return nodeRude, trust - 1, hasPass
    end

    if node == nodeTraveler then
        if choice == 1 then
            return nodeNameLena, trust + 1, true
        end
        return nodeRefuseName, trust - 1, hasPass
    end

    if node == nodeRude then
        if choice == 1 then
            return nodeTraveler, trust + 1, hasPass
        end
        return nodeCell, trust - 1, hasPass
    end

    if node == nodeNameLena then
        if choice == 1 then
            return nodeGate, trust, hasPass
        end
        if hasPass then
            return nodeGate, trust + 1, hasPass
        end
        return nodeRefuseName, trust - 1, hasPass
    end

    if node == nodeRefuseName then
        if choice == 1 then
            return nodeEnd, trust, hasPass
        end
        return nodeCell, trust - 1, hasPass
    end

    if node == nodeGate then
        return nodeMarket, trust, hasPass
    end

    if node == nodeCell or node == nodeMarket then
        return nodeEnd, trust, hasPass
    end

    return nodeEnd, trust, hasPass
end

local function readChoice(limit)
    local choice = 0
    while choice < 1 or choice > limit do
        io.write("Choose: ")
        choice = io.read("*n") or 0
        if choice < 1 or choice > limit then
            io.write(string.format("Invalid choice. Enter a number from 1 to %d.\n", limit))
        end
    end
    return choice
end

local function main()
    local node = nodeIntro
    local trust = 0
    local hasPass = false
    local running = true

    io.write("City Gate\n")
    io.write("---------\n")

    while running do
        printState(trust, hasPass)
        showNode(node, trust, hasPass)

        if node == nodeEnd then
            running = false
        else
            local choice = readChoice(maxChoice(node))
            node, trust, hasPass = applyChoice(node, choice, trust, hasPass)
        end
    end
end

main()
