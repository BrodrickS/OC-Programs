local sides = require("mocks.sides")
local navigation = require("bsops.nav.navigation")

-- local originRef = navigation:getHomeRef()

-- navigation:moveForward(originRef)
-- navigation:orient(originRef, sides.right)

-- local rightRef = navigation:getHomeRef()

-- navigation:moveForward(rightRef)

-- navigation:moveForward(originRef)

-- navigation:moveForward(rightRef)

-- navigation:moveRight(originRef)
-- navigation:moveBack(originRef)
-- navigation:moveLeft(originRef)
-- navigation:moveRight(originRef)

-- print("homing")
-- navigation:returnToHome(originRef)
-- print("homing 2")
-- navigation:returnToHome(rightRef)

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