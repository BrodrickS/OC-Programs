-- Open Computers Libraries
local packInj = require("oxidePipit.core.packageInjector")
local sides = packInj.require("sides", true)

-- Oxide Pipit Libraries
local navigation = require("oxidePipit.nav.navigation")

local originRef = navigation:getHomeRef()
for i = 1, 5 do navigation:moveLeft(originRef) end
local bottomLeftRef = navigation:getHomeRef()
print("mark.")
navigation:moveForward(bottomLeftRef)
for i = 1, 5 do navigation:moveRight(bottomLeftRef) end
for i = 1, 5 do navigation:moveBack(bottomLeftRef) end
local topRightRef = navigation:getHomeRef()
print("mark.")
navigation:returnToHome(bottomLeftRef) 
navigation:returnToHome(topRightRef)