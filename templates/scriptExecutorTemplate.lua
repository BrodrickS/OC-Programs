-- Open Computers dependencies
local packInj = require("oxidePipit.core.packageInjector")

-- Oxide Pipit dependencies
local cliOptionsFormat = require("OxidePipit.core.cli.cliOptionsFormat")

-- Script execution
local script = require("templates.scriptTemplate") 
script:execute(...)