--[[
	button
]]

Button = class("Button", Node)

function Button:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self.btn = gooi.newButton({
		text = self._conf.text or "",
		x = self:getLeft(),
		y = self:getTop(),
		w = self._w,
		h = self._h,
	})
	if self._conf.icon then
		self:setIcon(self._conf.icon)
	end
	self.btn.style.bgColor = {0.5, 0.5, 0.5}
	self.btn:onRelease(function()
		print('\n\n\n===>', self.canvas)
		if self.onClick then
			self.onClick()
		elseif self.canvas then
			self.canvas.onClick(self._conf.id, self)
		end
    end)
end

function Button:draw()
	Node.draw(self)
end

function Button:setXY(x, y)
	Node.setXY(self, x, y)
	if self.btn then
		self.btn.x = self:getLeft()
		self.btn.y = self:getTop()
	end
end

function Button:setIcon(icon)
	self.btn:setIcon(icon)
end

function Button:destroy()
	Node.destroy(self)
    gooi.removeComponent(self.btn)
end
