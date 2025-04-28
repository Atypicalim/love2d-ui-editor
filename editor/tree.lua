--[[
    Tree
]]

local Tree = class("Tree")

function Tree:__init__(parent)
    g_tree = self
    self._parent = parent
    self._background = parent:getById("bgTree"):show()
    self._clickMove = 25
    self._scrollMove = 10
    --
    self._btnUp = parent:getById("btnUp"):show()
    self._btnUp.onClick = function()
        self._treeIndent = self._treeIndent - self._clickMove
        self:_onSlide()
    end
    --
    self._btnDown = parent:getById("btnDown"):show()
    self._btnDown.onClick = function()
        self._treeIndent = self._treeIndent + self._clickMove
        self:_onSlide()
    end
    --
    self._nodeUi  = parent:getById('templateUi')
    self._textUi = self._nodeUi:getById('text'):setText("[GUI]")
    self._btnSelectUi = self._nodeUi:getById('btnSelect')
    self._btnFoldUi = self._nodeUi:getById('btnFold')
    self._btnEditUi = self._nodeUi:getById('btnEdit')
    self._borderUi = self._nodeUi:getById('line')
    self._btnSelectUi.onClick = function()
        g_editor:setTargetConf(nil, true)
    end
    self._btnFoldUi.onClick = function()
        self._isFoldAll = not self._isFoldAll
        for i,v in ipairs(g_editor._template:getConf().children or {}) do
            v.open = not self._isFoldAll
        end
        self._btnFoldUi:setIcon(self._isFoldAll and "media/down.png" or "media/up.png")
        self._treeIndent = 0
        self:refreshTree()

    end
    self._btnEditUi.onClick = function()
        g_editor:setTargetConf(nil, false)
    end
    --
    self._treeIndent = 0
    self:refreshTree()
end

function Tree:updateTree()
    for i,v in ipairs(self._leafs or {}) do
        v:updateStatus()
    end
    local targetConf = g_editor:getTargetConf()
    local selectRoot = targetConf == g_editor.guiConf
    self._borderUi:setColor(selectRoot and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Tree:refreshTree()
    for i,v in ipairs(self._leafs or {}) do
        v:destroy()
    end
    self._leafs = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._bgH = bgH
    self._leafW = bgW * 0.9
    self._leafH = TREE_ITEM_HEIGHT
    self._unitH = self._leafH + TREE_LEAF_MARGIN * 2
    self._leafNumber = bgH / self._unitH
    self._leafX = bgW / 2
    self._treePadding = (bgH - self._unitH * self._leafNumber) / 2
    self._leafDepth = 0
    --
    self._calcLeafCount = 0
    self._skipLeafCount = 0
    self._showLeafCount = 0
    self._leftLeafCount = 0
    self._topLeafY = 0 - self._unitH / 2
    self._bottomLeafY = bgH + self._unitH / 2
    -- 
    self:_createLeaf(g_editor._template:getChildren() or {})
    self:updateTree()
    --
    self._totalTreeH = self._calcLeafCount * self._unitH
    self._maxScrollY = math.max(0, self._totalTreeH - bgH)
    if self._maxScrollY > 0 then
        self._maxScrollY = self._maxScrollY + 50
    end
end

function Tree:_createLeaf(children)
    self._leafDepth = self._leafDepth + 1
    for i,child in ipairs(children) do
        self:__createLeaf(i, child)
    end
    self._leafDepth = self._leafDepth - 1
end

function Tree:__createLeaf(i, child)
    if child:isInnerNode() then
        return
    end
    local config = child:getConf()
    local x = '0.5+' .. ((self._leafDepth - 1) * TREE_LEAF_INDENT)
    local y = self._calcLeafCount * self._unitH + self._unitH / 2
    y = y - self._treeIndent
    --
    self._calcLeafCount = self._calcLeafCount + 1
    if y < self._topLeafY then
        self._skipLeafCount = self._skipLeafCount + 1
    elseif y > self._bottomLeafY then
        self._leftLeafCount = self._leftLeafCount + 1
    else
        local leaf = Leaf(child, x, y, self._leafW, self._leafH)
        table.insert(self._leafs, leaf)
        self._showLeafCount = self._showLeafCount + 1
    end
    -- 
    if config:isConfOpen() then
        self:_createLeaf(child:getChildren())
    end
end

function Tree:refreshLeaf(conf)
    for i,leaf in ipairs(self._leafs) do
        local _conf = leaf:getConf()
        if conf == _conf then
            leaf:updateLeaf()
        end
    end
end

function Tree:wheelmoved(x, y)
    if not self._background:isHover() then
        return
    end
    self._treeIndent = self._treeIndent - y * self._scrollMove
    self:_onSlide()
end

function Tree:_onSlide()

    if self._treeIndent < 0 then
        self._treeIndent = 0
    end
    if self._treeIndent > self._maxScrollY then
        self._treeIndent = self._maxScrollY
    end
    self:refreshTree()
end

function Tree:destroy()
    for i,v in ipairs(self._leafs or {}) do
        v:destroy()
    end
    self._background:hide()
    self._btnUp:hide()
    self._btnDown:hide()
end

return Tree
