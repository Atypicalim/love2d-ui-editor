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
        values[i] = math.min(255, values[i] * times)
    end
    return rgba2hex(unpack(values))
end
