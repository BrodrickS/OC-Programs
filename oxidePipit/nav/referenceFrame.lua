
-- Reference Frame class

-- Create a Reference Frame object (usually) through the Navigation singleton.
-- That creates a snapshot of the robots current location. You can then move in
-- relation to that snapshot. In other words, calling referenceFrame:forward() moves
-- the robot in whatever direction the robot was facing that snapshot was taken

-- See oxidePipit-tests for examples

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")
local sides = packInj.require("sides", true)

-- Oxide Pipit dependencies

-- #################################################################
-- Class Declaration
-- #################################################################

-- Meta class declaration, with any fields
local referenceFrame = {
    xPos = 0,
    yPos = 0,
    zPos = 0,
    heading = sides.forward,
}

-- Constructor
function referenceFrame:new (x, y, z, h)
    -- Inherits from nothing
    local o = {} 
    setmetatable(o, self)
    self.__index = self
    
    -- Set Default Values
    o.__init(x, y, z, h)

    -- Return new object
    return o
end

-- Initializer
function referenceFrame:__init(x, y, z, h)
    -- Get and set default values here 
    self.xPos = x or 0 
    self.yPos = y or 0 
    self.zPos = z or 0
    self.heading = h or 0
end

-- #################################################################
-- Methods
-- #################################################################

-- Tests for equality of position only
-- returns: bool
function referenceFrame:positionEquals(other)
    if (other == nil) then return false end

    return self.xPos == other.xPos and self.yPos == other.yPos and self.zPos == other.zPos
end


-- -----------------------------------------------------------------
-- Metamethods
-- -----------------------------------------------------------------

-- Converts to a string representation of position and heading
-- takes: referenceFrame
-- returns: string
function referenceFrame:__tostring()
    return "X: " .. tostring(self.xPos) .. " Y: " .. tostring(self.yPos) .. " Z: " .. tostring(self.zPos) .. " H: " .. tostring(self.heading);
end

-- Tests for equality of position and heading
-- takes: referenceFrame
-- returns: bool
function referenceFrame:__equals(other)
    if (other == nil) then return false end

    return self:positionEquals(other) and self.heading == other.heading    
end

-- #################################################################
-- Package Output
-- #################################################################

return referenceFrame