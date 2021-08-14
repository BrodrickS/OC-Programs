
-- Script name and description

-- Script details

-- #################################################################
-- Dependencies
-- #################################################################

-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")

-- Oxide Pipit dependencies
local cliOptionsFormat = require("OxidePipit.core.cli.cliOptionsFormat")

-- #################################################################
-- Script Values
-- #################################################################

-- Version
local script = {
    name = "scriptTemplate",
    description = "A reusable template for creating scripts. Calling this file will not execute the script immediately (for reuse reasons). See also scriptExecutorTempalte.lua.",
    version = "1.0.0",
}

-- #################################################################
-- Script Declaration
-- #################################################################

-- Script declaration with help and verion checks
function script:execute(...)
    
    -- Configure options
    local optionsFormat = cliOptionsFormat:new(true, true)
    optionsFormat:addOption("r","run",0,0,"Run the custom mode of this script.")

    -- Parse options
    local input = optionsFormat:parse(...)

    -- Run Version and Help Modes
    local doStop = false
    doStop = self:tryRunIfValidated(doStop, self.runVersion, self.validateVersion, optionsFormat, input)
    doStop = self:tryRunIfValidated(doStop, self.runHelp, self.validateHelp, optionsFormat, input)

    -- Run custom mode(s)
    doStop = self:tryRunIfValidated(doStop, self.runCustom, self.validateCustom, optionsFormat, input)        

    -- Fallthrough mode
    doStop = self:tryRun(doStop, self.runHelp, optionsFormat, input)
end

-- #################################################################
-- Mode Validators
-- #################################################################

-- -----------------------------------------------------------------
-- Custom Modes
-- -----------------------------------------------------------------

-- Checks if this mode of this script was called. 
-- If any errors are included then the script will print them then terminate immediately.
-- returns: bool, table (list of errors)
function script:validateCustom(optionsFormat, input)
    local versionOption, _ = optionsFormat:doesInputContainLongName(input, "run")
    if (versionOption ~= nil) then
        return true, nil
    end
    return false, nil
end

function script:runCustom(optionsFormat, input)
    print('Custom mode!')
    return true;
end

-- -----------------------------------------------------------------
-- Mode Helpers
-- -----------------------------------------------------------------

function script:tryRun(doStop, runner, optionsFormat, input)
    -- Skip if the previou step or mode determined script must end
    if (doStop) then return doStop end

    return runner(self, optionsFormat, input)
end

-- Validates a mode. If validates successfully, runs the mode. Outputs errors to console.
function script:tryRunIfValidated(doStop, runner, validator, optionsFormat, input)
    -- Skip if the previou step or mode determined script must end
    if (doStop) then return doStop end

    -- Validate and return erros if needed
    local doRunMode, errors = validator(self, optionsFormat, input)
    if (errors ~= nil) then
        for _, v in pairs(errors) do
            print(v)
        end
        return true
    end

    if (doRunMode) then
        return runner(self, optionsFormat, input)
    end
    return doStop
end

-- -----------------------------------------------------------------
-- Builtin Modes
-- -----------------------------------------------------------------

-- Checks if the verion mode of this script was called. 
-- If any errors are included then the script will print them then terminate immediately.
-- returns: bool, table (list of errors)
function script:validateVersion(optionsFormat, input)
    local versionOption, _ = optionsFormat:doesInputContainLongName(input, optionsFormat.versionLongName)
    if (versionOption ~= nil) then
        return true, nil
    end
    return false, nil
end

function script:runVersion(optionsFormat, input)
    -- print version
    print("version " .. self.version .. "\n")

    -- retrurn true so execution halts
    return true
end

-- Checks if the help mode of this script was called
-- If any errors are included then the script will print them then terminate immediately.
-- returns: bool, table (list of errors)
function script:validateHelp(optionsFormat, input)
    local helpOption, _ = optionsFormat:doesInputContainLongName(input, optionsFormat.helpLongName)
    if (helpOption ~= nil) then
        return true, nil
    end
    return false, nil
end

function script:runHelp(optionsFormat, input)        
    -- print name and version
    print(self.name)
    print("Version: " .. self.version .. "\n")

    -- print description
    print(self.description .. "\n") 

    -- print all options
    print(optionsFormat)

    -- retrurn true so execution halts
    return true
end

-- -----------------------------------------------------------------
-- Package Output
-- -----------------------------------------------------------------

-- Return script
return script
