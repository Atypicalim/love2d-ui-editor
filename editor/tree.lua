--[[
    Tree
]]

local Tree = class("Tree")

function Tree:__init__(parent)
    g_tree = self
    self._parent = parent
    self._background = parent:getById("bgTree"):show()
    --
    self._btnUp = parent:getById("btnUp"):show()
    self._btnUp.onClick = function()
        if self._treeIndent > 0 then
            self._treeIndent = self._treeIndent - 1
            self:_updateTree()
            -- g_editor:setConf(nil, true)
        end
    end
    --
    self._btnDown = parent:getById("btnDown"):show()
    self._btnDown.onClick = function()
        if self._leafCount >= TREE_ITEM_COUNT then
            self._treeIndent = self._treeIndent + 1
            self:_updateTree()
            -- g_editor:setConf(nil, true)
        end
    end
    --
    self._nodeUi  = parent:getById('templateUi')
    self._textUi = self._nodeUi:getById('text'):setText("[GUI]")
    self._btnSelectUi = self._nodeUi:getById('btnSelect')
    self._btnFoldUi = self._nodeUi:getById('btnFold')
    self._btnEditUi = self._nodeUi:getById('btnEdit')
    self._borderUi = self._nodeUi:getById('line')
    self._btnSelectUi.onClick = function()
        g_editor:setConf(g_editor.guiConf, true)
    end
    self._btnFoldUi.onClick = function()
        self._isFoldAll = not self._isFoldAll
        for i,v in ipairs(g_editor._template:getConf().children or {}) do
            v.open = not self._isFoldAll
        end
        self._btnFoldUi:setIcon(self._isFoldAll and "/media/down.png" or "/media/up.png")
        self._treeIndent = 0
        self:_updateTree()

    end
    self._btnEditUi.onClick = function()
        g_editor:setConf(g_editor.guiConf, false)
    end
    --
    self._treeIndent = 0
    self:_updateTree()
end

function Tree:updateStatus()
    for i,v in ipairs(self._leafs or {}) do
        v:updateStatus()
    end
    self._borderUi:setColor(g_editor._conf == g_editor.guiConf and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Tree:_updateTree()
    for i,v in ipairs(self._leafs or {}) do
        v:destroy()
    end
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
    self:createLeaf(g_editor._template:getConf().children or {})
    self:updateStatus()
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

function Tree:wheelmoved(x, y)
    if not self._background:isHover() then
        return
    end
    if y > 0 then
        self._btnUp.onClick()
    end
    if y < 0 then
        self._btnDown.onClick()
    end
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
