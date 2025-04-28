--[[
	Ellipse
]]

Ellipse = class("Ellipse", Node)

function Ellipse:_onInit()
	Node._onInit(self)
end

function Ellipse:_parseConf()
	Node._parseConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	return self
end

function Ellipse:_doDraw()
	Node._doDraw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.ellipse(self._mode, self:getX(), self:getY(), self:getW() / 2, self:getH() / 2)
	end
end
