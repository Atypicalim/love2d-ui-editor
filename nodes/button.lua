--[[
	button
]]

Button = class("Button", Node)

function Button:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Button:_checkConf()
	Node._checkConf(self)
	self._isDisabled = self._conf.disable == true
	self._conf.bg = self._conf.bg or "#555555aa"
	if self._conf.bg then
		self._colorNormal = rgba2love(hex2rgba(self._conf.bg))
		self._colorPressed = rgba2love(hex2rgba(hex2new(self._conf.bg, 1.2)))
		self._colorDisabled = rgba2love(hex2rgba(hex2new(self._conf.bg, 0.9)))
	end
	self._colorTarget = self._isDisabled and self._colorDisabled or self._colorNormal
	self:setIcon(self._conf.icon)
	self:setText(self._conf.text)
end

function Button:isDisabled()
	return self._isDisabled
end

function Button:setDisable(isDisable)
	self._isDisabled = isDisable == true
	return self
end

function Button:setIcon(path)
	self._path = path
	if string.valid(path) then
		self._image = love.graphics.newImage(path)
		self._imageW = self._image:getWidth()
		self._imageH = self._image:getHeight()
	else
		self._image = nil
	end
	return self
end

function Button:setText(text)
	self._text = text
	if string.valid(text) then
		self._font = love.graphics.newFont(self._conf.size or 12)
		self._txt = love.graphics.newText(self._font, self._text)
		self._textW = self._txt:getWidth()
		self._textH = self._txt:getHeight()
	else
		self._font = nil
		self._txt = nil
	end
end

function Button:trigger(event, ...)
	Node.trigger(self, event, ...)
	if event == NODE_EVENTS.ON_MOUSE_DOWN then
		self._colorTarget = self._colorPressed
	elseif event == NODE_EVENTS.ON_MOUSE_OUT or event == NODE_EVENTS.ON_MOUSE_UP then
		self._colorTarget = self._colorNormal
	end
end

function Button:draw()
	if not self._isHide then
		love.graphics.setColor(unpack(self._colorTarget))
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
		if self._image then
			love.graphics.draw(self._image, self:getX() - self._imageW / 2, self:getY() - self._imageH / 2)
		elseif self._text then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setFont(self._font)
			love.graphics.draw(self._txt, self:getX() - self._textW / 2, self:getY() - self._textH / 2)
		end
	end
	Node.draw(self)
end
