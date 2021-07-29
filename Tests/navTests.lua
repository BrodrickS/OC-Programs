local sides = require("Mocks.sides")
local navigation = require("Packages.Navigation.navigation")

local originRef = navigation:getHomeRef()

navigation:moveForward(originRef)
navigation:orient(originRef, sides.right)

local rightRef = navigation:getHomeRef()

navigation:moveForward(rightRef)

navigation:moveForward(originRef)

navigation:moveForward(rightRef)

navigation:moveRight(originRef)
navigation:moveBack(originRef)
navigation:moveLeft(originRef)
navigation:moveRight(originRef)

print("homing")
navigation:returnToHome(originRef)
print("homing 2")
navigation:returnToHome(rightRef)