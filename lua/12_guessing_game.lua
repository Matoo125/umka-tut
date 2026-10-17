-- =============================================================================
-- Exercise 12: Guessing Game
-- Concepts: math.random, math.randomseed, os.time(), command line arguments (arg)
-- Run:      lua 12_guessing_game.lua [optional-target-for-testing]
-- =============================================================================

local function runGame(target)
    local guess = -1
    local attempts = 0

    print("Welcome to the Guessing Game!")
    print("I'm thinking of a number between 1 and 100.")
    print("Can you guess it?\n")

    while guess ~= target do
        io.write("Enter your guess: ")
        guess = io.read("*n")
        attempts = attempts + 1

        if guess < target then
            print("Too low! Try again.")
        elseif guess > target then
            print("Too high! Try again.")
        else
            print(string.format("Correct! You guessed the number in %d attempts.", attempts))
        end
    end
end

local function main()
    local target = 0
    if arg and arg[1] then
        target = tonumber(arg[1]) or 0
    end

    if target <= 0 then
        math.randomseed(os.time())
        target = math.random(1, 100)
    end

    runGame(target)
end

main()
