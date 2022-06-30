--[[
	button
]]

Button = Node:ext()

function Button:init(conf, parent)
	Node.init(self, conf, parent)
end

function Button:draw()
	if not self._isHide then
	    love.graphics.setColor(0.5, 0.5, 0.5, 1)
	    love.graphics.rectangle("fill", self._targetX, self._targetY, self._w, self._h)
	end
	Node.draw(self)
end
