--[[
    printer
]]

local Printer = class("Printer")

function Printer:__init__(parent)
	self._color = {1, 1, 1, 1}
	self._font = love.graphics.newFont(12)
end

function Printer:print(parent, text, x, y)

	self._text = love.graphics.newText(self._font, text)
    local w = self._text:getWidth()
    local h = self._text:getHeight()
    x = x or 0
    y = y or 0
    local _x = parent:getX() + x - w / 2
    local _y = parent:getY() + y - h / 2

    love.graphics.setColor(unpack(self._color))
    love.graphics.setFont(self._font)
    love.graphics.draw(self._text, _x, _y)

end

return Printer
