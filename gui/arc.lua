--[[
	Arc
]]

Arc = class("Arc", Node)

function Arc:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Arc:_consumeConf()
	Node._consumeConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	self._fromAngle = self._conf.from_angle
	self._toAngle = self._conf.to_angle
	self._extraValue = (self:getW() + self:getH()) / 2
	return self
end

function Arc:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Arc:setThickness(thickness)
	self._conf.thickness = thickness
	self:_consumeConf()
	return self
end

function Arc:setFill(isFill)
	self._conf.fill = isFill
	self:_consumeConf()
	return self
end

function Arc:draw()
	Node.draw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.arc( self._mode, self:getX(), self:getY(), self._extraValue, self._fromAngle, self._toAngle)
	end
end
