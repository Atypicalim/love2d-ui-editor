--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Previewer = class("Previewer")
local gui = require('gui')

function Previewer:__init__(path)
    gui.useProxy(self)
    g_previewer = self
    g_pgui = gui.newGUI(path or './template/app.ui.lua'):customize(PREVIEW_WIDTH / 2, PREVIEW_HEIGHT / 2, PREVIEW_WIDTH, PREVIEW_HEIGHT)
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

function Previewer:keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
end

return Previewer
