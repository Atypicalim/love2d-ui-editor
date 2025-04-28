--[[
	node
]]

Config = {}
Config.__index = Config

function Config.loadConf(self)
    if self._isConfiged then return self end
    self._isConfiged = true
    setmetatable(self, Config)
    -- 
    self:_renameConf('x', 'px')
    self:_renameConf('y', 'py')
    self:_renameConf('w', 'sw')
    self:_renameConf('h', 'sh')
    --
    local _type = self.type
    local DEFAULT = CONTROL_CONF_MAP[_type]
    for k,v in pairs(DEFAULT) do
        if self[k] == nil then
            self[k] = v
        end
    end
    --
    return self
end

function Config:_renameConf(k1, k2)
    self[k2] = self[k2] or self[k1]
    self[k1] = nil
end

function Config:getConf()
    return self
end

function Config:getType()
    return self.type
end

function Config:getConfChildren()
    return self.children or {}
end

function Config:isConfOpen()
    return self.open
end

function Config:getValueForKey(key, default)
    local value = self[key]
    if default then
        assert(type(value) == type(default), 'ivalid config value')
    end
    return value
end

function Config:setValueForKey(key, value)
    assert(value ~= nil)
    local old = self[key]
    assert(type(old) == type(value), 'ivalid config value')
    self[key] = value
end

function Config:switchValueForKey(key)
    assert(is_boolean(self[key]))
    self[key] = not self[key]
end

function Config:setConfXYWH(x, y, w, h)
	self.px = x or self.px
	self.py = y or self.py
	self.sw = w or self.sw
	self.sh = h or self.sh
	return self
end

function Config:setConfAnchor(ax, ay)
	self._conf.ax = ax or self._conf.ax
	self._conf.ay = ay or self._conf.ay
	return self
end

function Config:setConfKey(key, val)
    local old = self[key]
    assert(val ~= nil and type(old) == type(val), 'invalid conf value')
    self[key] = val
    return old
end

function Config:getConfKey(key, def)
    local val = self[key]
    if def == nil or type(val) == type(def) then
        return val
    else
        return def
    end
end

function Config:_foreachKey(func)
	local CONF = CONTROL_CONF_MAP[self.type]
	assert(CONF ~= nil, 'invalid node type')
	for k,v in pairs(CONF) do
        if not string.starts(k, '_') then
            assert(string.valid(k), 'invalid node prop', k)
            func(k, self[k], v)
        end
    end
end

function Config:checkConf(node)
    self:_foreachKey(function(key, val, def)
		-- local _v = self._conf[k]
		-- if k == 'px' or k == 'py' or k == 'sw' or k == 'sh' then
		-- 	self:_assert(is_number(v) or string.valid(v), "invalid node prop [%s][%s]", k, tostring(v))
		-- elseif _v then
		-- 	self:_assert(type(v) == type(_v), "invalid node prop [%s][%s]", k, tostring(v))
		-- end
	end)
end

function Config:proxConf(node)
    self:_foreachKey(function(key, val, def)
        if #key > 2 then
            local parts = string.explode(key, "_")
            local _name = ""
            for _,part in ipairs(parts) do
                _name = _name .. camel_text(part)
            end
            local setKey = 'set' .. _name
            local getKey = 'get' .. _name
            node[setKey] = node[setKey] or function(_node, value)
                self:setConfKey(key, value)
                node:_setDirty()
                return node
            end
            node[getKey] = node[getKey] or function(_node, default)
                return self:getConfKey(key, default)
            end
        end
    end)
end

function Config:dumpConf()
    local conf = {}
    self:_foreachKey(function(key, val, def)
        local info = PROPERTY_INFO_MAP[key] or {}
        if key ~= 'children' and val ~= nil then
            if info.mustDump or val ~= def then
                conf[key] = val
            end
        end
    end)
    conf.type = self.type
    conf.children = {}
    return conf
end
