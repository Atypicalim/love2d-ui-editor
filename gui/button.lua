--[[
	button
]]

Button = class("Button", Node)

function Button:_onInit()
	Node._onInit(self)
	self._touchy = true
end

function Button:_parseConf()
	Node._parseConf(self)
	self._isDisabled = self._conf.disable == true
	--
	self._colorNormal = rgba2love(hex2rgba(self._conf.color))
	self._colorPressed = rgba2love(hex2rgba(hex2new(self._conf.color, 0.9)))
	self._colorDisabled = rgba2love(hex2rgba(hex2new(self._conf.color, 0.7)))
	self._colorTarget = self._isDisabled and self._colorDisabled or self._colorNormal
	--
	if string.valid(self._conf.icon) then
		self._icon = love.graphics.newImage(self._conf.icon)
		self._iconW = self._icon:getWidth()
		self._iconH = self._icon:getHeight()
	else
		self._icon = nil
		self._iconW = 0
		self._iconH = 0
	end
	--
	if string.valid(self._conf.text) then
		self._font = love.graphics.newFont(self._conf.size or 12)
		self._text = love.graphics.newText(self._font, self._conf.text)
		self._textW = self._text:getWidth()
		self._textH = self._text:getHeight()
	else
		self._font = nil
		self._text = nil
		self._textW = 0
		self._textH = 0
	end
end

function Button:isDisabled()
	return self._isDisabled
end

function Button:setDisable(isDisable)
	self._conf.disable = isDisable == true
	self:_setDirty()
	return self
end

function Button:setEnable(isEnable)
	self._conf.disable = isEnable ~= true
	self:_setDirty()
	return self
end

function Button:setIcon(path)
	self._conf.icon = path
	self:_setDirty()
	return self
end

function Button:setText(text)
	self._conf.text = text
	self:_setDirty()
	return self
end

function Button:trigger(event, ...)
	Node.trigger(self, event, ...)
	if event == NODE_EVENTS.ON_MOUSE_DOWN then
		self._colorTarget = self._colorPressed
	elseif event == NODE_EVENTS.ON_MOUSE_OUT or event == NODE_EVENTS.ON_MOUSE_UP then
		self._colorTarget = self._colorNormal
	end
end

function Button:_doDraw()
	Node._doDraw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._colorTarget))
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
		if self._icon then
			love.graphics.draw(self._icon, self:getX() - self._iconW / 2, self:getY() - self._iconH / 2)
		elseif self._text then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setFont(self._font)
			love.graphics.draw(self._text, self:getX() - self._textW / 2, self:getY() - self._textH / 2)
		end
	end
end
