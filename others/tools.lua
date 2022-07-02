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

function tools_calculate_number(base, describe)
	local equation = string.format("return %d * %s", base, describe)
	local func = loadstring(equation)
    return func()
end

function tools_execute_powershell(cmd)
    local isOk, r = tools.execute([[ powershell.exe -file ]] .. cmd)
    assert(isOk, 'powershell execute failed:' .. cmd)
    return string.trim(r)
end

function tools_pws_select_file(folder)
	folder = folder or files.cwd():sub(1, -2):gsub('/', '\\')
	local path = tools_execute_powershell("./others/select_file.ps1 " .. folder)
	if string.valid(path) and files.is_file(path) then
		return path
	end
end

function tools_pws_show_message(msg)
	msg = msg or "msg..."
	return tools_execute_powershell("./others/show_error.ps1 " .. msg)
end
