--[[
	layer
]]

Layer = class("Layer", Node)

function Layer:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Layer:_checkConf()
	Node._checkConf(self)
	self._isDisabled = self._conf.disable == true
	self._conf.bg = self._conf.bg or "#33333333"
	if self._conf.bg then
		self._color = rgba2love(hex2rgba(self._conf.bg))
	end
end

function Layer:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Layer:isDisabled()
	return self._isDisabled
end

function Layer:setDisable(isDisable)
	self._isDisabled = isDisable == true
	return self
end

function Layer:draw()
	if not self._isHide then
		love.graphics.setColor(rgba2love(hex2rgba(self._conf.bg)))
		love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	end
	Node.draw(self)
end
