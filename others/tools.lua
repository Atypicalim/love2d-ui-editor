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

function tools_execute_powershell(func, ...)
    local cmd = func
    local agrs = {...}
    for i,v in ipairs(agrs) do
        cmd = cmd .. [[ "]] .. tostring(v) .. [["]]
    end
    local isOk, r = tools.execute([[ powershell.exe -file ./others/powershell.ps1 ]] .. cmd)
    assert(isOk, 'powershell execute failed:' .. cmd)
    return string.trim(r)
end

function tools_platform_select_file(title, filter, folder)
    title = title or "please select a file ..."
    filter = filter or "All files (*.*)|*.*"
	folder = folder or ""
	local path = tools_execute_powershell("select_file", title, filter, folder)
	if string.valid(path) then
		return path
	end
end

function tools_platform_save_file(title, filter, folder)
    title = title or "please save a file ..."
    filter = filter or "All files (*.*)|*.*"
	folder = folder or ""
	local path = tools_execute_powershell("save_file", title, filter, folder)
	if string.valid(path) then
		return path
	end
end

function tools_platform_select_folder(title, folder)
    title = title or "please select a folder ..."
	folder = folder or ""
	local path = tools_execute_powershell("select_folder", title, folder)
	if string.valid(path) then
		return path
	end
end

function tools_platform_show_confirm(title, message, buttons, iconDesc)
	title = title or "title"
	message = message or "confirm..."
    buttons = buttons or "YesNoCancel" -- YesNoCancel, YesNo, OkCancel, Ok
    iconDesc = iconDesc or "Question" -- Warning, Error, Information, Question
	local r = tools_execute_powershell("show_eror", title, message, buttons, iconDesc)
    if r == "Yes" or r == "Ok" then return true end
    if r == "No" then return false end
    return nil
end

function tools_platform_show_input(title, message, default)
	title = title or "title"
	message = message or "input..."
	default = default or ""
	local path = tools_execute_powershell("show_input", title, message, default)
	if string.valid(path) then
		return path
	end
end
