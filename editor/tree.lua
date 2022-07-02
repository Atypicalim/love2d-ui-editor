--[[
    Tree
]]

local Tree = class("Tree")

function Tree:__init__(parent)
    g_tree = self
    self._parent = parent
    self._root = g_editor._template:getRootNode()
    self._background = Rectangle(g_egui, {
		x = '0.5',
		y = '0.5',
		w = '0.9',
		h = '0.9',
		color = rgba2hex(100, 100, 100, 150),
	}, self._parent)
    --
    self._btnUp = Button(g_egui, {
        x = '0.5',
        y = '0+15',
        w = 15,
        h = 15,
        color = rgba2hex(255, 0, 0),
    }, self._parent)
    self._btnUp:setIcon("/media/angle_up.png")
    self._btnUp.onClick = function()
        if self._treeIndent > 0 then
            self._treeIndent = self._treeIndent - 1
            self:_updateTree()
        end
    end
    --
    self._btnDown = Button(g_egui, {
        x = '0.5',
        y = '1-15',
        w = 15,
        h = 15,
        color = rgba2hex(255, 0, 0),
    }, self._parent)
    self._btnDown:setIcon("/media/angle_down.png")
    self._btnDown.onClick = function()
        if self._leafCount >= TREE_ITEM_COUNT then
            self._treeIndent = self._treeIndent + 1
            self:_updateTree()
        end
    end
    --
    self._treeIndent = 0
    self:_updateTree()
end

function Tree:_updateTree()
    self:destroy()
    self._leafs = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._leafW = bgW * 0.9
    self._leafH = (bgH - TREE_LEAF_MARGIN * TREE_ITEM_COUNT * 2) / TREE_ITEM_COUNT
    self._leafX = bgW / 2
    self._treePadding = (bgH - self._leafH * TREE_ITEM_COUNT) / 2
    self._skippedCount = 0
    self._leafCount = 0
    self._leafDepth = 0
    self:createLeaf(self._root:getChildren())
    --
end

function Tree:createLeaf(children)
    self._leafDepth = self._leafDepth + 1
    for i,v in ipairs(children) do
        if self._leafCount >= TREE_ITEM_COUNT then break end
        local x = '0.5+' .. ((self._leafDepth - 1) * TREE_LEAF_INDENT)
        local y = self._leafH / 2 + TREE_LEAF_MARGIN + (self._leafH + TREE_LEAF_MARGIN * 2) * (#self._leafs)
        Leaf(v, x, y, self._leafW, self._leafH)
    end
    self._leafDepth = self._leafDepth - 1
end

function Tree:update(dt)
    self._background:update(dt)
    self._btnUp:update(dt)
    self._btnDown:update(dt)
    for i,v in ipairs(self._leafs) do
        v:update(dt)
    end
end

function Tree:draw()
    self._background:draw()
    self._btnUp:draw()
    self._btnDown:draw()
    for i,v in ipairs(self._leafs) do
        v:draw(dt)
    end
end

function Tree:destroy()
    for i,v in ipairs(self._leafs or {}) do
        v:destroy()
    end
end

return Tree
