--[[
	tools
]]

function tools_create_nodes(configs, parent)
	local children = {}
	for i,v in ipairs(configs) do
		assert(_G[v.type], string.format('node [%s] not found!', v.type))
		local child = _G[v.type]:new(v, parent)
		table.insert(children, child)	
	end
	return children
end

function tools_set_color(color)
    love.graphics.setColor(color[1] / 255, color[2] / 255, color[3] / 255, 1)
end

function tools_calculate_number(base, describe)
	local equation = string.format("return %d * %s", base, describe)
	local func = loadstring(equation)
    return func()
end
