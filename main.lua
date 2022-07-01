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

function love:mousepressed(x, y, button)
	editor:mousepressed(x, y, button)
end

function love:mousereleased(x, y, button)
	editor:mousereleased(x, y, button)
end

function love:keypressed(key, scancode, isrepeat)
	editor:keypressed(key, scancode, isrepeat)
end

function love:eyreleased(key, scancode)
	editor:eyreleased(key, scancode, isrepeat)
end

function love:textinput(text)
	editor:textinput(text)
end