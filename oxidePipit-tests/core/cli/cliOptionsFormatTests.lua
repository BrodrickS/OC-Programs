
-- Tests for oxidePipit.core.cliOptionsFormat

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")

-- Oxide Pipit dependencies
local cliOptionsFormat = require("OxidePipit.core.cli.cliOptionsFormat")

-- #################################################################
-- Test Declaration
-- #################################################################

-- -----------------------------------------------------------------
-- Test 1 - Version format and call
-- -----------------------------------------------------------------

if true then
    local argumentFormat = cliOptionsFormat:new(true, true)

    local argsArray
    local inputs

    argsArray = {"scriptname.lua", "--version"}
    inputs = argumentFormat:parse(table.unpack(argsArray))

    local showVersion, _ = cliOptionsFormat:doesInputContainLongName(inputs, "version")
    if (showVersion) then
        print("Version 1!")
    end

    argsArray = {"scriptname.lua", "-v"}
    inputs = argumentFormat:parse(table.unpack(argsArray))

    local showVersion, _ = cliOptionsFormat:doesInputContainLongName(inputs, "version")
    if (showVersion) then
        print("Version 2!")
    end
end

-- -----------------------------------------------------------------
-- Test 2 - Help format and call
-- -----------------------------------------------------------------

if true then
    local argumentFormat = cliOptionsFormat:new(true, true)

    print(tostring(argumentFormat))

    local argsArray = {"scriptname.lua", "--help"}
    local inputs = argumentFormat:parse(table.unpack(argsArray))

    local showVersion, _ = cliOptionsFormat:doesInputContainLongName(inputs, "version")
    if (showVersion) then
        print("Help!")
    end
end

-- -----------------------------------------------------------------
-- Test 3 - An array of values
-- -----------------------------------------------------------------

if true then
    local argumentFormat = cliOptionsFormat:new(true, true)

    local test1_string1 = "argument1"
    local test1_string2 = "argument2"
    local test1_number1 = 43
    local test1_number2 = 11
    local argsArray = {"scriptname.lua", test1_string1, tostring(test1_number1), tostring(test1_number2), test1_string2}


    argumentFormat:parse(table.unpack(argsArray))

end