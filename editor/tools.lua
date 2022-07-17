--[[
	tools
]]

function tools_execute_powershell(func, ...)
    local cmd = func
    local agrs = {...}
    for i,v in ipairs(agrs) do
        cmd = cmd .. [[ "]] .. tostring(v) .. [["]]
    end
    local isOk, r = tools.execute([[ powershell.exe -file ./others/powershell.ps1 ]] .. cmd)
    assert(isOk, 'powershell execute failed:' .. cmd)
    return r:match(".*%[result%[(.*)%]result%].*")
end

function tools_windows_validate_folder(folder)
    folder = folder:gsub('/', '\\')
    if folder:sub(-1, -1) == '\\' then
        folder = folder:sub(1, -2)
    end
    folder = folder:gsub('\\\\', '\\')
    return folder
end

function tools_platform_select_file(title, filter, folder)
    title = title or "please select a file ..."
    filter = filter or "All files (*.*)|*.*"
	folder = folder or ""
	local path = tools_execute_powershell("select_file", title, filter, tools_windows_validate_folder(folder))
	if string.valid(path) then
		return path
	end
end

function tools_platform_save_file(title, filter, folder)
    title = title or "please save a file ..."
    filter = filter or "All files (*.*)|*.*"
	folder = folder or ""
	local path = tools_execute_powershell("save_file", title, filter, tools_windows_validate_folder(folder))
	if string.valid(path) then
		return path
	end
end

function tools_platform_select_folder(title, folder)
    title = title or "please select a folder ..."
	folder = folder or ""
	local path = tools_execute_powershell("select_folder", title, tools_windows_validate_folder(folder))
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

function tools_platform_open_path(path)
    path = tools_windows_validate_folder(path)
    return tools.execute([[start %windir%\explorer.exe "]] .. path .. [["]])
end

function tools_platform_open_url(url)
    return tools.execute([[start https://github.com/kompasim/love2d-ui-editor]])
end

function tools_where_is(program)
    if tools.is_windows() then
        return tools.execute([[where "]] .. program .. [["]])
    else
        return tools.execute([[which "]] .. program .. [["]])
    end
end
