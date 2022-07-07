--[[
	Ellipse
]]

Ellipse = class("Ellipse", Node)

function Ellipse:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.color)
end

function Ellipse:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Ellipse:draw()
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.ellipse(self._conf.mode or "fill", self:getX(), self:getY(), self:getW() / 2, self:getH() / 2)
	end
	Node.draw(self)
end
