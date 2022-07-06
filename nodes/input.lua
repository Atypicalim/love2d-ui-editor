--[[
	Input
]]

Input = class("Input", Node)

function Input:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self._r, self._g, self._b, self._a = hex2rgba(color or "#101010aa")
	self._r, self._g, self._b, self._a = self._r / 255, self._g / 255, self._b / 255, self._a / 255
	love.graphics.setFont(love.graphics.newFont(24))
	self:setText(self._conf.text or "")
end

function Input:mousepressed(...)
	Node.mousepressed(self, ...)
	self:setFocus(self:isHover())
end

function Input:textinput(text)
	print('--->', self._isFocused, text)
	if self._isFocused then
		self:setText(self._text .. text)
	end
end

function Input:getText()
	return self._text
end

function Input:setText(text)
	self._text = text or ""
	local font = love.graphics.getFont()
	local textWidth = font:getWidth("X")
	self._textH = font:getHeight()
	self._charSpacing = 8
	self._inputPadding = 10

	self._visibleText = {}
	self._totalLength = 0
	for i=#self._text,1,-1 do
		local char = string.sub(self._text, i, i)
		local charWidth = font:getWidth(char)
		local blockWidth = charWidth + self._charSpacing
		if self._totalLength + blockWidth <= self:getW() - self._inputPadding * 2 then
			table.insert(self._visibleText, {
				c = char,
				w = blockWidth,
			})
			self._totalLength = self._totalLength + blockWidth
		else
			break
		end
	end
	local currentPosition = self._inputPadding
	for i=#self._visibleText,1, -1 do
		local v = self._visibleText[i]
		v.x = currentPosition
		currentPosition = v.x + v.w
	end
end

function Input:draw()
	if not self._isHide then
		
		love.graphics.setColor(self._r, self._g, self._b, self._a)
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	    love.graphics.setColor(0.9, 0.9, 0.9, 1)
		--
		local y = self:getY() - self._textH / 2
		local x = self:getLeft()
		for i,v in ipairs(self._visibleText) do
			love.graphics.print(v.c, x + v.x, y)
		end
		if self._isFocused then
			love.graphics.setColor(0.9, 0.9, 0.9, 1)
			love.graphics.rectangle("line", self:getLeft(), self:getTop(), self:getW(), self:getH())
		end
	end
	Node.draw(self)
end

function Input:setFocus(isFocused)
	self._isFocused = isFocused
end

function Input:destroy()
	Node.destroy(self)
end
