
-- Navigation Class (Singleton)

-- Handles more complex motion, homing, pathing, and relative movement

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers
local packInj = require("oxidePipit.core.packageInjector")
local robot = packInj.require("robot", true)
local sides = packInj.require("sides", true)
local computer = packInj.require("computer", true)

-- Oxide Pipit
local referenceFrame = require("oxidePipit.nav.referenceFrame")

-- #################################################################
-- Class declaration
-- #################################################################

-- Meta Class declaration with any fields
local navigation = { 
    xPos = 0, -- Forward-Back Direction
    yPos = 0, -- Up-Down Direction
    zPos = 0, -- Left-Right Direction
    heading = sides.forward, -- Rotation
    obstructionWaitSecs = .2, -- Ticks to wait before reattempting motion
    obstructionReretries = 3, -- Number of times to retry a move before giving up
}

-- #################################################################
-- Methods
-- #################################################################

-- -----------------------------------------------------------------
-- Refrencing
-- -----------------------------------------------------------------

-- Create a reference frame from the current location and heading
-- returns: referenceFrame
function navigation:getReferenceFrame()
    local ref = referenceFrame:new(self.xPos, self.yPos, self.zPos, self.heading)
    return ref
end

navigation.origin = navigation:getReferenceFrame()

-- -----------------------------------------------------------------
-- Refrenced Motion
-- -----------------------------------------------------------------

-- Check if the robot is currently at the referenceFrame's relative origin, ignores heading
-- takes: referenceFrame
-- returns: bool
function navigation:isAtReferencePosition(refFrame)
    return self.origin.positionEquals(refFrame) 
end

-- Move to the location of the referenceFrame's relative origin, and face it's relative origin heading. Returns true if the homing sequence was sucessful
-- takes: referenceFrame
-- returns: bool
function navigation:returnToReferencePosition(refFrame)
    -- Handle X Loc
    local xDiff = refFrame.xPos - self.xPos
    if (xDiff > 0) then
        self:move(origin, sides.posx, xDiff)
    elseif (xDiff < 0) then
        self:move(origin, sides.negx, -xDiff)
    end

    -- Handle Y Loc
    local yDiff = refFrame.yPos - self.yPos
    if (yDiff > 0) then
        self:move(origin, sides.posy, yDiff)
    elseif(yDiff < 0) then
        self:move(origin, sides.negy, -yDiff)
    end
    
    -- Handle Z Loc
    local zDiff = refFrame.zPos - self.zPos
    if (zDiff > 0) then
        self:move(origin, sides.posz, zDiff)
    elseif(zDiff < 0) then
        self:move(origin, sides.negz, -zDiff)
    end

    -- Handle heading
    self:orient(refFrame, sides.forward)
end

-- Move in a direction relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, side, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:move(refFrame, direction, distance)
    -- Default distance is set to 1 unit
    distance = distance or 1

    -- Default reference frame is the power-on origin
    refFrame = refFrame or self.origin

    -- No default direction
    if (direction == nil) then
        -- TODO add log message
        return false, 0
    end

    -- Get the direction of movement
    -- Handle X-Z planar movement by pointing the correct direction and then moving forward
    -- Handle Y axis movement by moving either up or down
    local moveMethod
    if (direction == sides.posx or direction == sides.negx or direction == sides.posz or direction == sides.negz) then
        self:orient(refFrame, direction)
        --  TODO check for orient success and add log message
        moveMethod = robot.forward
    elseif (direction == sides.posy) then
        moveMethod = robot.up
    elseif (direction == sides.negy) then
        moveMethod = robot.down
    end

    local step = 0
    local retries = 0
    while (step < distance) do

        -- Attempt moves while checking for success
        local success, reason = moveMethod() 

        if (success) then
            retries = 0
            step = step + 1

            -- Adjust internal position tracker
            -- X direction
            if (self.heading == sides.posx) then
                self.xPos = self.xPos + 1
            elseif (self.heading == sides.negx) then
                self.xPos = self.xPos - 1
            -- Y direction
            elseif (self.heading == sides.posy) then
                self.yPos = self.yPos + 1
            elseif (self.heading == sides.negx) then
                self.yPos = self.yPos - 1
            -- Z direction
            elseif (self.heading == sides.posz) then
                self.zPos = self.zPos + 1
            elseif (self.heading == sides.negz) then
                self.zPos = self.zPos -1
            end

        elseif (retries < self.obstructionReretries) then
            -- Vocally complain and try again
            -- TODO add log message
            retries = retries + 1
            computer.beep(40, self.obstructionWaitSecs)
        else
            -- Fail the move and return the places moved
            -- TODO add log message
            return false, step;
        end

    end

    -- Return success plus the distance moved
    return true, step
end

-- Move forward relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveForward(home, distance)
    return self:move(home, sides.forward, distance)
end

-- Move back relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveBack(home, distance)
    return self:move(home, sides.back, distance)
end

-- Move up relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveUp(home, distance)
    return self:move(home, sides.up, distance)
end

-- Move down relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveDown(home, distance)
    return self:move(home, sides.down, distance)
end

-- Move right relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveRight(home, distance)
    return self:move(home, sides.right, distance)
end

-- Move left relative to the provided reference for a given number of spaces.
-- takes: referenceFrame, integer
-- returns: bool (success), integer (number of units traveled)
function navigation:moveLeft(home, distance)
    return self:move(home, sides.left, distance)
end

-- Orient to the direction relative to reference frame
-- takes: referenceFrame, direction
-- returns: bool
function navigation:orient(refFrame, direction)
    if (refFrame == nil) then
        -- TODO add log message
        return false
    end

    -- Convert home-relative direction to robot-relative direction
    local realDirection = self:getRelativeDirection(refFrame.heading, sides.forward, direction)

    local targetAngle = self:directionToAngle(realDirection)
    local currentAngle = self:directionToAngle(self.heading)

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

    -- Update nav heading and return success
    self.heading = realDirection
    return true
end

-- -----------------------------------------------------------------
-- Angle Conversion
-- -----------------------------------------------------------------

-- Translate a direction from refrenceFrame1 to the equivilant refrenceFrame2 direction
-- takes: refrenceFrame (original), refrenceFrame (new), side
-- returns: side
-- notes: 
    -- doing 
    --   navigation:move(ref1, direction) 
    -- performs the same real-world motion as 
    --   navigation:move(ref2, navigation:getRelativeDirection(ref1, ref2, direction))
function navigation:getRelativeDirection(ref1, ref2, direction)
    local ref1Angle = self:directionToAngle(ref1)
    local ref2Angle = self:directionToAngle(ref2)
    local dirAngle = self:directionToAngle(direction)

    local dir2Angle = (ref1Angle - ref2Angle) + dirAngle
    return self:angleToDirection(dir2Angle)
end

-- Translates a direction (an enum whose int value has no meaning) into an angle value (4 total degrees)
-- takes: side
-- returns integer
-- notes: 
    -- A 'normal' angular system has 360 degrees, this one only has 4 degrees.
    -- see navigation:angleToDirection()
function navigation:directionToAngle(direction)
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

-- Translates an angle value (4 total degrees) into a direction (an enum whose int value has no meaning)
-- takes: integer
-- returns: side
-- notes:
    -- A 'normal' angular system has 360 degrees, this one only has 4 degrees.
    -- see navigation:directionToAngle()
function navigation:angleToDirection(angle)
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

-- Gets a human readable name for a side
-- takes: sides
-- returns: string
function navigation:sideToName(side)
    if (side == sides.forward) then
        return "forward"
    elseif (side == sides.back) then
        return "back"
    elseif (side == sides.up) then
        return "up"
    elseif (side == sides.down) then
        return "down"
    elseif (side == sides.left) then
        return "left"
    elseif (side == sides.right) then
        return "right"
    end
end

-- #################################################################
-- Package Output
-- #################################################################

return navigation