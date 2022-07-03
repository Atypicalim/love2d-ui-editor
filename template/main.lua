--[[
    test
]]

package.path = package.path .. ";../?.lua"


local Gui = require('../gui')
local WIDTH = 500
local HEIGHT = 500

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    gui = Gui("./app.ui.lua", WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT)
end

function love.update(dt)
    gui:update(dt)
end

function love.draw()
    gui:draw()
end

function love.mousepressed(x, y, button)
	gui:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	gui:mousereleased(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
	gui:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	gui:keyreleased(key, scancode)
end

function love.textinput(text)
	gui:textinput(text)
end
