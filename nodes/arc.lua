--[[
	Arc
]]

Arc = class("Arc", Node)

function Arc:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Arc:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Arc:draw()
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.setLineWidth(self._conf.thickness or 2)
		love.graphics.arc(
			self._conf.mode or "fill", self:getX(), self:getY(),
			(self:getW() + self:getH()) / 2,
			self._conf.from_angle or 0, self._conf.to_angle or math.pi * 1.5
		)
	end
	Node.draw(self)
end

function Arc:_checkConf()
	Node._checkConf(self)
	self:setColor(self._conf.bg or "#101010aa")
end
