--[[
    Property
]]

local Property = class("Property")

function Property:__init__(key, value, x, y, w, h)
    self._key = key
    self._value = value
    self._parent = g_attribute._clipper
    --
    local info = PROPERTY_NAME_INFO[key] or {}
    local length = 18 + (info.ignoreEdit and 3 or 0)
    local name = "[" .. tostring(self._key) .. "][" .. string.sub(tostring(self._value), 1, length)
    if #name > length then
        name = string.sub(name, 1, length - 4) .. "..."
    end
    name = name .. "]"
    --
    if g_attribute._skippedCount < g_attribute._propertyIndent then
        g_attribute._skippedCount = g_attribute._skippedCount + 1
        return
    end
    --
    self._background = self._parent:newConfig({
        type = "Rectangle",
		x = x,
		y = y,
		w = w,
		h = h,
		color = rgba2hex(10, 10, 10, 150),
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
        x = info.ignoreEdit and '0.5' or '0.5-12',
        y = '0.5',
        w = 0,
        h = 0,
        text = name,
    })
    if not info.ignoreEdit then
        self._btnEdit = self._background:newConfig({
            type = "Button",
            x = '1-15',
            y = '0.5',
            w = 15,
            h = 15,
        })
        self._btnEdit:setIcon("/media/edit.png")
        self._btnEdit.onClick = function()
            g_editor:setKey(key)
        end
    end
    --
    table.insert(g_attribute._properties, self)
    g_attribute._propertyCount = g_attribute._propertyCount + 1
end

function Property:updateColor()
    self._border:setColor(g_editor._key == self._key and BORDER_ON_COLOR or BORDER_OFF_COLOR)
end

function Property:destroy()
    self._background:destroy()
end

return Property
