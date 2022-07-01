--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(node, parent, x, y, w, h)
    self._node = node
    self._parent = parent
    self._isOpen = node:getConf().open == true
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
    self._btnFold = Button(g_egui, {
        x = '0.9',
        y = '0.5',
        w = 15,
        h = 15,
        icon = "/media/down.png",
    }, self._background)
    --
    self._leafs = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._leafW = bgW
    self._leafH = bgH
    self._leafX = bgW / 2 + TREE_LEAF_INDENT
    g_tree._leafCount = g_tree._leafCount + 1
    g_tree._leafDepth = g_tree._leafDepth + 1
    for i,v in ipairs(self._isOpen and self._node:getChildren() or {}) do
        local leaf = Leaf(v, self._background, self._leafX, '1', self._leafW, self._leafH)
        table.insert(self._leafs, leaf)
        if g_tree._leafCount >= TREE_ITEM_COUNT then break end
    end
    g_tree._leafDepth = g_tree._leafDepth - 1
    --
    self:_updateLeafs()
    --
end

function Leaf:setXY(x, y)
    self._background:setXY(x, y)
    self._border:setXY('0.5', '0.5')
    self._btnFold:setXY('0.5', '0.5')
    self:_updateLeafs()
end

function Leaf:_updateLeafs()
    for i,v in ipairs(self._leafs) do
        local count = 0
        for ii,vv in ipairs(self._leafs) do
            if vv == v then break end
            count = count + vv:getCount()
        end
        local y = self._leafH / 2 + (self._leafH + TREE_LEAF_MARGIN * 2) * (count + 1)
        v:setXY(self._leafX, y)
    end
end

function Leaf:update(dt)
    self._background:update(dt)
    self._border:update(dt)
    self._btnFold:update(dt)
    for i,v in ipairs(self._leafs) do
        v:update(dt)
    end
end

function Leaf:draw()
    self._background:draw('fill')
    self._border:draw('line')
    self._btnFold:draw()
    for i,v in ipairs(self._leafs) do
        v:draw(dt)
    end
end

function Leaf:getCount()
    local count = 1
    if not self._isOpen then
        return count
    end
    for i,v in ipairs(self._leafs) do
        count = count + v:getCount()
    end
    return count
end

return Leaf
