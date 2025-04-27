--[[
    Leaf
]]

local Leaf = class("Leaf")

function Leaf:__init__(node, x, y, w, h)
    self._conf = node:getConf()
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
    self:updateLeaf()
    -- 
    self._btnSelect.onClick = function()
        g_editor:setConf(self._conf, true)
    end
    self._btnFold.onClick = function()
        if self._conf.hide and not self._conf.open then
            g_editor:pushMessage('cannot fold/unfold hidden node!')
        else
            self._conf.open = not self._conf.open
            g_tree:_updateTree()
        end
    end
    self._btnEdit.onClick = function()
        g_editor:setConf(self._conf, false)
    end
    --
end

function Leaf:updateLeaf()
    --
    local text = self._conf.type
    if string.valid(self._conf.id) then
        text = limit_text(text .. ":" .. self._conf.id, 20)
    end
    --
    self._labelName = self._node:getById('text'):setText("[" .. text .. "]")
    self._btnSelect = self._node:getById('btnSelect')
    self._btnFold = self._node:getById('btnFold')
    self._btnEdit = self._node:getById('btnEdit'):setIcon("media/edit.png")
    --
    local foldPath = nil
    if self._conf.hide then
        foldPath = ICON_HIDDEN
    else
        foldPath = self._conf.open and "media/up.png" or "media/down.png"
    end
    self._btnFold:setIcon(foldPath)
end

function Leaf:getConf()
    return self._conf
end

function Leaf:updateStatus()
    local color = g_editor._conf == self._conf and BORDER_ON_COLOR or BORDER_OFF_COLOR
    self._border:setColor(color)
end

function Leaf:destroy()
    self._node:removeSelf()
end

return Leaf
