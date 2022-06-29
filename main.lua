--[[
    test
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')
local Editor = require('editor/editor')

local debug = true

function love.load()
    editor = Editor:new()
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
