--[[
	Text
]]

Text = class("Text", Node)

function Text:__init__(conf, parent)
	self._text = conf.text
	Node.__init__(self, conf, parent)
end

function Text:_adjust()
	local font = love.graphics.getFont()
	self._w = font:getWidth(self._text)
	self._h = font:getHeight()
	Node._adjust(self)
end

function Text:draw()
	if not self._isHide then
	    love.graphics.setColor(0.7, 0.7, 0.7, 1)
		love.graphics.print(self._text, self:getLeft(), self:getTop())
	end
	Node.draw(self)
end
