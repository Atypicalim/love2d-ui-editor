--[[
	tools
]]

function hex2rgba(hex)
    assert(type(hex) == "string")
    hex = hex:gsub("#","")
    if #hex == 3 then
        hex = hex:sub(1,1) .. hex:sub(1,1) .. hex:sub(2,2) .. hex:sub(2,2) .. hex:sub(3,3) .. hex:sub(3,3) .. "ff"
    elseif #hex == 6 then
        hex = hex .. "ff"
    end
    assert(#hex == 8)
    local r = tonumber("0x"..hex:sub(1, 2))
    local g = tonumber("0x"..hex:sub(3, 4))
    local b = tonumber("0x"..hex:sub(5, 6))
    local a = tonumber("0x"..hex:sub(7, 8))
    return r, g, b, a
end

function rgba2hex(r, g, b, a)
    assert(type(r) == "number")
    assert(type(g) == "number")
    assert(type(b) == "number")
    a = a or 255
    local rgba = (r * 0x1000000) + (g * 0x10000) + (b * 0x100) + a
    local hex = string.format("#%08x", rgba)
    return hex
end

function rgba2love(...)
    local rgba = {...}
    if is_table(rgba[1]) then rgba = rgba[1] end
    assert(#rgba == 4)
    return {rgba[1] / 255, rgba[2] / 255, rgba[3] / 255, rgba[4] / 255}
end

function hex2new(hex, times)
    local values = {hex2rgba(hex)}
    for i=1,3 do
        values[i] = math.max(0, math.min(255, values[i] / 2))
    end
    values[4] = math.max(0, math.min(255, values[4] * times))
    return rgba2hex(unpack(values))
end

function describe2xywh(isXW, describe, pWidth, pHeight)
    -- 
    if is_number(describe) then
        return describe
    end
    -- 
    assert(string.valid(describe), 'empty describe to calculate!')
    describe = describe:upper():trim()
    --
    local num = tonumber(describe)
    if num and num > 1 and tostring(num) == describe then
        return num
    end
    --
    local reg = "^%s*([WH])%s*%*"
    local exp = string.match(describe, reg)
    local flt = string.gsub(describe, reg, "")
    if exp then
        isXW = exp == "W"
    end
    -- 
    local val = isXW and pWidth or pHeight
    local cal = string.format("return %f * %s", val, flt)
    local fun = loadstring(cal) or function() end
    local res = fun()
    if not res then
        print('invalid describe value of:' .. describe)
        error('invalid describe to calculate!')
    end
    return res
end

function is_node(val)
    return is_table(val)
end

function parser_key(key)
    local parts = string.explode(key, "_")
    local count = #parts
    if count == 1 then
        return false, key
    else
        assert(count == 3, 'invalid multiple key')
        local name = parts[1]
        local prefix = string.sub(name, 1, 1)
        return true, name, prefix .. parts[2], prefix .. parts[3]
    end
end

function limit_text(text, len)
    assert(len > 3)
    if #text > len then
        return string.sub(text, 1, len - 3) .. "..."
    else
        return text
    end
end

function camel_text(text, ignoreFirst)
    local parts = string.explode(text, "_")
    local _text = ""
    for i,v in ipairs(parts) do
        local _v = string.upper(string.sub(v, 1, 1)) .. string.sub(v, 2, #v)
        if i == 1 then
            _text = ignoreFirst and v or _v
        else
            _text = _text .. _v
        end
    end
    return _text
end

function read_template(path)
    path = tostring(path)
	assert(string.valid(path), 'invalid gui path:' .. path)
	local configs = nil
	if g_editor then
		assert(files.is_file(path), 'invalid gui file:' .. path)
		configs = table.read_from_file(path)
	else
        -- TODO: check file path and info
		if path:sub(1, 1) == "." then
			path = path:sub(2, -1)
		end
		assert( love.filesystem.getInfo(path) ~= nil, 'invalid gui file:' .. path)
		configs = string.table(love.filesystem.read(path))
	end
	assert(configs ~= nil, 'invalid gui configs! in:' .. path)
    return configs
end
