--[[
	Text
]]

Text = class("Text", Node)

function Text:__init__(gui, conf, parent)
	self._text = conf.text
	Node.__init__(self, gui, conf, parent)
end

function Text:_adjust()
	local font = love.graphics.getFont()
	self._w = font:getWidth(self._text)
	self._h = font:getHeight()
	self._targetX = self._x - self._ax * self._w
	self._targetY = self._y - self._ay * self._h
	if self._parent then
		self._targetX = self._targetX + self._parent._targetX
		self._targetY = self._targetY + self._parent._targetY
	end
end

function Text:draw()
	if not self._isHide then
	    love.graphics.setColor(0.7, 0.7, 0.7, 1)
		love.graphics.print(self._conf.text, self._targetX, self._targetY)
	end
	Node.draw(self)
end
