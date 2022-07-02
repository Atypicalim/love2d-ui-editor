--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Editor = class("Editor")
local Gui = require('gui')
require('editor/constants')
Printer = require('editor/printer')
Leaf = require('editor/leaf')
Tree = require('editor/tree')
Property = require('editor/property')
Attribute = require('editor/attribute')
Field = require('editor/field')

local EDITOR_X = 100
local EDITOR_Y = 100
local EDITOR_W = 1000
local EDITOR_H = 800

function Editor:__init__()
    --
    g_editor = self
    g_egui = Gui("./editor/editor.ui.lua", EDITOR_W / 2, EDITOR_H / 2, EDITOR_W, EDITOR_H)
    self._printer = Printer()
    --
    self._path = nil
    self._conf = nil
    self._key = nil
    --
    self._template = nil
    self._tree = nil
    self._attribute = nil
    self._field = nil
    --
    self._describe = ""
    self:setPath("./editor/editor.ui.lua")
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
    g_egui:update(dt)
    if self._template then
        self._template:update(dt)
    end
    if self._tree then
        self._tree:update(dt)
    end
    if self._attribute then
        self._attribute:update(dt)
    end
    if self._field then
        self._field:update(dt)
    end
end

function Editor:draw()
    g_egui:draw()
    if self._template then
        self._template:draw()
    else
        self._printer:print(g_egui:getById('nodeStage'), "please select a ui file ...")
    end
    if self._tree then
        self._tree:draw()
    else
        self._printer:print(g_egui:getById('bgLeft'), "no tree ...")
    end
    if self._attribute then
        self._attribute:draw()
    else
        self._printer:print(g_egui:getById('bgRight'), "no attribute ...")
    end
    if self._field then
        self._field:draw()
    else
        self._printer:print(g_egui:getById('bgBottom'), "no input ...")
    end

    self._printer:print(g_egui:getById('nodeStage'), self._describe, '0.5', '0+15')
end

function Editor:mousepressed(x, y, button)
	g_egui:mousepressed(x, y, button)
end

function Editor:mousereleased(x, y, button)
	g_egui:mousereleased(x, y, button)
end

function Editor:keypressed(key, scancode, isrepeat)
	g_egui:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    elseif key == 'space' or key == 'return' then
        self:setPath("./editor/editor.ui.lua")
    end
end

function Editor:keyreleased(key, scancode)
	g_egui:keyreleased(key, scancode)
end

function Editor:textinput(text)
	g_egui:textinput(text)
end

function Editor:setPath(path)
    if self._tree then
        self._tree:destroy()
    end
    self._path = path
    self:setConf(nil)
    if not self._path then
        self._template = nil
        self._tree = nil
    else
        local parent = g_egui:getById('nodeStage')
        self._template = Gui(self._path, parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
        self._tree = Tree(g_egui:getById('boxTree'))
    end
end

function Editor:setConf(conf)
    if self._attribute then
        self._attribute:destroy()
    end
    self._conf = conf
    self:setKey(nil)
    if not self._conf then
        self._attribute = nil
    else
        self._attribute = Attribute(g_egui:getById('boxProp'))
    end
end

function Editor:setKey(key)
    if self._field then
        self._field:destroy()
    end
    self._key = key
    if not self._key then
        self._field = nil
    else
        self._field = Field(g_egui:getById('bgBottom'))
    end
    self:_updateDescribe()
end

function Editor:setValue(textValue)
    local oldValue = g_editor._conf[g_editor._key]
    local newValue = to_type(textValue, type(oldValue))
    if newValue ~= nil then
        g_editor._conf[g_editor._key] = newValue
    end
    g_attribute:_updateAttribute()
end

function Editor:_updateDescribe()
    self._describe = ""
    if not self._path then return end
    self._describe = 'editing: [' .. self._path .. ']'
    if not self._conf then return end
    self._describe = self._describe .. "  [" .. tostring(self._conf.type) .."]"
    self._describe = self._describe .. "  [" .. tostring(self._conf.id) .. "]"
    if not self._key then return end
    self._describe = self._describe .. "  [" .. tostring(self._key) .."]"
end

return Editor
