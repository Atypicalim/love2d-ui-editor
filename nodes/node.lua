--[[
	node
]]

Node = class("Node")

function Node:__init__(gui, conf, parent)
	self._conf = conf
	self._parent = parent
	self:setA()
	self:setXY()
	self:setWH()
	--
	self:_adjust()
	--
	self._isHide = self._conf.hide == true
	self._children = gui:create(self._conf.children or {}, self)
end

function Node:_adjust()
	if not self._ax or not self._x or not self._w then
		return
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

function Node:setA(ax, ay)
	ax = ax or self._conf.ax
	ay = ay or self._conf.ay
	self._ax = math.max(0, math.min(1, ax or 0.5))
	self._ay = math.max(0, math.min(1, ay or 0.5))
	self:_adjust()
end

function Node:setXY(x, y)
	self._conf.x = x or self._conf.x
	self._conf.y = y or self._conf.y
	self._x = is_number(self._conf.x) and self._conf.x or tools_calculate_number(self._parent:getW(), self._conf.x)
	self._y = is_number(self._conf.y) and self._conf.y or tools_calculate_number(self._parent:getH(), self._conf.y)
	if self._parent then
		self._x = self._x + self._parent:getLeft()
		self._y = self._y + self._parent:getTop()
	end
	self:_adjust()
end
function Node:getXY() return self._x, self._y end
function Node:setX(x) self:setXY(x, self._conf.y) end
function Node:setY(y) self:setXY(self._conf.x, y) end
function Node:getX(x) return self._x end
function Node:getY(y) return self._y end

function Node:setWH(w, h)
	self._conf.w = w or self._conf.w
	self._conf.h = h or self._conf.h
	self._w = is_number(self._conf.w) and self._conf.w or tools_calculate_number(self._parent:getW(), self._conf.w)
	self._h = is_number(self._conf.h) and self._conf.h or tools_calculate_number(self._parent:getH(), self._conf.h)
	self._w = math.max(0, self._w)
	self._h = math.max(0, self._h)
	self:_adjust()
end
function Node:getWH() return self._w, self._h end
function Node:setW(w) self:setXY(w, self._conf.h) end
function Node:setH(h) self:setXY(self._conf.w, h) end
function Node:getW(w) return self._w end
function Node:getH(h) return self._h end

function Node:getLeft() return self._x - self._w * self._ax end
function Node:getRight() return self._x + self._w * ((1 - self._ax)) end
function Node:getTop() return self._y - self._h * self._ay end
function Node:getBottom() return self._y + self._h (1 - self._ay) end

function Node:getConf()
	return self._conf
end

function Node:getChildren()
	return self._children
end

function Node:getId()
	return self._conf.id
end

function Node:getType()
	return self._conf.type
end

function Node:destroy()
	for i,v in ipairs(self._children) do
		v:destroy()
	end
end
