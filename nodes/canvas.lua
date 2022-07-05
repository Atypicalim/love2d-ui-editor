--[[
	Canvas
]]

Canvas = class("Canvas", Node)

function Canvas:__init__()
	Node.__init__(self, {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	}, nil)
end

function Canvas:draw()
	if not self._isHide then
		love.graphics.setColor(0.1, 0.1, 0.1, 150)
	    love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	end
	Node.draw(self)
end

function Canvas:onClick()
end
