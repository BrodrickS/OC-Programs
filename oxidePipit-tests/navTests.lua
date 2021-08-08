-- Open Computers Libraries
local packInj = require("oxidePipit.core.packageInjector")
local sides = packInj.require("sides", true)

-- Oxide Pipit Libraries
local navigation = require("oxidePipit.nav.navigation")

print ("origin:", navigation.origin)
for i = 1, 5 do navigation:moveLeft() end

local bottomLeftRef = navigation:getReferenceFrame()
print("bottom left reference", bottomLeftRef)

navigation:moveForward(bottomLeftRef)
for i = 1, 5 do navigation:moveRight(bottomLeftRef) end
for i = 1, 5 do navigation:moveBack(bottomLeftRef) end

local topRightRef = navigation:getReferenceFrame()
print("top right reference", topRightRef)

navigation:returnToReferencePosition(bottomLeftRef) 
print(bottomLeftRef)
navigation:returnToReferencePosition(topRightRef)
print(topRightRef)