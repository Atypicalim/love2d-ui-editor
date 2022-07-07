--[[
	button
]]

Button = class("Button", Node)

function Button:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	--
	self._isDisabled = self._conf.disable == true
	self._conf.color = self._conf.color or "#555555aa"
	if self._conf.color then
		self._colorPressed = hex2new(self._conf.color, 1.2)
		self._colorDisabled = hex2new(self._conf.color, 0.9)
	end
	self._colorNode = self:newConfig({
		type = "Rectangle",
		x = '0.5',
		y = '0.5',
		w = '1',
		h = '1',
		color = self._isDisabled and self._colorDisabled or self._conf.color,
	})
	self._iconNode = self:newConfig({
		type = "Image",
		x = "0.5",
		y = "0.5",
		w = "1",
		h = "1",
		path = self._conf.icon or "",
	})
	self._textNode = self:newConfig({
		type = "Text",
		x = '0.5',
		y = '0.5',
		w = 0,
		h = 0,
		text = self._conf.text or "",
	})
	if self._conf.icon and self._conf.text then
		local w, h = self._iconNode:getWH()
		self._iconNode:setXY(w, '0.5')
		self._textNode:setXY(string.format('0.5+%d', w), '0.5')
	end
end

function Button:isDisabled()
	return self._isDisabled
end

function Button:setDisable(isDisable)
	self._isDisabled = isDisable == true
end

function Button:setIcon(path)
	self._iconNode:setPath(path)
end

function Button:trigger(event, ...)
	Node.trigger(self, event, ...)
	if event == NODE_EVENTS.ON_MOUSE_DOWN then
		if self._conf.color then
			self._colorNode:setColor(self._colorPressed)
		end
	elseif event == NODE_EVENTS.ON_MOUSE_OUT or event == NODE_EVENTS.ON_MOUSE_UP then
		if self._conf.color then
			self._colorNode:setColor(self._conf.color)
		end
	end
end
