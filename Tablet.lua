-- init device
print("test")
local modem = peripheral.wrap("back")
-- open up 442 for a split second
modem.open(12)
-- open up a new random channel once you understand your turtle

local data = {
    controls = {},
    information = {
        port = 12
    }
}

-- recieve controls from turtle
function recieveTable()
    -- get the table name
    local Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent("modem_message")
    local tableName = arg4
    -- get the first value from it
    Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent("modem_message")
    while arg4 ~= "tableEnd" do
        -- split type and value by semicolon
        local type, value = arg4:match("([^;]+);([^;]+)")
        -- store it
        data[tableName][type] = value
        -- call more
        Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent("modem_message")
    end
end

function printData()
    for entry, dataTable in pairs(data) do
        print(entry)
        for key, value in pairs(dataTable) do
            print(key .. "=" .. value)
        end
    end
end

-- init loop
while true do
    print("initTick")
    modem.transmit(12, 12, "init Turtle")
    --local myTimer = os.startTimer(1)
    local Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent()
    print(Event_type, arg1, arg2, arg3, arg4, arg5)
    if Event_type == "modem_message" then
        if arg4 == "tableStart" then
            recieveTable()
        elseif arg4 == "ready" then
            data["information"]["port"] = tonumber(data["information"]["port"])
            -- for info
            printData()
            -- switch to work mode
            modem.open(data["information"]["port"])
            break
        end
    elseif Event_type == "alarm" then
        if arg1 == myTimer then

        end
    end
end

-- main loop
while true do
    print("mainTick")
    local Event_type, arg1, arg2, arg3, arg4, arg5 = os.pullEvent()
    print(Event_type, arg1, arg2, arg3, arg4, arg5)

    -- Player pressed a key
    if Event_type == "char" then
        if data["controls"][arg1] ~= nil then
            modem.transmit(data["information"]["port"], data["information"]["port"], data["controls"][arg1])
            print(data["controls"][arg1])
        end
        -- Player pressed a modifier key
    elseif Event_type == "key" then

        -- Turtle send a message back
    elseif Event_type == "modem_message" then

    end
end
