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
    self._node = nil
    self._tree = nil
    self._prop = nil
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
    if self._prop then
        self._prop:update(dt)
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
    if self._prop then
        self._prop:draw()
    else
        self._printer:print(g_egui:getById('bgRight'), "no prop ...")
    end
end

function Editor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    elseif key == 'space' or key == 'return' then
        self:setTemplate("./editor/editor.ui.lua")
    end
end

function Editor:setTemplate(path)
    self._path = path
    self:setNode(nil)
    if not self._path then
        self._template = nil
    else
        local parent
        parent = g_egui:getById('nodeStage')
        self._template = Gui(self._path, parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
        parent = g_egui:getById('boxTree')
        self._tree = Tree(parent, function(node)
            self:setNode(node)
        end)
    end
end

function Editor:setNode(node)
    self._node = node
    if not self._node then
        self._prop = nil
    else
        local parent = g_egui:getById('boxProp')
        self._prop = Prop(parent)
    end
end

return Editor
