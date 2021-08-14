
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
local cliOption = {

}

-- Constructor
function cliOption:new(shortName, longName, requiredArgCount, optionalArgCount, comment)
    -- Inherits from nothing
    local o = {} 
    setmetatable(o, self)
    self.__index = self

    -- Set Default Values
    o:__init(shortName, longName, requiredArgCount, optionalArgCount, comment)

    -- Return new object
    return o
end

-- Initializer
function cliOption:__init(shortName, longName, requiredArgCount, optionalArgCount, comment)
    -- Get and set default values here 
    self.shortName = shortName or ""
    self.longName = longName or ""
    self.requiredArgCount = requiredArgCount or 0
    self.optionalArgCount = optionalArgCount or 0
    self.comment = comment or ""
end

-- #################################################################
-- Methods
-- #################################################################

-- -----------------------------------------------------------------
-- Metamethods
-- -----------------------------------------------------------------

function cliOption:__tostring()
    return string.format("  -%s --%-32s %s", self.shortName, self.longName, self.comment)
end

-- #################################################################
-- Package Output
-- #################################################################

return cliOption