--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Previewer = class("Previewer")
local Gui = require('gui')

function Previewer:__init__(path)
    g_previewer = self
    g_pgui = Gui(path or './template/app.ui.lua'):customize(PREVIEW_WIDTH / 2, PREVIEW_HEIGHT / 2, PREVIEW_WIDTH, PREVIEW_HEIGHT)
end

function Previewer:load()

	love.window.setMode(PREVIEW_WIDTH, PREVIEW_HEIGHT, {
        minwidth = PREVIEW_WIDTH,
        minheight = PREVIEW_HEIGHT,
        resizable = true,
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

function Previewer:resize(width, height)
    g_pgui:customize(width / 2, height / 2, width, height)
end

function Previewer:wheelmoved(x, y)
    g_pgui:wheelmoved(x, y)
end

return Previewer
