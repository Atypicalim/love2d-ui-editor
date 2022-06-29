--[[
	button
]]

Button = Node:ext()

function Button:init(conf, parent)
	Node.init(self, conf, parent)
	self._x, self._y = 100, 100
	self._w, self._h = 100, 50
end

function Button:draw()
	if not self._isHide then
	    love.graphics.setColor(0.5, 0.5, 0.5, 1)
	    love.graphics.rectangle("fill", self._x, self._y, self._w, self._h)
	end
	Node.draw(self)
end
