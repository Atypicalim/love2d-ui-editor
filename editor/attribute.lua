--[[
    Attribute
]]

local Attribute = class("Attribute")

function Attribute:__init__(parent, setPropertyFunc)
    g_attribute = self
    self._parent = parent
    self._setPropertyFunc = setPropertyFunc
    self._background = parent:newConfig({
        type = "Rectangle",
		x = '0.5',
		y = '0.5',
		w = '0.9',
		h = '0.9',
		color = "#1e1e1e",
	})
    self._clipper = self._background:newConfig({
        type = "Clipper",
		x = '0.5',
		y = '0.5',
		w = '1',
		h = '1',
	})
    --
    self._btnUp = parent:newConfig({
        type = "Button",
        x = '0.5',
        y = '0+15',
        w = 15,
        h = 15,
        color = rgba2hex(255, 0, 0),
    })
    self._btnUp:setIcon("/media/angle_up.png")
    self._btnUp.onClick = function()
        if self._propertyIndent > 0 then
            self._propertyIndent = self._propertyIndent - 1
            self:_updateAttribute()
            g_editor:setKey(nil)
        end
    end
    --
    self._btnDown = parent:newConfig({
        type = "Button",
        x = '0.5',
        y = '1-15',
        w = 15,
        h = 15,
        color = rgba2hex(255, 0, 0),
    })
    self._btnDown:setIcon("/media/angle_down.png")
    self._btnDown.onClick = function()
        if self._propertyCount >= ATTRIBUTE_PROPERTY_COUNT then
            self._propertyIndent = self._propertyIndent + 1
            self:_updateAttribute()
            g_editor:setKey(nil)
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
    for i,v in ipairs(self._properties or {}) do
        v:destroy()
    end
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
    self:updateColor()
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

function Attribute:wheelmoved(x, y)
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX < self._background:getLeft() or mouseX > self._background:getRight() then
        return
    elseif mouseY < self._background:getTop() or mouseY > self._background:getBottom() then
        return
    end
    if y > 0 then
        self._btnUp.onClick()
    end
    if y < 0 then
        self._btnDown.onClick()
    end
end

function Attribute:destroy()
    for i,v in ipairs(self._properties or {}) do
        v:destroy()
    end
    self._background:destroy()
    self._btnUp:destroy()
    self._btnDown:destroy()
end

return Attribute
