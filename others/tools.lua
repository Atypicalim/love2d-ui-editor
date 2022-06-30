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
