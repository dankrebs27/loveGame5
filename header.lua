local header = {}
local runReference = nil
local startTime = nil
local levelsCleared = 0 -- Tracks completed levels
local armourIcon = nil -- Store armour icon reference
local playerReference = nil

function header.init(run, player)
    runReference = run
    playerReference = player -- Store reference to player
    startTime = love.timer.getTime()
    levelsCleared = 0 -- Reset level count when a new run starts

    -- Load the armour icon
    armourIcon = love.graphics.newImage("Assets/Images/ArmourIcon.png")
end

function header.incrementLevel()
    levelsCleared = levelsCleared + 1
end

function header.getElapsedTime()
    if not startTime then return "00:00" end
    local elapsed = math.floor(love.timer.getTime() - startTime)
    local minutes = math.floor(elapsed / 60)
    local seconds = elapsed % 60
    return string.format("%02d:%02d", minutes, seconds)
end

function header.draw(gameState, platformInventory)
    if gameState == "map" or gameState == "play" then
        love.graphics.setColor(0.2, 0.2, 0.2) -- Dark gray background
        love.graphics.rectangle("fill", 0, 0, 800, 40)

        -- Position variables for elements
        local startX = 10
        local boxSize = 25
        local spacing = 60

        -- Draw Base Platform Box (Red)
        love.graphics.setColor(0.8, 0.1, 0.1) -- Red
        love.graphics.rectangle("fill", startX, 7, boxSize, boxSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(platformInventory.base, startX + boxSize + 5, 12, 30, "left")

        -- Draw Power Platform Box (Purple)
        love.graphics.setColor(0.6, 0, 0.8) -- Purple
        love.graphics.rectangle("fill", startX + spacing, 7, boxSize, boxSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(platformInventory.power, startX + spacing + boxSize + 5, 12, 30, "left")

        -- Draw Ice Platform Box (Blue)
        love.graphics.setColor(0.1, 0.6, 1) -- Blue
        love.graphics.rectangle("fill", startX + (spacing * 2), 7, boxSize, boxSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(platformInventory.ice, startX + (spacing * 2) + boxSize + 5, 12, 30, "left")

        if playerReference then
            local armourCount = playerReference.getArmour()
            if armourCount > 0 then
                local armourX = startX + (spacing * 3)
                love.graphics.setColor(1, 1, 1) -- Full color
                local iconSize = 20 -- New fixed size for consistency
                local scaleFactor = iconSize / armourIcon:getWidth() -- Scale based on width
                love.graphics.draw(armourIcon, armourX, 7, 0, scaleFactor, scaleFactor)
        
                -- Draw armour count beside the icon
                love.graphics.printf(armourCount, armourX + boxSize, 12, 30, "left")
            end
        end

        -- Draw Level in the center
        love.graphics.printf("Level: " .. levelsCleared, 350, 10, 100, "center")

        -- Draw Time Elapsed next to Level
        love.graphics.printf("Time: " .. header.getElapsedTime(), 470, 10, 100, "left")

        -- Draw Run Seed (Adjusted to fit within screen bounds)
        if runReference and runReference.seed then
            love.graphics.printf("Seed: " .. runReference.seed, 580, 10, 200, "left")
        end
    end
end


return header
