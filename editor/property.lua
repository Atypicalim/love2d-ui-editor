--[[
    Property
]]

local Property = class("Property")

function Property:__init__(key, value, x, y, w, h)
    self._key = key
    self._value = value
    self._parent = g_attribute._parent:getById('clipperAttribute')
    --
    local info = PROPERTY_NAME_INFO[key] or {}
    local length = 18 + (info.ignoreEdit and 3 or 0)
    local name = "[" .. tostring(self._key) .. "][" .. string.sub(tostring(self._value), 1, length)
    if #name > length then
        name = string.sub(name, 1, length - 4) .. "..."
    end
    name = name .. "]"
    --
    if g_attribute._skippedCount < g_attribute._attributeIndent then
        g_attribute._skippedCount = g_attribute._skippedCount + 1
        return
    end
    --
    self._node = self._parent:addChild({
        type = "Node",
		x = x,
		y = y,
		w = w,
		h = h,
	}):addTemplate('./editor/editor_prop.ui.lua')
    self._border = self._node:getById('line'):setColor(BORDER_OFF_COLOR)
    self._labelName = self._node:getById('text'):setText(name)
    self._btnEdit = self._node:getById('btnEdit')
    if info.ignoreEdit then
        self._btnEdit:hide()
        self._labelName:setX("0.5")
    else
        self._btnEdit.onClick = function()
            g_editor:setKey(key)
        end
    end
    --
    table.insert(g_attribute._attributes, self)
    g_attribute._attributesCount = g_attribute._attributesCount + 1
end

function Property:updateStatus()
    self._border:setColor(g_editor._key == self._key and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Property:destroy()
    self._node:removeSelf()
end

return Property
