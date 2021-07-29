local sides = require('Mocks.sides')

RealX = 0
RealY = 0
RealZ = 0
RealHeading = sides.forward

local robot = { }

-- Use
function robot.use(direction)
    robot.logVerbose("use")
    return true
end

function robot.useDown(direction)
    robot.logVerbose("use done")
    return true
end

-- Move
function robot.forward()
    if (RealHeading == sides.posx) then
        RealX = RealX + 1
    elseif (RealHeading == sides.negx) then
        RealX = RealX - 1
    elseif (RealHeading == sides.posz) then
        RealZ = RealZ + 1
    elseif (RealHeading == sides.negz) then
        RealZ = RealZ - 1
    end
    robot.logVerbose("move forward, now at " .. robot.getLocation())
    return true
end

-- Turn
function robot.turnRight()
    if (RealHeading == sides.forward) then
        RealHeading = sides.right
    elseif (RealHeading == sides.right) then
        RealHeading = sides.back
    elseif (RealHeading == sides.back) then
        RealHeading = sides.left
    elseif (RealHeading == sides.left) then
        RealHeading = sides.forward
    end
    robot.logVerbose("turn right, now at " .. robot.getLocation())
end

function robot.turnLeft()
    if (RealHeading == sides.forward) then
        RealHeading = sides.left
    elseif (RealHeading == sides.left) then
        RealHeading = sides.back
    elseif (RealHeading == sides.back) then
        RealHeading = sides.right
    elseif (RealHeading == sides.right) then
        RealHeading = sides.forward
    end
    robot.logVerbose("turn left, now at " .. robot.getLocation())
end

-- Location Debug
function robot.getLocation()
    return RealX .. ", " .. RealY .. ", " .. RealZ .. ", " .. sides:sideName(RealHeading)
end

function robot.logVerbose(message)
    print("ROBOT API - ", message)
end

return robot