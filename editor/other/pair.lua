--[[
    Pair
]]

local Pair = class("Pair")

function Pair:__init__(flag, prefix, config)
    -- 
    self._config = config
    local _key = prefix .. flag
    --
    self._flag = flag
    self._key = _key
    self._info = PROPERTY_INFO_MAP[self._key] or {}
    self:parsePair()
end

function Pair:parsePair()
    local value = self._config:getValueForKey(self._key)
    if value == nil then
        value = self._config:getValueForKey(self._flag)
    end
    self._value = value
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

function Pair:isPairPath()
    return string.find(self._key, "path") ~= nil or string.find(self._key, "icon") ~= nil
end

return Pair
