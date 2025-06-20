local component = require("component")
local modem = component.modem
local event = require("event")
local thread = require("thread")

local port = 1
modem.open(port)
print("Ожидание сообщений на порту " .. port .. "...")

local running = true

-- Здесь укажите адрес робота (число или строка)
local robotAddress = "address"  -- замените на реальный адрес робота

local function receiveMessages()
    while running do
        local e = {event.pull(0.5, "modem_message")}
        if not running then break end
        if #e > 0 then
            local msg = e[5] or e[6]
            if msg then
                local senderShort = tostring(e[2]):sub(1, 4)
                io.write("\nСообщение от " .. senderShort .. ": " .. tostring(msg) .. "\n> ")
                io.flush()
            end
        end
    end
end

local receiveThread = thread.create(receiveMessages)

while true do
    io.write("> ")
    io.flush()
    local userInput = io.read()
    if userInput == "выход" then
        running = false
        break
    end
    modem.send(robotAddress, port, userInput)
    print("Сообщение отправлено роботу: " .. userInput)
end

receiveThread:join()

print("Программа завершена.")
