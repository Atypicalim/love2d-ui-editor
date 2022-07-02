--[[
	Input
]]

Input = class("Input", Node)

function Input:__init__(gui, conf, parent)
	Node.__init__(self, gui, conf, parent)
	self.text = gooi.newText({
		text = self._conf.text or "",
		x = self._targetX,
		y = self._targetY,
		w = self:getW(),
		h = self:getH(),
	})
	self.text.style.bgColor = {0.5, 0.5, 0.5}
end

function Input:draw()
	Node.draw(self)
end

function Input:setXY(x, y)
	Node.setXY(self, x, y)
	self.text.x = self._targetX
	self.text.y = self._targetY
end

function Input:getText()
	return self.text:getText()
end

function Input:setText(text)
	self.text:setText(text)
end

function Input:destroy()
	Node.destroy(self)
    gooi.removeComponent(self.text)
end
