--[[
    Control
]]

local Control = class("Control")

function Control:__init__(name, conf, x, y, w, h)
    self._key = key
    self._value = value
    self._parent = g_attribute._parent:getById('clipperAttribute')
    --
    if g_attribute._skippedCount < g_attribute._attributeIndent then
        g_attribute._skippedCount = g_attribute._skippedCount + 1
        return
    end
    --
    self._node = self._parent:addConfig({
        type = "Node",
		x = x,
		y = y,
		w = w,
		h = h,
	}):addTemplate('./editor/editor_ctrl.ui.lua')
    self._border = self._node:getById('line'):setColor(BORDER_OFF_COLOR)
    self._labelName = self._node:getById('text'):setText("[" .. name .. "]")
    self._node:getById('btnAddBefore').onClick = function()
        g_editor:addControl(name, -1)
    end
    self._node:getById('btnAddIn').onClick = function()
        g_editor:addControl(name, 0)
    end
    self._node:getById('btnAddAfter').onClick = function()
        g_editor:addControl(name, 1)
    end
    --
    table.insert(g_attribute._attributes, self)
    g_attribute._attributesCount = g_attribute._attributesCount + 1
end

function Control:updateStatus()
end

function Control:destroy()
    self._node:removeSelf()
end

return Control
