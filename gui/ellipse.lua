--[[
	Ellipse
]]

Ellipse = class("Ellipse", Node)

function Ellipse:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.bg)
end

function Ellipse:_consumeConf()
	Node._consumeConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	return self
end

function Ellipse:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Ellipse:setThickness(thickness)
	self._conf.thickness = thickness
	self:_consumeConf()
	return self
end

function Ellipse:setFill(isFill)
	self._conf.fill = isFill
	self:_consumeConf()
	return self
end

function Ellipse:draw()
	Node.draw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.ellipse(self._mode, self:getX(), self:getY(), self:getW() / 2, self:getH() / 2)
	end
end
