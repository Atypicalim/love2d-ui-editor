--[[
    test
]]

local Editor = require('editor/editor')
local Previewer = require('editor/previewer')

function love.load()
    if string.valid(arg[2]) and files.is_file(arg[2]) and string.find(arg[2], '.ui.lua') then
        previewer = Previewer()
        previewer:load()
    else
        editor = Editor()
        editor:load()
    end
end

function love.update(dt)
    if previewer then
        previewer:update(dt)
    end
    if editor then
        editor:update(dt)
    end
end

function love.draw()
    if previewer then
        previewer:draw()
    end
    if editor then
        editor:draw()
    end
end

function love.mousepressed(x, y, button)
    if editor then
        editor:mousepressed(x, y, button)
    end
    if previewer then
        previewer:mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if previewer then
        previewer:mousereleased(x, y, button)
    end
    if editor then
        editor:mousereleased(x, y, button)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if previewer then
        previewer:keypressed(key, scancode, isrepeat)
    end
    if editor then
        editor:keypressed(key, scancode, isrepeat)
    end
end

function love.keyreleased(key, scancode)
    if previewer then
        previewer:keyreleased(key, scancode)
    end
    if editor then
        editor:keyreleased(key, scancode)
    end
end

function love.textinput(text)
    if previewer then
        previewer:textinput(text)
    end
    if editor then
        editor:textinput(text)
    end
end

function love.resize(width, height)
    if previewer then
        previewer:resize(width, height)
    end
    if editor then
        editor:resize(width, height)
    end
end
