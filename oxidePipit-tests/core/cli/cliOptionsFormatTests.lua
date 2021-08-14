
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

function test1()
    local argumentFormat = cliOptionsFormat:new(true, true)

    local argsArray
    local inputs

    argsArray = {"--version"}
    inputs = argumentFormat:parse(table.unpack(argsArray))

    local showVersion, _ = cliOptionsFormat:doesInputContainLongName(inputs, "version")
    if (showVersion) then
        print("Version 1!")
    end

    argsArray = {"-v"}
    inputs = argumentFormat:parse(table.unpack(argsArray))

    local showVersion, _ = cliOptionsFormat:doesInputContainLongName(inputs, "version")
    if (showVersion) then
        print("Version 2!")
    end
end

-- -----------------------------------------------------------------
-- Test 2 - Help format and call
-- -----------------------------------------------------------------

function test2()
    local argumentFormat = cliOptionsFormat:new(true, true)

    local argsArray = {"--help"}
    local inputs = argumentFormat:parse(table.unpack(argsArray))

    local needHelp, _ = argumentFormat:doesInputContainLongName(inputs, "help")
    if (needHelp) then
        print(tostring(needHelp))
    end
end

-- -----------------------------------------------------------------
-- Test 3 - An array of values
-- -----------------------------------------------------------------

function test3()
    local argumentFormat = cliOptionsFormat:new(true, true)

    local test1_string1 = "argument1"
    local test1_string2 = "argument2"
    local test1_number1 = 43
    local test1_number2 = 11
    local argsArray = {test1_string1, tostring(test1_number1), tostring(test1_number2), test1_string2}

    local inputs = argumentFormat:parse(table.unpack(argsArray))

    print(inputs.defaultArgs[1])

end

-- -----------------------------------------------------------------
-- Test 4 - flagged values
-- -----------------------------------------------------------------

function test4()
    local argumentFormat = cliOptionsFormat:new(true, true)
    argumentFormat:addOption("r","rows",2, 0, "Required. Offset to last row (back), offset to first row (front).")
    argumentFormat:addOption("c", "columns", 2, 0, "Required. Offset to first column (left), Offset to last column (right).")

    local argsArray = {"-r", 15, -1, "--columns", 2, 2}

    local inputs = argumentFormat:parse(table.unpack(argsArray))

    local _, rowArgs = argumentFormat:doesInputContainLongName(inputs, "rows")

    local _, columnArgs = argumentFormat:doesInputContainLongName(inputs, "columns")

end

--test1();
--test2();
--test3();
test4();