--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Editor = class("Editor")
local Gui = require('gui')

local EDITOR_X = 100
local EDITOR_Y = 100
local EDITOR_W = 1000
local EDITOR_H = 800

function Editor:__init__()
    self.eui = Gui("./editor/editor.ui.lua", EDITOR_W / 2, EDITOR_H / 2, EDITOR_W, EDITOR_H)
end

function Editor:load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
	love.window.setMode(EDITOR_W, EDITOR_H)
	love.window.setPosition(EDITOR_X, EDITOR_Y)
	love.window.setTitle("Editor!")
	love.window.setFullscreen(false)
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
        love.event.quit('restart')
    elseif key == 'space' or key == 'return' then
        --
    end
end

return Editor
