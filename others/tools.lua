--[[
	tools
]]

function tools_set_color(color)
	local alpha = color[4] ~= nil and color[4] / 255 or 1
    love.graphics.setColor(color[1] / 255, color[2] / 255, color[3] / 255, alpha)
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
