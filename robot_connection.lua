local component = require("component")
local modem = component.modem
local event = require("event")
local thread = require("thread")

local port = 12345
modem.open(port)
print("Ожидание подключения к роботу...")

local robotAddress = "robot_address_here" -- Замените на адрес вашего робота

local running = true

local function receiveMessages()
    while running do
        local _, sender, receivedPort, _, message = event.pull("modem_message")
        if receivedPort == port then
            print("Сообщение от робота: " .. message)
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
