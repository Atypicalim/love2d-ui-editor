--[[
	layer
]]

Layer = class("Layer", Node)

function Layer:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self._touchy = true
end

function Layer:_consumeConf()
	Node._consumeConf(self)
	self._isDisabled = self._conf.disable == true
	self._color = rgba2love(hex2rgba(self._conf.color))
	return self
end

function Layer:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Layer:isDisabled()
	return self._isDisabled
end

function Layer:setDisable(isDisable)
	self._conf.disable = isDisable == true
	self:_consumeConf()
	return self
end

function Layer:setEnable(isEnable)
	self._conf.disable = isEnable ~= true
	self:_consumeConf()
	return self
end

function Layer:draw()
	Node.draw(self)
	if not self._isHide then
		love.graphics.setColor(unpack(self._color))
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	end
end
