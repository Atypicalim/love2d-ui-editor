--[[
	Text
]]

Text = class("Text", Node)

function Text:__init__(conf, parent)
	self._text = conf.text
	self._font = love.graphics.newFont(conf.font_size or 18)
	Node.__init__(self, conf, parent)
end

function Text:getText()
	return self._text
end

function Text:setText(text)
	self._text = text
	self:setXYWH()
end

function Text:setXYWH(...)
	Node.setXYWH(self, ...)
	self._w = self._font:getWidth(self._text)
	self._h = self._font:getHeight()
end

function Text:draw()
	if not self._isHide then
	    love.graphics.setColor(0.7, 0.7, 0.7, 1)
		love.graphics.setFont(self._font)
		love.graphics.print(self._text, self:getLeft(), self:getTop())
	end
	Node.draw(self)
end
