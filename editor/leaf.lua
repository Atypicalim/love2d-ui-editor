--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(config, x, y, w, h)
    self._config = config
    self._parent = g_tree._parent:getById('clipperTree')
    --
    if g_tree._skippedCount < g_tree._treeIndent then
        g_tree._skippedCount = g_tree._skippedCount + 1
        g_tree:createLeaf(self._config.open and self._config.children or {})
        return
    end
    --
    self._node = self._parent:newConfig({
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
    table.insert(g_tree._leafs, self)
    g_tree._leafCount = g_tree._leafCount + 1
    g_tree:createLeaf(self._config.open and self._config.children or {})
end

function Leaf:updateStatus()
    self._border:setColor(g_editor._conf == self._config and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Leaf:destroy()
    self._node:removeSelf()
end

return Leaf
