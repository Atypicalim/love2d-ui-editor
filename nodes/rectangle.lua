--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.color)
end

function Rectangle:setColor(color)
	self._r, self._g, self._b, self._a = hex2rgba(color)
	self._r, self._g, self._b, self._a = self._r / 255, self._g / 255, self._b / 255, self._a / 255
end

function Rectangle:draw()
	if not self._isHide then
		love.graphics.setColor(self._r, self._g, self._b, self._a)
		love.graphics.rectangle(self._conf.mode or "fill", self:getLeft(), self:getTop(), self._w, self._h, self._conf.radius, self._conf.radius)
	end
	Node.draw(self)
end
