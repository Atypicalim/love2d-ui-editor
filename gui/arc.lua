--[[
	Arc
]]

Arc = class("Arc", Node)

function Arc:_onInit()
	Node._onInit(self)
end

function Arc:_parseConf()
	Node._parseConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	self._fromAngle = self._conf.from_angle
	self._toAngle = self._conf.to_angle
	self._extraValue = (self:getW() + self:getH()) / 2
	return self
end

function Arc:_doDraw()
	Node._doDraw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.arc( self._mode, self:getX(), self:getY(), self._extraValue, self._fromAngle, self._toAngle)
	end
end
