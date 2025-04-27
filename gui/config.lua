--[[
	node
]]

Config = class("Config")

function Config:__init__(conf)
    local _type = conf.type
    local DEFAULT = CONTROL_CONF_MAP[_type]
    self._conf = conf
    for k,v in pairs(DEFAULT) do
        if self._conf[k] == nil then
            self._conf[k] = v
        end
    end
    self._type = _type
end

function Config:newNode(parent)
	if not _G[self._type] then
		error('invalid gui node! content:' .. table.string(self._conf))
	end
	local node = _G[self._type](self, parent)
	if not node then
		error('invalid gui config! content:' .. table.string(self._conf))
	end
    return node
end

function Config:getConf()
    return self._conf
end

function Config:getType()
    return self._type
end

function Config:getConfChildren()
    return self._conf.children or {}
end

function Config:isConfOpen()
    return self._conf.open
end

function Config:getValueForKey(key, default)
    local value = self._conf[key]
    if default then
        assert(type(value) == type(default), 'ivalid config value')
    end
    return value
end

function Config:setValueForKey(key, value)
    assert(value ~= nil)
    local old = self._conf[key]
    assert(type(old) == type(value), 'ivalid config value')
    self._conf[key] = value
end

function Config:switchValueForKey(key)
    assert(is_boolean(self._conf[key]))
    self._conf[key] = not self._conf[key]
end

