--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.color)
	self._radius = self._conf.radius or 0
end

function Rectangle:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Rectangle:draw()
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.rectangle(self._conf.mode or "fill", self:getLeft(), self:getTop(), self:getW(), self:getH(), self._radius, self._radius)
	end
	Node.draw(self)
end
