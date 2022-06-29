--[[
	rectangle
]]

Rectangle = Node:ext()

function Rectangle:init(conf, parent)
	Node.init(self, conf, parent)
end

function Rectangle:draw()
	if not self._isHide then
		tools_set_color(self._conf.color)
	    love.graphics.rectangle("fill", self._targetX, self._targetY, self._w, self._h)
	end
	Node.draw(self)
end
