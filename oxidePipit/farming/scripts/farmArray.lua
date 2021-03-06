-- Farms an array of fields defined by x y pairs

-- Dependencies - OpenComputers
local packInj = require("oxidePipit.core.packageInjector")
local robot = packInj.require("robot", true)

-- Dependencies - Oxide Pipit
local navigation = require("oxidePipit.nav.navigation")

local rowForward = 5
local rowBack = -1
local colLeft = 0
local colRight = 4
if (not (... == nil)) then
    print("Reading")
    rowForward, rowBack, colLeft, colRight = ...
    rowForward = tonumber(rowForward)
    rowBack = tonumber(rowBack)
    colLeft = tonumber(colLeft)
    colRight = tonumber(colRight)
end

-- Output
print("Rows: " .. tostring(rowForward) .. " forward and " .. tostring(rowBack) .. " back")
print("Columns: " .. tostring(colLeft) .. " left and " .. tostring(colRight) .. " right")

local home = navigation:getHomeRef()

while true do 

    -- Navigate to start of the farm (ie bottom left)
    -- If needed, back up
    for row = 1, rowBack do
        navigation:moveBack(home)
    end
    -- If needed, move forward
    for row = rowBack, -1 do
        navigation:moveForward(home)
    end

    -- If needed, move Left
    for col = 1, colLeft do
        navigation:moveLeft(home)
    end
    -- If needed, move rightRef
    for col = colLeft, -1 do
        navigation:moveRight(home)
    end

    local totalCols = colLeft + colRight + 1
    local totalRows = rowForward + rowBack + 1

    local columnUp = true
    for column = 1, totalCols do
        for row = 2, totalRows do
            if (row == 2) then robot.useDown() end
            if (columnUp) then
                navigation:moveForward(home)
            else
                navigation:moveBack(home)
            end
            if (robot.detectDown()) then
                robot.useDown()
            end
        end

        columnUp = not columnUp
        if (not (column + 1 > totalCols)) then
            navigation:moveRight(home)
        end
    end

    navigation:returnToHome(home)
    
    for i = 1, 16 do
       robot.select(i)
       robot.dropDown() 
    end
    robot.select(1)

end
