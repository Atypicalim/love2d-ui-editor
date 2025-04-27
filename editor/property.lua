--[[
    Property
]]

local Pair = class("Pair")

function Pair:__init__(flag, prefix, config)
    -- 
    self._config = config
    local _key = prefix .. flag
    local value = self._config:getValueForKey(_key)
    if value == nil then
        value = self._config:getValueForKey(flag)
    end
    --
    self._flag = flag
    self._key = _key
    self._value = value
    self._info = PROPERTY_NAME_INFO[self._key] or {}
end

function Pair:isValid()
    return self._value ~= nil
end

function Pair:getKey()
    return self._key
end

function Pair:getValue()
    return self._value
end

function Pair:setValue(value)
    self._value = value
    self._config:setValueForKey(self._key, value)
end

function Pair:getText(isSmall)
    --
    if self:isPairColor() then
        return self._value
    elseif self:isPairSwitch() then
        return self._key
    end
    -- 
    if isSmall then
        local len = 7
        assert(#self._flag == 1, 'invalid pair key')
        local _val = limit_text(tostring(self._value), len)
        local text = string.format("%s:%s", self._flag, _val)
        return text
    else
        local _key = limit_text(self._key, 10)
        local _val = limit_text(tostring(self._value), 15)
        local text = string.format("[%s][%s]", _key, _val)
        return text
    end
end

function Pair:ignoreEdit()
    return self._info.ignoreEdit
end

function Pair:isPairColor()
    if is_string(self._value) and string.starts(self._value, "#") then
        return #self._value == 7 or #self._value == 9
    end
end

function Pair:isPairSwitch()
    return is_boolean(self._value)
end


local Property = class("Property")

function Property:__init__(key, config, x, y, w, h)
    --
    self._config = config
    self._multiKey = false
    if PROPERTY_MULTIPLE_KEY[key] then
        self._multiKey = true
        local parts = string.explode(key, "%_")
        assert(#parts == 3, 'invalid pair key')
        self._name = parts[1]
        local prefix = string.sub(self._name, 1, 1)
        self._pair1 = Pair(parts[2], prefix, config)
        self._pair2 = Pair(parts[3], prefix, config)
        self._isValid = self._pair1:isValid() and self._pair2:isValid()
    else
        self._name = key
        self._pair = Pair(key, "", config)
        self._key = key
        self._isValid = self._pair:isValid()
    end 
    --
    if not self._isValid then
        return
    end
    --
    if g_attribute._skippedCount < g_attribute._attributeIndent then
        g_attribute._skippedCount = g_attribute._skippedCount + 1
        return
    end
    --
    self._propX = x
    self._propY = y
    self._propW = w
    self._propH = h
    --
    self:updateProperty()
    table.insert(g_attribute._attributes, self)
    g_attribute._attributesCount = g_attribute._attributesCount + 1
end

function Property:canHandle(key)
    if self._pair then
        return self._pair:getKey() == key
    else
        return self._pair1:getKey() == key or self._pair2:getKey() == key
    end
end

function Property:updateProperty()
    self:_clearProp()
    local x = self._propX
    local y = self._propY
    local w = self._propW
    local h = self._propH
    if self._multiKey then
        local parent = g_attribute._parent:getById('clipperAttribute')
        self._propNode = parent:addChild({type = "Rectangle", color = "#151515", x = x, y = y, w = w, h = h,})
        self._propParent = self._propNode
        self._propParent:addChild({type = "Text", text =self._name, x = '0.5', y = '0.2', w = '1', h = '1',})
        _, self._borderLine1 = self:_addProp(self._pair1, true, '0.25', '0.65', w * 0.45, h * 0.5)
        _, self._borderLine2 = self:_addProp(self._pair2, false, '0.75', '0.65', w * 0.45, h * 0.5)
    elseif self._pair:isPairColor() then
        local parent = g_attribute._parent:getById('clipperAttribute')
        self._propNode = parent:addChild({type = "Rectangle", color = "#151515", x = x, y = y, w = w, h = h,})
        self._propParent = self._propNode
        local color = self._pair:getValue()
        local _color = self._propNode:addChild({type = "Rectangle", color = color, x = '0.5', y = '0.5', w = '0.95', h = '0.9',})
        _, self._borderLine = self:_addProp(self._pair, nil, '0.5', '0.5', '0.5', '0.5')
        local btnEdit = self._propNode:getById('btnEdit')
        btnEdit:setIcon(ICON_COLOR)
    elseif self._pair:isPairSwitch() then
        local parent = g_attribute._parent:getById('clipperAttribute')
        self._propNode = parent:addChild({type = "Rectangle", color = "#151515", x = x, y = y, w = w, h = h,})
        self._propParent = self._propNode
        local color = self._pair:getValue() and "#221111" or "#112211"
        local _color = self._propNode:addChild({type = "Rectangle", color = color, x = '0.5', y = '0.5', w = '0.95', h = '0.9',})
        _, self._borderLine = self:_addProp(self._pair, nil, '0.5', '0.5', '0.5', '0.5')
        local btnEdit = self._propNode:getById('btnEdit')
        btnEdit:setIcon(self._pair:getValue() and ICON_SWITCH_ON or ICON_SWITCH_OFF)
    else
        self._propParent = g_attribute._parent:getById('clipperAttribute')
        self._propNode, self._borderLine = self:_addProp(self._pair, nil, x, y, w, h)
    end
end

function Property:_addProp(pair, direction, x, y, w, h)
    local key = pair:getKey()
    local text = pair:getText(self._multiKey)
    local node = self._propParent:addChild({
        type = "Node",
        id = "prop_" .. key,
		x = x,
		y = y,
		w = w,
		h = h,
	}):addTemplate('./editor/editor_prop.ui.lua')
    local rectLine = node:getById('line')
    local labelText = node:getById('text')
    labelText:setText(text)
    -- 
    local btnEdit = node:getById('btnEdit')
    if pair:ignoreEdit() then
        btnEdit:hide()
        labelText:setX("0.5")
    else
        btnEdit.onClick = function()
            self:_onEdit(pair)
        end
    end
    return node, rectLine
end

function Property:_onEdit(pair)
    --
    local key = pair:getKey()
    local val = pair:getValue()
    if pair:isPairColor() then
        if g_editor:isEditing() then
            g_editor:setKey(nil)
            return
        end
        local r, g, b = dialog.select_color()
        if r and g and b then
            local _val = colors.rgb_to_str({r, g, b})
            pair:setValue(_val)
            g_editor:onEdited(self._config:getConf(), key)
        end
    elseif pair:isPairSwitch() then
        g_editor:setKey(nil)
        pair:setValue(not pair:getValue())
        g_editor:onEdited(self._config:getConf(), key)
    else
        g_editor:setKey(key)
        g_editor._field = Field(g_egui:getById('bgBottom'), function(text)
            local new = to_type(text, type(val))
            if new ~= nil then
                pair:setValue(new)
            end
            g_editor:onEdited(self._config:getConf(), key)
        end, function(text)
            g_editor:onEdited()
        end)
    end
end

function Property:updateStatus()
    if self._borderLine then
        self._borderLine:setColor(g_editor._key == self._pair:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
    else
        self._borderLine1:setColor(g_editor._key == self._pair1:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
        self._borderLine2:setColor(g_editor._key == self._pair2:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
    end
end

function Property:_clearProp()
    if self._propNode then
        self._propNode:removeSelf()
        self._propNode = nil
    end
end

function Property:destroy()
    self:_clearProp()
end

return Property
