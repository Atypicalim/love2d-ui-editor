--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:_onInit()
	Node._onInit(self)
end

function Rectangle:_parseConf()
	Node._parseConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	self._radius = self._conf.radius
	return self
end

function Rectangle:_doDraw()
	Node._doDraw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._thickness)
		love.graphics.rectangle(self._mode, self:getLeft(), self:getTop(), self:getW(), self:getH(), self._radius, self._radius)
	end
end
