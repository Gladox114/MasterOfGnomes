--[[ directions 
-x = 1
-z = 2
+x = 3
+z = 4
]]
require("GodOfLegs/home")
if not turtle.location then
    turtle.location = vector.new(0, 0, 0)
    turtle.facing = 1
    turtle.startPosition = turtle.location
    turtle.startFacing = 1
    initHomeAxis()
end
