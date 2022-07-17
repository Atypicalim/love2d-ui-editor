--[[
	editor
]]

require('tools/tools')

local Previewer = class("Previewer")
local gui = require('gui/gui')

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
    local video = g_pgui:getById("idVideo")
    local button = g_pgui:getById("idButton")
    button.onClick = function()
        if video:getLove():isPlaying() then
            video:getLove():pause()
        else
            video:getLove():play()
        end
    end
end

function Previewer:keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
end

function Previewer:resize(width, height)
    g_pgui:setXYWH(width / 2, height / 2, width, height)
end

return Previewer
