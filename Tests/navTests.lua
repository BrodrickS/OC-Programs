local sides = require("mocks.sides")
local navigation = require("bsops.nav.navigation")

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