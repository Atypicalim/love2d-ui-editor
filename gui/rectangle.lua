--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Rectangle:_consumeConf()
	Node._consumeConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	self._radius = self._conf.radius
	return self
end

function Rectangle:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Rectangle:setThickness(thickness)
	self._conf.thickness = thickness
	self:_consumeConf()
	return self
end

function Rectangle:setFill(isFill)
	self._conf.fill = isFill
	self:_consumeConf()
	return self
end

function Rectangle:setRadius(radius)
	self._conf.radius = radius
	self:_consumeConf()
	return self
end

function Rectangle:draw()
	Node.draw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.rectangle(self._mode, self:getLeft(), self:getTop(), self:getW(), self:getH(), self._radius, self._radius)
	end
end
