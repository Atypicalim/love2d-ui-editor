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
    self.template = nil
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
    if self.template then
        self.template:update(dt)
    end
end

function Editor:draw()
    self.eui:draw()
    if self.template then
        self.template:draw(dt)
    end
end

function Editor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    elseif key == 'space' or key == 'return' then
        local node = self.eui:getById('nodeStage')
        local x = node:getX()
        local y = node:getY()
        local w = node:getW() - 100
        local h = node:getH() - 100
        self.template = Gui("./editor/editor.ui.lua", x, y, w, h)
    end
end

return Editor
