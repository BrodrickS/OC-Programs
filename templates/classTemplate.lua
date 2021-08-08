
-- Class name and description

-- Class details

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")

-- Oxide Pipit dependencies

-- #################################################################
-- Class Declaration
-- #################################################################

-- Class declaration with any static fields
local class = {

}

-- Constructor
function class:new()
    -- Inherits from nothing
    local o = {} 
    setmetatable(o, self)
    self.__index = self

    -- Set Default Values
    o:__init()

    -- Return new object
    return o
end

-- Initializer
function class:__init()
    -- Get and set instance fields here 
end

-- #################################################################
-- Methods
-- #################################################################

-- -----------------------------------------------------------------
-- Method Subregion
-- -----------------------------------------------------------------

-- #################################################################
-- Package Output
-- #################################################################

return class