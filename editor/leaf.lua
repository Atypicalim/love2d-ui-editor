--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(node, x, y, w, h)
    self._node = node
    self._parent = g_tree._background
    self._isOpen = node:getConf().open == true
    --
    if g_tree._skippedCount < g_tree._treeIndent then
        g_tree._skippedCount = g_tree._skippedCount + 1
        g_tree:createLeaf(self._isOpen and self._node:getChildren() or {})
        return
    end
    --
    self._background = Rectangle(g_egui, {
		x = x,
		y = y,
		w = w,
		h = h,
		color = {10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 10 * g_tree._leafDepth, 150},
	}, self._parent)
    self._border = Rectangle(g_egui, {
		x = '0.5',
		y = '0.5',
		w = '1',
		h = '1',
		color = {10, 10, 10, 255},
	}, self._background)
    self._labelName = Text(g_egui, {
        type = "Text",
        x = '0.5',
        y = '0.5',
        w = 0,
        h = 0,
        text = "[" .. self._node:getConf().type .. "]",
    }, self._background)
    self._btnFold = Button(g_egui, {
        x = '0+15',
        y = '0.5',
        w = 15,
        h = 15,
    }, self._background)
    self._btnFold:setIcon(self._isOpen and "/media/up.png" or "/media/down.png")
    self._btnFold.onClick = function()
        node:getConf().open = not node:getConf().open
        g_tree:_updateTree()
    end
    self._btnEdit = Button(g_egui, {
        x = '1-15',
        y = '0.5',
        w = 15,
        h = 15,
    }, self._background)
    self._btnEdit:setIcon("/media/edit.png")
    self._btnEdit.onClick = function()
        g_editor:setNode(self._node)
    end
    --
    table.insert(g_tree._leafs, self)
    g_tree._leafCount = g_tree._leafCount + 1
    g_tree:createLeaf(self._isOpen and self._node:getChildren() or {})
end

function Leaf:update(dt)
    self._background:update(dt)
    self._border:update(dt)
    self._labelName:update(dt)
    self._btnFold:update(dt)
    self._btnEdit:update(dt)
end

function Leaf:draw()
    self._background:draw('fill')
    self._border:draw('line')
    self._labelName:draw('line')
    self._btnFold:draw()
    self._btnEdit:draw()
end

function Leaf:getCount()
    local count = 1
    if not self._isOpen then
        return count
    end
    return count
end

function Leaf:destroy()
    self._btnFold:destroy()
    self._btnEdit:destroy()
end

return Leaf
