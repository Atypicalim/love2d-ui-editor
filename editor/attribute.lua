--[[
    Attribute
]]

local Attribute = class("Attribute")

function Attribute:__init__(parent, setPropertyFunc)
    g_attribute = self
    self._parent = parent
    self._setPropertyFunc = setPropertyFunc
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
        if self._propertyIndent > 0 then
            self._propertyIndent = self._propertyIndent - 1
            self:_updateAttribute()
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
        if self._propertyCount >= ATTRIBUTE_PROPERTY_COUNT then
            self._propertyIndent = self._propertyIndent + 1
            self:_updateAttribute()
        end
    end
    --
    self._propertyIndent = 0
    self:_updateAttribute()
end

function Attribute:updateColor()
    for i,v in ipairs(self._properties or {}) do
        v:updateColor()
    end
end

function Attribute:_updateAttribute()
    self:destroy()
    self._properties = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._propertyW = bgW * 0.9
    self._propertyH = (bgH - ATTRIBUTE_PROPERTY_MARGIN * ATTRIBUTE_PROPERTY_COUNT * 2) / ATTRIBUTE_PROPERTY_COUNT
    self._propertyX = bgW / 2
    self._propertyPadding = (bgH - self._propertyH * ATTRIBUTE_PROPERTY_COUNT) / 2
    self._skippedCount = 0
    self._propertyCount = 0
    self:createProperty(g_editor._conf)
    --
end

function Attribute:createProperty(config)
    for i,key in ipairs(PROPERTY_NAME_ORDER) do
        if self._propertyCount >= ATTRIBUTE_PROPERTY_COUNT then break end
        local value = config[key]
        local info = PROPERTY_NAME_INFO[key] or {}
        if not info.ignoreProperty and value ~= nil then
            local y = self._propertyH / 2 + ATTRIBUTE_PROPERTY_MARGIN + (self._propertyH + ATTRIBUTE_PROPERTY_MARGIN * 2) * (#self._properties)
            Property(key, value, '0.5', y, self._propertyW, self._propertyH)
        end
    end
end

function Attribute:update(dt)
    self._background:update(dt)
    self._btnUp:update(dt)
    self._btnDown:update(dt)
    for i,v in ipairs(self._properties) do
        v:update(dt)
    end
end

function Attribute:draw()
    self._background:draw()
    self._btnUp:draw()
    self._btnDown:draw()
    for i,v in ipairs(self._properties) do
        v:draw(dt)
    end
end

function Attribute:destroy()
    for i,v in ipairs(self._properties or {}) do
        v:destroy()
    end
end

return Attribute
