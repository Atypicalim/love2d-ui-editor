--[[
	rectangle
]]

Rectangle = class("Rectangle", Node)

function Rectangle:__init__(gui, conf, parent)
	Node.__init__(self, gui, conf, parent)
end

function Rectangle:draw(mode)
	if not self._isHide then
		tools_set_color(self._conf.color)
	    love.graphics.rectangle(mode or "fill", self._targetX, self._targetY, self._w, self._h)
	end
	Node.draw(self)
end
