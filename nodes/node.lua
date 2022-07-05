--[[
	node
]]

Node = class("Node")

function Node:__init__(conf, parent)
	self._conf = conf
	self._parent = parent
	self._children = {}
	self:setA()
	self:setXY()
	self:setWH()
	--
	self:_adjust()
	--
	self._isHide = self._conf.hide == true
	self:addConfigs(self._conf.children or {})
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

function Node:mousepressed(x, y, button)
end

function Node:mousereleased(x, y, button)
end

function Node:keypressed(key, scancode, isrepeat)
end

function Node:keyreleased(key, scancode)
end

function Node:textinput(text)
end

function Node:wheelmoved(x, y)
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

function Node:setXYWH(x, y, w, h)
	self._conf.x = x or self._conf.x
	self._conf.y = y or self._conf.y
	self._x = is_number(self._conf.x) and self._conf.x or tools_calculate_number(self._parent:getW(), self._conf.x)
	self._y = is_number(self._conf.y) and self._conf.y or tools_calculate_number(self._parent:getH(), self._conf.y)
	if self._parent then
		self._x = self._x + self._parent:getLeft()
		self._y = self._y + self._parent:getTop()
	end
	self._conf.w = w or self._conf.w
	self._conf.h = h or self._conf.h
	self._w = is_number(self._conf.w) and self._conf.w or tools_calculate_number(self._parent:getW(), self._conf.w)
	self._h = is_number(self._conf.h) and self._conf.h or tools_calculate_number(self._parent:getH(), self._conf.h)
	self._w = math.max(0, self._w)
	self._h = math.max(0, self._h)
	self:_adjust()
	return self
end

function Node:setXY(x, y)
	return self:setXYWH(x, y, self._conf.w, self._conf.h)
end
function Node:getXY() return self._x, self._y end
function Node:setX(x) return self:setXY(x, self._conf.y) end
function Node:setY(y) return self:setXY(self._conf.x, y) end
function Node:getX() return self._x end
function Node:getY() return self._y end

function Node:setWH(w, h)
	return self:setXYWH(self._conf.x, self._conf.y, w, h)
end
function Node:getWH() return self._w, self._h end
function Node:setW(w) return self:setXY(w, self._conf.h) end
function Node:setH(h) return self:setXY(self._conf.w, h) end
function Node:getW() return self._w end
function Node:getH() return self._h end

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

function Node:isHover()
	local mouseX, mouseY = love.mouse.getPosition()
    return mouseX > self:getLeft() or mouseX < self:getRight() and mouseY > self:getTop() or mouseY < self:getBottom()
end

function Node:destroy()
	for i,v in ipairs(self._children) do
		v:destroy()
	end
end

-- 

function Node:addTemplate(path)
	path = tostring(path)
	assert(string.valid(path) and files.is_file(path), 'invalid ui path:' .. path)
	local configs = table.read_from_file(path)
	assert(configs ~= nil, 'invalid ui config! in:' .. path)
	return self:addConfigs(configs)
end

function Node:addConfigs(configs)
	if not table.is_array(configs) then
		configs = {configs}
	end
	for i,v in ipairs(configs) do
		self:newConfig(v)
	end
	return self
end

function Node:newConfig(config)
	assert(_G[config.type], string.format('node [%s] not found!', config.type))
	local child = _G[config.type](config, self)
	child.canvas = self.canvas or self
	table.insert(self._children, child)
	return child
end

function Node:getById(nodeId)
	assert(string.valid(nodeId), 'invalid node id!')
	if self._conf.id == nodeId then
		return self
	else
		for i,v in ipairs(self._children) do
			local node = v:getById(nodeId)
			if node then
				return node
			end
		end
	end
end

function Node:getByType(nodeType)
	local nodes = {}
	if self._config.type == nodeType then
		table.insert(nodes, v)
	else
		for i,v in ipairs(self._children) do
			local newNodes = v:getByType()
			if newNodes then
				table.append(nodes, newNodes)
			end
		end
	end
	return nodes
end
