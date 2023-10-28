require("GodOfLegs/getDirection")
require("GodOfLegs/gotoGPS")
require("GodOfLegs/movement")
require("config")
-- init device

local modem = peripheral.wrap("left")
-- open up 442 for a split second
modem.open(12)
-- open up a new random channel once you understand your turtle


-- recieve controls from turtle
data = {
    controls = {
        ["w"] = "FORWARD",
        ["s"] = "BACK",
        ["a"] = "LEFT",
        ["d"] = "RIGHT",
        ["k"] = "UP",
        ["j"] = "DOWN",
    },

    information = {
        ["walking"] = "FALSE",
        ["port"] = math.random(13, 65534),
    }
}


local innerCommands = {
    ["FORWARD"] = function() move.forward() end,
    ["BACK"] = function() move.back() end,
    ["LEFT"] = function() turn.left() end,
    ["RIGHT"] = function() turn.right() end,
    ["UP"] = function() move.up() end,
    ["DOWN"] = function() move.down() end,
}

function transmitTable(table, tableName)
    modem.transmit(12, 12, "tableStart")
    modem.transmit(12, 12, tableName)
    for type, value in pairs(table) do
        modem.transmit(12, 12, type .. ";" .. value)
    end
    modem.transmit(12, 12, "tableEnd")
end

-- init loop
while true do
    print("initTick")
    -- recieved message from pocket computer
    local Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent()
    if Event_type == "modem_message" then
        -- its for initializing
        if arg4 == "init Turtle" then
            for tableName, table in pairs(data) do
                transmitTable(table, tableName)
            end
            modem.transmit(12, 12, "ready")
            modem.open(data["information"]["port"])
            break
        end
    end
end

-- main loop
while true do
    print("mainTick")
    local Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent("modem_message")
    -- Turtle send a message back
    if Event_type == "modem_message" then
        print(arg4)
        if innerCommands[arg4] ~= nil then
            innerCommands[arg4]()
        end
    end
end
