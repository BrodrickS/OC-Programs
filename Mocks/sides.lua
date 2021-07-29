-- Defines the sides as integer/enums

local sides = {
    bottom = 0,
    down = 0,
    negy = 0,

    top = 1,
    up = 1,
    posy = 1,

    back = 2,
    north = 2,
    negz = 2,

    front = 3,
    south = 3,
    posz = 3,
    forward = 3,

    right = 4,
    west = 4,
    negx = 4,

    left= 5,
    east = 5,
    posx = 5,
}

function sides:sideName(direction) 
    if (direction == self.bottom) then
        return "bottom"
    elseif (direction == self.top) then
        return "top"
    elseif (direction == self.back) then
        return "back"
    elseif (direction == self.front) then
        return "front"
    elseif (direction == self.right) then
        return "right"
    elseif (direction == self.left) then
        return "left"
    end
end

return sides