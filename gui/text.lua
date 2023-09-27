--[[
	Text
]]

Text = class("Text", Node)

function Text:_onInit()
	Node._onInit(self)
end

function Text:_parseConf()
	Node._parseConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._font = love.graphics.newFont(self._conf.size or 12)
	self._text = love.graphics.newText(self._font, self._conf.text)
	self._w = self._text:getWidth()
	self._h = self._text:getHeight()
	return self
end

function Text:setColor(color)
	self._conf.color = color
	self:_setDirty()
	return self
end

function Text:setSize(size)
	self._conf.size = size
	self:_setDirty()
	return self
end

function Text:setText(text)
	self._conf.text = text
	self:_setDirty()
	return self
end

function Text:getText()
	return self._conf.text
end

function Text:_doDraw()
	Node._doDraw(self)
	if not self._isHide and self._text then
	    love.graphics.setColor(unpack(self._color))
		love.graphics.setFont(self._font)
		love.graphics.draw(self._text, self:getLeft(), self:getTop())
	end
end
