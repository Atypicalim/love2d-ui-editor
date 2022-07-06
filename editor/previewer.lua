--[[
	editor
]]

require('thirds/tools/test')
require('thirds/gooi/gooi')

local Previewer = class("Previewer")
local gui = require('gui')

function Previewer:__init__(path)
    self._path = path or './template/app.ui.lua'
    gui.useProxy(self)
    g_previewer = self
end

function Previewer:load()
	love.window.setMode(PREVIEW_WIDTH, PREVIEW_HEIGHT, {
        minwidth = PREVIEW_WIDTH,
        minheight = PREVIEW_HEIGHT,
        resizable = true,
        centered = true,
    })
    g_pgui = gui.newGUI():setXYWH(PREVIEW_WIDTH / 2, PREVIEW_HEIGHT / 2, PREVIEW_WIDTH, PREVIEW_HEIGHT):addTemplate(self._path)
    -- local btnTest = g_pgui:getById("btnTest")
    -- btnTest.onClick = function()
    --     print("onclick---")
    -- end
    local inputTest = g_pgui:getById("inputTest")
    -- love.keyboard.setTextInput(true)
end

function Previewer:keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
end

function Previewer:mousepressed(x, y, button)
	gooi.pressed()
end

function Previewer:mousereleased(x, y, button)
	gooi.released()
end

function Previewer:mousemoved( x, y, dx, dy, istouch)
end

function Previewer:draw()
	gooi.draw()
end

function Previewer:resize(width, height)
    g_pgui:setXYWH(width / 2, height / 2, width, height)
end

return Previewer
