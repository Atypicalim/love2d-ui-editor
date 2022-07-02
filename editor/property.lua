--[[
    Property
]]

local Property = class("Property")

function Property:__init__(key, value, x, y, w, h)
    self._key = key
    self._value = value
    self._parent = g_attribute._background
    --
    local info = PROPERTY_NAME_INFO[key] or {}
    local length = 20 + (info.ignoreEdit and 3 or 0)
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
    self._background = Rectangle(g_egui, {
		x = x,
		y = y,
		w = w,
		h = h,
		color = rgba2hex(10, 10, 10, 150),
	}, self._parent)
    self._border = Rectangle(g_egui, {
		x = '0.5',
		y = '0.5',
		w = '1',
		h = '1',
		color = rgba2hex(10, 10, 10, 255),
	}, self._background)
    self._labelName = Text(g_egui, {
        type = "Text",
        x = info.ignoreEdit and '0.5' or '0.5-12',
        y = '0.5',
        w = 0,
        h = 0,
        text = name,
    }, self._background)
    if not info.ignoreEdit then
        self._btnEdit = Button(g_egui, {
            x = '1-15',
            y = '0.5',
            w = 15,
            h = 15,
        }, self._background)
        self._btnEdit:setIcon("/media/edit.png")
        self._btnEdit.onClick = function()
            g_editor:setKey(key)
        end
    end
    --
    table.insert(g_attribute._properties, self)
    g_attribute._propertyCount = g_attribute._propertyCount + 1
end

function Property:update(dt)
    self._background:update(dt)
    self._border:update(dt)
    self._labelName:update(dt)
    if self._btnEdit then
        self._btnEdit:update(dt)
    end
end

function Property:draw()
    self._background:draw('fill')
    self._border:draw('line')
    self._labelName:draw('line')
    if self._btnEdit then
        self._btnEdit:draw()
    end
end

function Property:destroy()
    if self._btnEdit then
        self._btnEdit:destroy()
    end
end

return Property
