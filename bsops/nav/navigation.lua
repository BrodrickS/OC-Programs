-- Navigation Module
-- Handles more complex motion, homing, pathing, and relative movement

local packInj = require("bsops.core.packageInjector")
local robot = packInj.require("robot", true)
local sides = packInj.require("sides", true)
local computer = packInj.require("computer", true)

-- Singleton Declation
if (not Navigation == nil) then
    return Navigation
end

Navigation = { 
    xLoc = 0, -- Forward-Back Direction
    yLoc = 0, -- Up-Down Direction
    zLoc = 0, -- Left-Right Direction
    Heading = sides.forward, -- Rotation
    T = 10, -- Ticks to wait before reattempting motion
}

-- Get a string that represents this current location and heading
function Navigation:getHomeRef()
    local home = { X = self.xLoc, Y = self.yLoc, Z = self.zLoc, R = self.Heading }
    return home
end

function Navigation.getOriginRef()
    local origin = { X = 0, Y = 0, Z = 0, R = sides.forward }
    return origin
end

-- Check if we are already Home
function Navigation:isAtHome(home)
    -- TODO
    return false
end

-- Return to the location of the home argument
function Navigation:returnToHome(home)
    -- Get ref to origin
    local origin = self.getOriginRef()

    -- Handle X Loc
    local xDiff = home.X - self.xLoc
    if (xDiff > 0) then
        self:move(origin, sides.posx, xDiff)
    elseif (xDiff < 0) then
        self:move(origin, sides.negx, -xDiff)
    end

    -- Handle Y Loc
    local yDiff = home.Y - self.yLoc
    if (yDiff > 0) then
        self:move(origin, sides.posy, yDiff)
    elseif(yDiff < 0) then
        self:move(origin, sides.negy, -yDiff)
    end
    
    -- Handle Z Loc
    local zDiff = home.Z - self.zLoc
    if (zDiff > 0) then
        self:move(origin, sides.posz, zDiff)
    elseif(zDiff < 0) then
        self:move(origin, sides.negz, -zDiff)
    end

    -- Handle Heading
    self:orient(home, sides.forward)
end

function Navigation:move(home, direction, distance)
    if (distance == nil) then
        distance = 1
    end
    self:orient(home, direction)

    local i
    for i = 1, distance do
        -- Check for real movement
            if (robot.forward()) then
                if (self.Heading == sides.posz) then
                    self.zLoc = self.zLoc + 1
                elseif (self.Heading == sides.negz) then
                    self.zLoc = self.zLoc -1
                elseif (self.Heading == sides.posx) then
                    self.xLoc = self.xLoc + 1
                elseif (self.Heading == sides.negx) then
                    self.xLoc = self.xLoc - 1
                end
            else
                -- TOOD
                computer.beep(40, .2)
            end
    end
end

-- Orient to passed 'direction' - relative to passed 'home'
function Navigation:orient(home, direction)
    if (home == nil) then
        error("No Home Reference Passed")
    end

    -- Convert home-relative direction to robot-relative direction
    local realDirection = self.getRelativeDirection(home.R, sides.forward, direction)

    local targetAngle = self.directionToAngle(realDirection)
    local currentAngle = self.directionToAngle(self.Heading)

    -- Perform turn
    local diff = (targetAngle - currentAngle)%4
    if (diff == 0) then
        -- None!
    elseif (diff == 1) then
        robot.turnRight()
    elseif (diff == 2) then
        robot.turnRight()
        robot.turnRight()
    elseif (diff == 3) then
        robot.turnLeft()
    end

    -- Update nav heading
    self.Heading = realDirection
end

-- Translate direction from reference1 to reference2 instead
function Navigation.getRelativeDirection(ref1, ref2, direction)
    local ref1Angle = Navigation.directionToAngle(ref1)
    local ref2Angle = Navigation.directionToAngle(ref2)
    local dirAngle = Navigation.directionToAngle(direction)

    local dir2Angle = (ref1Angle - ref2Angle) + dirAngle
    return Navigation.angleToDirection(dir2Angle)
end

function Navigation.directionToAngle(direction)
    if (direction == sides.forward) then
        return 0
    elseif (direction == sides.right) then
        return 1
    elseif (direction == sides.back) then
        return 2
    elseif (direction == sides.left) then
        return 3
    else
        return nil
    end
end

function Navigation.angleToDirection(angle)
    local angle = angle%4
    if (angle == 0) then
        return sides.forward
    elseif (angle == 1) then
        return sides.right
    elseif (angle == 2) then
        return sides.back
    elseif (angle == 3) then
        return sides.left
    end
end

function Navigation:moveForward(home, distance)
    self:move(home, sides.forward, distance)
end

function Navigation:moveRight(home, distance)
    self:move(home, sides.right, distance)
end

function Navigation:moveBack(home, distance)
    self:move(home, sides.back, distance)
end

function Navigation:moveLeft(home, distance)
    self:move(home, sides.left, distance)
end

return Navigation