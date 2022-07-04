--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(gui, conf, parent)
	Node.__init__(self, gui, conf, parent)
	self:setColor(self._conf.color)
end

function Rectangle:setColor(color)
	self._r, self._g, self._b, self._a = hex2rgba(color)
	self._r, self._g, self._b, self._a = self._r / 255, self._g / 255, self._b / 255, self._a / 255
end

function Rectangle:draw(mode)
	if not self._isHide then
		love.graphics.setColor(self._r, self._g, self._b, self._a)
	    love.graphics.rectangle(mode or "fill", self:getLeft(), self:getTop(), self._w, self._h)
	end
	Node.draw(self)
end
