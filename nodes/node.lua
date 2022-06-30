--[[
	node
]]

Node = Object:ext()

function Node:init(conf, parent)
	self._conf = conf
	self._parent = parent
	self._x = is_number(self._conf.x) and self._conf.x or tools_calculate_number(self._parent:getW(), self._conf.x)
	self._y = is_number(self._conf.y) and self._conf.y or tools_calculate_number(self._parent:getH(), self._conf.y)
	self._w = is_number(self._conf.w) and self._conf.w or tools_calculate_number(self._parent:getW(), self._conf.w)
	self._h = is_number(self._conf.h) and self._conf.h or tools_calculate_number(self._parent:getH(), self._conf.h)
	self._w = math.max(0, self._w)
	self._h = math.max(0, self._h)
	self._ax = self._conf.ax or 0.5
	self._ay = self._conf.ay or 0.5
	self._ax = math.max(0, math.min(1, self._ax))
	self._ay = math.max(0, math.min(1, self._ay))
	--
	self:_adjust()
	--
	self._isHide = self._conf.hide == true
	self._children = tools_create_nodes(self._conf.children or {}, self)
end

function Node:_adjust()
	self._targetX = self._x - self._ax * self._w
	self._targetY = self._y - self._ay * self._h
	if self._parent then
		self._targetX = self._targetX + self._parent._targetX
		self._targetY = self._targetY + self._parent._targetY
	end
end

function Node:update()
	for i,v in ipairs(self._children) do
		v:update()
	end
end

function Node:draw()
	if not self._isHide then
		for i,v in ipairs(self._children) do
			v:draw()
		end
	end
end

function Node:hide()
	self._isHide = true
end

function Node:show()
	self._isHide = false
end

function Node:isVisible()
	return not self._isHide
end

function Node:setXY(x, y)
	self._x, self._y = x, y
end

function Node:setWH(w, h)
	self._w, self._h = 0, 0
end

function Node:getXY()
	return self._x, self._y
end

function Node:getWH()
	return self._w, self._h
end

function Node:setX(x)
	self._x = x
end

function Node:setY(y)
	self._y = y
end

function Node:setW(w)
	self._w = w
end

function Node:setH(h)
	self._h = h
end

function Node:getX(x)
	return self._x
end

function Node:getY(y)
	return self._y
end

function Node:getW(w)
	return self._w
end

function Node:getH(h)
	return self._h
end
