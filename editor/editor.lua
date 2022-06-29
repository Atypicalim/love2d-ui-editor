--[[
	editor
]]

local Editor = Object:ext()
local Gui = require('gui')

function Editor:init()
    self.eui = Gui:new("./editor/editor.ui.lua")
end

function Editor:load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    self.eui:load()
end

function Editor:update(dt)
    self.eui:update(dt)
end

function Editor:draw()
    self.eui:draw()
end

function Editor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        if debug then
            love.event.quit('restart')
        end
    elseif key == 'space' or key == 'return' then
        if debug then
            updateWindow()
        end
    end
    print(key, scancode, isrepeat)
end

return Editor
