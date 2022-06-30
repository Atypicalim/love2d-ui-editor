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

function love.keypressed(key, scancode, isrepeat)
    editor:keypressed(key, scancode, isrepeat)
end
