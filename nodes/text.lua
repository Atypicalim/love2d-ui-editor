--[[
	Text
]]

Text = class("Text", Node)

function Text:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setText(self._conf.text)
end

function Text:getText()
	return self._text
end

function Text:setText(text)
	self._text = text
	self._font = love.graphics.newFont(self._conf.font_size or 12)
	self._txt = love.graphics.newText(self._font, self._text)
	self:setXYWH(nil, nil, self._txt:getWidth(), self._txt:getHeight())
	self:_setLove(self._txt)
end

function Text:draw()
	if not self._isHide and self._txt then
	    love.graphics.setColor(0.7, 0.7, 0.7, 1)
		love.graphics.setFont(self._font)
		love.graphics.draw(self._txt, self:getLeft(), self:getTop())
	end
	Node.draw(self)
end
