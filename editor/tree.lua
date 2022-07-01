--[[
    Tree
]]

local Tree = class("Tree")

function Tree:__init__(parent, setNodeFunc)
    g_tree = self
    self._parent = parent
    self._setNodeFunc = setNodeFunc
    self._root = g_editor._template:getRootNode()
    self._background = Rectangle(g_egui, {
		x = '0.5',
		y = '0.5',
		w = '0.9',
		h = '0.9',
		color = {100, 100, 100, 150},
	}, self._parent)
    --
    self:_updateTree()
    --
    self:setNode(nil)
end

function Tree:_updateTree()
    --
    self._leafs = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._leafW = bgW * 0.9
    self._leafH = (bgH - TREE_LEAF_MARGIN * TREE_ITEM_COUNT * 2) / TREE_ITEM_COUNT
    self._leafX = bgW / 2
    self._treePadding = (bgH - self._leafH * TREE_ITEM_COUNT) / 2
    self._leafCount = 0
    self._leafDepth = 1
    for i,v in ipairs(self._root:getChildren()) do
        local leaf = Leaf(v, self._background, bgW / 2, bgH / 2, self._leafW, self._leafH)
        table.insert(self._leafs, leaf)
        if self._leafCount >= TREE_ITEM_COUNT then break end
    end
    --
    for i,v in ipairs(self._leafs) do
        local count = 0
        for ii,vv in ipairs(self._leafs) do
            if vv == v then break end
            count = count + vv:getCount()
        end
        local y = self._leafH / 2 + TREE_LEAF_MARGIN + (self._leafH + TREE_LEAF_MARGIN * 2) * count
        v:setXY(self._leafX, y)
    end
end

function Tree:update(dt)
    self._background:update(dt)
    for i,v in ipairs(self._leafs) do
        v:update(dt)
    end
end

function Tree:draw()
    self._background:draw()
    for i,v in ipairs(self._leafs) do
        v:draw(dt)
    end
end

function Tree:setNode(node)
    self._setNodeFunc(node)
end

return Tree
