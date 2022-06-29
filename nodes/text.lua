--[[
	Text
]]

Text = Node:ext()

function Text:init(conf, parent)
	Node.init(self, conf, parent)
	self._x, self._y = 100, 100
	self._w, self._h = 100, 50
end

function Text:draw()
	if not self._isHide then
	    love.graphics.setColor(0.7, 0.7, 0.7, 1)
    love.graphics.print(os.date("%Y-%m-%d_%H:%M:%S", os.time()), 10, 10, 0, 1, 1)
	end
	Node.draw(self)
end
