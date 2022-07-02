--[[
    test
]]

local Editor = require('editor/editor')

function love.load()
    editor = Editor()
    editor:load()
end

function love.update(dt)
    editor:update(dt)
end

function love.draw()
    editor:draw()
end

function love.mousepressed(x, y, button)
	editor:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	editor:mousereleased(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
	editor:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
	editor:keyreleased(key, scancode)
end

function love.textinput(text)
	editor:textinput(text)
end