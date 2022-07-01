--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Editor = class("Editor")
local Gui = require('gui')
local Printer = require('editor/printer')

local EDITOR_X = 100
local EDITOR_Y = 100
local EDITOR_W = 1000
local EDITOR_H = 800

function Editor:__init__()
    --
    self.eui = Gui("./editor/editor.ui.lua", EDITOR_W / 2, EDITOR_H / 2, EDITOR_W, EDITOR_H)
    self._printer = Printer(self)
    --
    self._path = nil
    self._template = nil
    --
    self._config = nil
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
    self.eui:update(dt)
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
    self.eui:draw()
    if self._template then
        self._template:draw()
    else
        self._printer:print(self.eui:getById('nodeStage'), "please select a ui file ...")
    end
    if self._tree then
        self._tree:draw()
    else
        self._printer:print(self.eui:getById('bgLeft'), "no tree ...")
    end
    if self._prop then
        self._prop:draw()
    else
        self._printer:print(self.eui:getById('bgRight'), "no prop ...")
    end
end

function Editor:keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f5' then
        love.event.quit('restart')
    elseif key == 'space' or key == 'return' then
        self:setPath("./editor/editor.ui.lua")
    end
end

function Editor:setPath(path)
    self._path = path
    self:setConfig(nil)
    if not self._path then
        self._template = nil
    else
        local node
        node = self.eui:getById('nodeStage')
        self._template = Gui(self._path, node:getX(), node:getY(), node:getW() - 100, node:getH() - 100)
        node = self.eui:getById('bgLeft')
        self._tree = Tree(self, self._config, node:getX(), node:getY(), node:getW() - 20, node:getH() - 20)
    end
end

function Editor:setConfig(config)
    self._config = config
    if not self._config then
        self._prop = nil
    else
        local node = self.eui:getById('bgRight')
        self._prop = Prop(self, self._config, node:getX(), node:getY(), node:getW() - 20, node:getH() - 20)
    end
end

return Editor
