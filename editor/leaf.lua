--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(config, x, y, w, h)
    self._config = config
    self._parent = g_tree._clipper
    --
    if g_tree._skippedCount < g_tree._treeIndent then
        g_tree._skippedCount = g_tree._skippedCount + 1
        g_tree:createLeaf(self._config.open and self._config.children or {})
        return
    end
    --
    self._background = self._parent:newConfig({
        type = "Rectangle",
		x = x,
		y = y,
		w = w,
		h = h,
		color = rgba2hex(10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 150),
	})
    self._border = self._background:newConfig({
        type = "Rectangle",
		x = '0.5',
		y = '0.5',
		w = '1',
		h = '1',
        mode = 'line',
		color = BORDER_OFF_COLOR,
	})
    self._labelName = self._background:newConfig({
        type = "Text",
        x = '0.5',
        y = '0.5',
        w = 0,
        h = 0,
        text = "[" .. self._config.type .. "]",
    })
    self._btnFold = self._background:newConfig({
        type = "Button",
        x = '0+15',
        y = '0.5',
        w = 15,
        h = 15,
    })
    self._btnFold:setIcon(self._config.open and "/media/up.png" or "/media/down.png")
    self._btnFold.onClick = function()
        self._config.open = not self._config.open
        g_tree:_updateTree()
    end
    self._btnEdit = self._background:newConfig({
        type = "Button",
        x = '1-15',
        y = '0.5',
        w = 15,
        h = 15,
    })
    self._btnEdit:setIcon("/media/edit.png")
    self._btnEdit.onClick = function()
        g_editor:setConf(self._config)
    end
    --
    table.insert(g_tree._leafs, self)
    g_tree._leafCount = g_tree._leafCount + 1
    g_tree:createLeaf(self._config.open and self._config.children or {})
end

function Leaf:updateColor()
    self._border:setColor(g_editor._conf == self._config and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Leaf:destroy()
    self._background:removeSelf()
end

return Leaf
