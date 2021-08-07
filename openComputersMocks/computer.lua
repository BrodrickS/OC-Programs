
local computer = {}

function computer.beep(hz, time)
    if (hz == nil) then hz = 500 end
    if (time == nil) then time = .2 end
    print("Computer Beep!", tostring(hz) + " hz, " + tostring(time) + " s")
end
