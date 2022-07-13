--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Rectangle:setColor(color)
	self._color = rgba2love(hex2rgba(color))
	return self
end

function Rectangle:draw()
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._conf.thickness or 2)
		love.graphics.rectangle(self._conf.mode or "fill", self:getLeft(), self:getTop(), self:getW(), self:getH(), self._radius, self._radius)
	end
	Node.draw(self)
end

function Rectangle:_checkConf()
	Node._checkConf(self)
	self:setColor(self._conf.color or "#101010aa")
	self._radius = self._conf.radius or 0
end
