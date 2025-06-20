local modem = require("component").modem
local computer = require("computer")
local event = require("event")

local port = 12345
modem.open(port)
print("Ожидание подключения к роботу...")

local robotAddress = "robot_address_here" -- Замените на адрес вашего робота

local function receiveMessages()
    while true do
        local _, sender, port, _, message = event.pull("modem_message") -- Ждём сообщения
        if port == port then
            print("Сообщение от робота: " .. message)
        end
    end
end

local function sendMessage(message)
    modem.send(robotAddress, port, message)
    print("Сообщение отправлено роботу: " .. message)
end

-- Запускаем функцию получения сообщений в отдельном потоке
local receiveThread = computer.addThread(receiveMessages)

-- Основной цикл для ввода сообщений
while true do
    io.write("Введите сообщение для робота (или 'выход' для завершения): ")
    local userInput = io.read()
    if userInput == "выход" then
        break
    end
    sendMessage(userInput)
end

-- Завершение работы
if receiveThread then
    computer.cancel(receiveThread) -- Останавливаем поток получения сообщений
end
print("Завершение работы программы.")
