--[[
	Input
]]

Input = class("Input", Node)

function Input:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self._r, self._g, self._b, self._a = hex2rgba(color or "#101010aa")
	self._r, self._g, self._b, self._a = self._r / 255, self._g / 255, self._b / 255, self._a / 255
	self:setText(self._conf.text or "")
end

function Input:draw()
	if not self._isHide then
		love.graphics.setColor(self._r, self._g, self._b, self._a)
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	    love.graphics.setColor(0.9, 0.9, 0.9, 1)
		love.graphics.print(self._text, self:getX() - self._textW / 2, self:getY() - self._textH / 2)
		if self._isFocused then
			love.graphics.setColor(0.9, 0.9, 0.9, 1)
			love.graphics.rectangle("line", self:getLeft(), self:getTop(), self:getW(), self:getH())
		end
	end
	Node.draw(self)
end

function Input:mousepressed(...)
	Node.mousepressed(self, ...)
	self:setFocus(self:isHover())
end

function Input:textinput(text)
	print('--->', self._isFocused, text)
	if self._isFocused then
		self._text = self._text .. text
	end
end

function Input:getText()
	return self._text
end

function Input:setText(text)
	self._text = text
	local font = love.graphics.getFont()
	self._textW = font:getWidth(self._text)
	self._textH = font:getHeight()
end

function Input:setFocus(isFocused)
	self._isFocused = isFocused
	-- if self._isFocused then
    --     love.keyboard.setTextInput(true)
	-- else
    --     love.keyboard.setTextInput(false)
	-- end
end

function Input:destroy()
	Node.destroy(self)
end
