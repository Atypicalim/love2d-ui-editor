--[[
	button
]]

Button = class("Button", Node)

function Button:__init__(gui, conf, parent)
	Node.__init__(self, gui, conf, parent)
end

function Button:draw()
	if not self._isHide then
	    love.graphics.setColor(0.5, 0.5, 0.5, 1)
	    love.graphics.rectangle("fill", self._targetX, self._targetY, self._w, self._h)
	end
	Node.draw(self)
end
