--[[
    Property
]]

local Property = class("Property")

function Property:__init__(key, config, x, y, w, h)
    --
    self._config = config
    self._multiKey = false
    if PROPERTY_INFO_MAP[key].multiKey then
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

function Property:_parseProp()
    if self._pair then
        self._pair:parsePair()
    else
        self._pair1:parsePair()
        self._pair2:parsePair()
    end
end

function Property:updateProperty()
    self:_parseProp()
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
	}):addTemplate('./editor/ui/editor_prop.ui.lua')
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
            g_editor:tryEndEdit()
            return
        end
        local r, g, b = dialog.select_color()
        if r and g and b then
            local _val = colors.rgb_to_str({r, g, b})
            pair:setValue(_val)
            g_editor:onEditEnd(self._config, key)
        end
    elseif pair:isPairSwitch() then
        g_editor:tryEndEdit()
        pair:setValue(not pair:getValue())
        g_editor:onEditEnd(self._config, key)
    elseif pair:isPairPath() then
        if g_editor:isEditing() then
            g_editor:tryEndEdit()
            return
        end
        local dir = files.cwd()
        local path = dialog.select_file(nil, ".*", dir)
        if path then
            local _dir = files.unixify(dir)
            local _path = files.unixify(path)
            if _path:starts(_dir) then
                _path = string.sub(_path, #_dir, #path):trim("/")
            end
            pair:setValue(_path)
            g_editor:onEditEnd(self._config, key)
        end
    else
        g_editor:startEdit(key, function(text)
            local new = to_type(text, type(val))
            if new ~= nil then
                pair:setValue(new)
            end
        end)
    end
end

function Property:updateStatus()
    local targetKey = g_editor:getTargetKey()
    if self._borderLine then
        self._borderLine:setColor(targetKey == self._pair:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
    else
        self._borderLine1:setColor(targetKey == self._pair1:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
        self._borderLine2:setColor(targetKey == self._pair2:getKey() and BORDER_ON_COLOR or BORDER_OFF_COLOR)
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
