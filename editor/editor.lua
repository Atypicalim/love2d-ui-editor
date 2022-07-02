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
    self._template = nil
    --
    self._tree = nil
    self._node = nil
    self._attribute = nil
    --
    self._describe = ""
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
        self:setTemplate("./editor/editor.ui.lua")
    end
end

function Editor:eyreleased(key, scancode)
	g_egui:eyreleased(key, scancode, isrepeat)
end

function Editor:textinput(text)
	g_egui:textinput(text)
end

function Editor:setTemplate(path)
    if self._tree then
        self._tree:destroy()
    end
    self._path = path
    self:setNode(nil)
    if not self._path then
        self._template = nil
        self._tree = nil
        self._describe = ""
    else
        local parent
        parent = g_egui:getById('nodeStage')
        self._template = Gui(self._path, parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
        parent = g_egui:getById('boxTree')
        self._tree = Tree(parent)
        self._describe = 'editing: [' .. self._path .. ']'
    end
end

function Editor:setNode(node)
    if self._attribute then
        self._attribute:destroy()
    end
    self._node = node
    if not self._node then
        self._attribute = nil
        self._describe = 'editing: [' .. self._path .. ']'
    else
        local parent = g_egui:getById('boxProp')
        self._attribute = Attribute(parent)
        self._describe = 'editing: [' .. self._path .. ']'
        self._describe = self._describe .. "  [" .. tostring(self._node:getConf().type) .."]"
        self._describe = self._describe .. "  [" .. tostring(self._node:getConf().id) .. "]"
    end
end

return Editor
