--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Previewer = class("Previewer")
local Gui = require('gui')

local WIDTH = 800
local HEIGHT = 700

function Previewer:__init__(path)
    g_previewer = self
    g_pgui = Gui(path or './template/app.ui.lua', WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT)
end

function Previewer:load()

	love.window.setMode(WIDTH, HEIGHT, {
        centered = true,
    })
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
end

function Previewer:update(dt)
    g_pgui:update(dt)
end

function Previewer:draw()
    g_pgui:draw()
end

function Previewer:mousepressed(x, y, button)
	g_pgui:mousepressed(x, y, button)
end

function Previewer:mousereleased(x, y, button)
	g_pgui:mousereleased(x, y, button)
end

function Previewer:keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
	g_pgui:keypressed(key, scancode, isrepeat)
end

function Previewer:keyreleased(key, scancode)
	g_pgui:keyreleased(key, scancode)
end

function Previewer:textinput(text)
	g_pgui:textinput(text)
end

return Previewer
