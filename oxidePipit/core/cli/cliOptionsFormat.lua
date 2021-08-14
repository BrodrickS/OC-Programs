
-- Command Line Arguments class

-- Created to a given format of flags and positional arguments

-- Can attempt to parse an array of arguments into that format 

-- Follows most conventions here: https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")

-- Oxide Pipit dependencies
local cliOption = require("oxidePipit.core.cli.cliOption")

-- #################################################################
-- Class Declaration
-- #################################################################

-- Class declaration with any fields
local cliOptionsFormat = {
    nonOptionMarker = "--",

    versionLongName = "version",
    versionShortName = "v",
    helpLongName = "help",
    helpShortName = "h",
}

-- Constructor
function cliOptionsFormat:new(generateVersion, generateHelp)
    -- Inherits from nothing
    local o = {} 
    setmetatable(o, self)
    self.__index = self

    -- Set Default Values
    o:__init(generateVersion, generateHelp)

    -- Return new object
    return o
end

-- Initializer
function cliOptionsFormat:__init(generateVersion, generateHelp)
    -- Get and set default values here
    self.optionCount = 1
    self.options = {}

    -- Create version option
    if (generateVersion or generateVersion == nil) then
        self:addOption(self.versionShortName, self.versionLongName, 0, 0, "Prints the version number of this program.")
    end

    -- Create
    if (generateHelp or generateHelp == nil) then
        self:addOption(self.helpShortName, self.helpLongName, 0, 0, "Shows this screen.")
    end
end

-- #################################################################
-- Static Properties
-- #################################################################

-- #################################################################
-- Methods
-- #################################################################

-- -----------------------------------------------------------------
-- Set format
-- -----------------------------------------------------------------

-- Registers a new option in this command line argument format
-- takes: string, character, 
function cliOptionsFormat:addOption(shortName, longName, requiredArgCount, optionalArgCount, comment)
    -- Validate Existence
    if (longName == nil and shortName == nil) then
        error("Both Option short name and long name cannot be nil")
    end

    -- Validate longName (a string)
    if (longName ~= nil) then
        -- Stringify and trim
        longName = tostring(longName)
        longName = string.lower(longName)
        -- TODO trim

        -- Validate no spaces
        -- TODO

        -- Validate uniqueness
        -- TODO
    end

    -- Validate shortName (a single character)
    if (shortName ~= nil) then 
        -- Stringify and trim whitespace
        shortName = tostring(shortName)
        shortName = string.lower(shortName)
        -- TODO trim

        -- Validate single character
        if string.len(shortName) > 1 then
            error("Option short name must be exactly one character")
        end

        -- Validate no spaces
        -- TODO

        -- Validate uniqueness
        -- TODO
    end

    local newOption = cliOption:new(shortName, longName, requiredArgCount, optionalArgCount, comment)
    self.options[self.optionCount] = newOption
    self.optionCount = self.optionCount + 1
end

-- -----------------------------------------------------------------
-- Parse Args into Format
-- -----------------------------------------------------------------

-- takes: variable number of string arguments
-- returns: table
function cliOptionsFormat:parse(...)
    local args = {...}
    local argsCount = 0 
    for k, _ in pairs(args) do argsCount = argsCount + 1 end

    
    local defaultArgs = {
        count = 0,
    }
    local optionsPresent = {
        defaultArgs = defaultArgs,
    }


    local lastOption = nil
    local numArgs = 0

    local argIndex = 1
    while argIndex <= argsCount do
        local arg = args[argIndex]

        -- Check if it's a long option name, and parse if so
        local isLong, longName = self:isArgLongOption(arg)
        if (isLong) then

            -- Get option table
            local option = self:getOptionByLongName(longName)

            -- Check if it already exists (not allowed)
            if (optionsPresent[option] ~= nil) then
                error("Not allowed to call option --" .. option.longName .. " or -" .. option.shortName .. " more than once")
            end
            optionsPresent[option] = {
                count = 0,
            }
            lastOption = option

        end

        local isShort, shortCount, shortNames = self:isArgShortOption(arg)
        if (isShort) then
            
            for _, shortName in pairs(shortNames) do
                -- Get option table
                local option = self:getOptionByShortName(shortName)

                -- Check if it already exists (not allowed)
                if (optionsPresent[option] ~= nil) then
                    error("Not allowed to call option --" .. option.longName .. " or -" .. option.shortName .. " more than once")
                end
                optionsPresent[option] = {
                    count = 0,
                }
                lastOption = option
            end

        end

        if (not isLong and not isShort) then

            if (lastOption == nil) then
                defaultArgs.count = defaultArgs.count + 1
                defaultArgs[defaultArgs.count] = arg
            else
                local argNum = optionsPresent[lastOption].count + 1
                optionsPresent[lastOption][argNum] = arg
                optionsPresent[lastOption].count = argNum
            end
            
        end

        argIndex = argIndex + 1
    end

    return optionsPresent
end

-- Determines if a string follows the --longName format and returns the longName if so
-- takes: string
-- returns: bool, string
function cliOptionsFormat:isArgLongOption(arg)
    local arg = tostring(arg)
    if (string.len(arg) >= 3 and string.sub(arg, 1, 2) == "--") then
        return true, string.sub(arg, 3)
    else
        return false, ""
    end
end

-- Determines if a string follows the -a format (or -abc format) and returns the short name(s) if so
-- takes: string
-- returns: bool, integer, { string }
function cliOptionsFormat:isArgShortOption(arg)
    local arg = tostring(arg)
    if (string.len(arg) >= 2 and string.sub(arg, 1, 1) == "-" and string.sub(arg, 2, 2) ~= "-") then
        
        -- Filter out negative numbers
        if (tonumber(arg) ~= nil) then
            return false, 0, {}
        end
    
        local values = {}
        local count = 0
        for i = 2,string.len(arg) do
            values[i-1] = string.sub(arg, i, i)
            count = count + 1
        end
        return true, count, values

    else
        return false, 0, {}
    end
end

function cliOptionsFormat:getOptionByLongName(longName)
    for _, option in pairs(self.options) do
        if option.longName == longName then
            return option
        end
    end
end

function cliOptionsFormat:getOptionByShortName(shortName)
    for _, option in pairs(self.options) do
        if (option.shortName == shortName) then
            return option
        end
    end
end

-- -----------------------------------------------------------------
-- Output Scanning of chosen flags
-- -----------------------------------------------------------------

function cliOptionsFormat:doesInputContainLongName(inputs, longName)
    longName = string.lower(longName)
    for option, args in pairs(inputs) do
        if (option.longName == longName) then
            return option, args
        end
    end
    return nil, nil
end

-- -----------------------------------------------------------------
-- Metamethods
-- -----------------------------------------------------------------

function cliOptionsFormat:__tostring()
    local lines = ""
    for _, option in pairs(self.options) do
        lines = lines .. "\n" .. tostring(option) 
    end
    lines = string.sub(lines, 2)
    return lines
end

-- #################################################################
-- Package Output
-- #################################################################

return cliOptionsFormat