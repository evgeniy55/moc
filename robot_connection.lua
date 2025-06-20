local component = require("component")
local modem = component.modem
local event = require("event")
local thread = require("thread")

local port = 12345
modem.open(port)
print("Ожидание подключения к роботу...")

local robotAddress = "robot_address_here" -- Замените на адрес вашего робота

local running = true

print("Ожидание сообщений на порту " .. port .. "...")

local running = true

local function receiveMessages()
    while running do
        local e = {event.pull(0.5, "modem_message")}
        if not running then break end
        if #e > 0 then
            local msg = e[6]
            if msg then
                print("Сообщение от " .. tostring(e[2]) .. ": " .. tostring(msg))
            end
        end
    end
end

local receiveThread = thread.create(receiveMessages)

while true do
    io.write("Введите сообщение для робота (или 'выход' для завершения): ")
    local userInput = io.read()
    if userInput == "выход" then
        running = false
        break
    end
    modem.send(robotAddress, port, userInput)
    print("Сообщение отправлено роботу: " .. userInput)
end

-- Ждем завершения потока получения сообщений
receiveThread:join()

print("Завершение работы программы.")
