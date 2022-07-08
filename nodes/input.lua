--[[
	Input
]]

Input = class("Input", Node)

function Input:__init__(conf, parent)
	self._font = love.graphics.newFont(conf.font_size or 18)
	Node.__init__(self, conf, parent)
	self._cursorPosition = 0
	self._inputPadding = 5
	self._cursorChar1 = "|"
	self._cursorChar2 = " "
	self._cursorTime = 0
	self._cursorVisible = true
	self:setText(self._conf.text or "")
end

function Input:mousepressed(...)
	Node.mousepressed(self, ...)
	self:setFocus(self:isHover())
end

function Input:textinput(text)
	if not self._isFocused then return end
	local left, right = self:_doExplode()
	self:setText(string.format("%s%s%s", left, text, right))
end

function Input:getText()
	return self._realText
end

function Input:setText(text)
	assert(text ~= nil)
	self._realText = text
	self:_doCalculate()
	self:_moveCursor(0)
end

function Input:_doExplode()
	local left = string.sub(self._realText, 1, #self._realText - self._cursorPosition)
	local right = self._cursorPosition <= 0 and "" or string.sub(self._realText, -self._cursorPosition, -1)
	return left, right
end

function Input:_doCalculate()
	self._leftText, self._rightText = self:_doExplode()
	self._leftLength = self._font:getWidth(self._leftText)
	self._rightLength = self._font:getWidth(self._rightText)
	local cursor = self._cursorVisible and self._cursorChar1 or self._cursorChar2
	self._visibleText = string.format("%s%s%s", self._leftText, cursor, self._rightText)
	self._textW = self._font:getWidth(self._visibleText)
	self._textH = self._font:getHeight()
	self._isRight = (self._textW + self._inputPadding * 2) > self:getW()
	self._displayIndent = 0
	if self._textW <= self:getW() then
		self._displayIndent = self:getLeft() + self._inputPadding
	elseif self._leftLength < self:getW() / 2 then
		self._displayIndent = self:getLeft() + self._inputPadding
	elseif self._rightLength < self:getW() / 2 then
		self._displayIndent = self:getRight() - self._inputPadding - self._textW
	else
		self._displayIndent = self:getLeft() - self._textW + self._rightLength + self:getW() / 2
	end
end

function Input:update(dt)
	self._cursorTime = self._cursorTime + dt
	if self._cursorTime > 0.5 then
		self._cursorVisible = not self._cursorVisible
		self._cursorTime = 0
	end
end

function Input:draw()
	if not self._isHide then
		love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
		if self._isFocused then
			love.graphics.setColor(0.9, 0.9, 0.9, 1)
			love.graphics.rectangle("line", self:getLeft(), self:getTop(), self:getW(), self:getH())
		end
		love.graphics.setScissor(
			self:getLeft() + self._inputPadding,
			self:getTop(),
			self:getW() - self._inputPadding * 2,
			self:getH()
		)
	    love.graphics.setColor(0.9, 0.9, 0.9, 1)
		self._leftText, self._rightText = self:_doExplode()
		local cursor = self._cursorVisible and self._cursorChar1 or self._cursorChar2
		local y = self:getY() - self._textH / 2
		local x = self._displayIndent
		love.graphics.setFont(self._font)
		love.graphics.print(string.format("%s%s%s", self._leftText, cursor, self._rightText), x, y)
		love.graphics.setScissor()
	end
	Node.draw(self)
end

function Input:setFocus(isFocused)
	self._isFocused = isFocused
end

function Input:keypressed(key, scancode, isrepeat)
	if not self._isFocused then return end
	if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
		if key == 'x' then
			love.system.setClipboardText(self._realText)
			self:setText("")
		elseif key == 'c' then
			love.system.setClipboardText(self._realText)
		elseif key == 'v' then
			self:setText(self._realText .. love.system.getClipboardText())
		end
	else
		if key == 'backspace' then
			local left, right = self:_doExplode()
			self:setText(string.format("%s%s", self:_cutText(left, false), right))
		elseif key == 'delete' then
			local left, right = self:_doExplode()
			self:setText(string.format("%s%s", left, self:_cutText(right, true)))
			if #right > 0 then
				self:_moveCursor(1)
				self:_doCalculate()
			end
		elseif key == 'right' then
			self:_moveCursor(1)
			self:_doCalculate()
		elseif key == 'left' then
			self:_moveCursor(-1)
			self:_doCalculate()
		end
	end
end

function Input:_moveCursor(direction)
	if direction == 0 then
		if self._cursorPosition < 0 then
			self._cursorPosition = 0
		elseif self._cursorPosition > #self._realText then
			self._cursorPosition = #self._realText
		end
	elseif direction > 0 and self._cursorPosition > 0 then
		self._cursorPosition = self._cursorPosition - 1
	elseif direction < 0 and self._cursorPosition < #self._realText then
		self._cursorPosition = self._cursorPosition + 1
	end
end

function Input:_cutText(text, fromBeginning)
	assert(text ~= nil)
	local length = #text
	if length <= 1 then return "" end
	return fromBeginning and string.sub(text, 2, length) or string.sub(text, 1, length - 1)
end
