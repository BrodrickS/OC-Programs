-- Farms an array of fields defined by x y pairs

-- Dependencies
local packInj = require("bsops.core.packageInjector")
local robot = packInj.require("robot", true)
local navigation = require("bsops.nav.navigation")

local rows = 5
local columns = 5
if (not (... == nil)) then
    rows, columns = ...
    rows = tonumber(rows)
    columns = tonumber(columns)
    print(rows, columns)
end

local home = navigation:getHomeRef()

while true do 

    navigation:moveForward(home)

    local columnUp = true
    for column = 1, columns do
        for row = 2, rows do
            if (row == 2) then robot.useDown() end
            if (columnUp) then
                navigation:moveForward(home)
            else
                navigation:moveBack(home)
            end
            robot.useDown()
        end

        columnUp = not columnUp
        if (not (column + 1 > columns)) then
            navigation:moveRight(home)
        end
    end

    navigation:returnToHome(home)
    
    for i = 1, 16 do
       robot.select(i)
       robot.dropDown() 
    end

end
