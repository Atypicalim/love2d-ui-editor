--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(node, x, y, w, h)
    self._config = node:getConf()
    self._parent = g_tree._parent:getById('clipperTree')
    --
    self._node = self._parent:addChild({
        type = "Node",
		x = x,
		y = y,
		w = w,
		h = h,
	}):addTemplate('./editor/editor_leaf.ui.lua')
    self._bg = self._node:getById('bg'):setColor(rgba2hex(10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 150))
    self._border = self._node:getById('line'):setColor(BORDER_OFF_COLOR)
    self._labelName = self._node:getById('text'):setText("[" .. self._config.type .. "]")
    self._btnSelect = self._node:getById('btnSelect')
    self._btnFold = self._node:getById('btnFold'):setIcon(self._config.open and "media/up.png" or "media/down.png")
    self._btnEdit = self._node:getById('btnEdit'):setIcon("media/edit.png")
    self._btnSelect.onClick = function()
        g_editor:setConf(self._config, true)
    end
    self._btnFold.onClick = function()
        self._config.open = not self._config.open
        g_tree:_updateTree()
    end
    self._btnEdit.onClick = function()
        g_editor:setConf(self._config, false)
    end
    --
end

function Leaf:updateStatus()
    local color = g_editor._conf == self._config and BORDER_ON_COLOR or BORDER_OFF_COLOR
    self._border:setColor(color)
end

function Leaf:destroy()
    self._node:removeSelf()
end

return Leaf
