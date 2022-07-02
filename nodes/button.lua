--[[
	button
]]

Button = class("Button", Node)

function Button:__init__(gui, conf, parent)
	Node.__init__(self, gui, conf, parent)
	self.btn = gooi.newButton({
		text = self._conf.text or "",
		x = self._targetX,
		y = self._targetY,
		w = self._w,
		h = self._h,
	})
	self.btn.style.bgColor = {0.5, 0.5, 0.5}
	self.btn:onRelease(function()
		if self.onClick then self.onClick() end
    end)
end

function Button:draw()
	Node.draw(self)
end

function Button:setXY(x, y)
	Node.setXY(self, x, y)
	self.btn.x = self._targetX
	self.btn.y = self._targetY
end

function Button:setIcon(icon)
	self.btn:setIcon(icon)
end

function Button:destroy()
	Node.destroy(self)
    gooi.removeComponent(self.btn)
end
