--[[
	node
]]

Node = class("Node")

function Node:__init__(conf, parent)
	self._conf = conf
	self._parent = parent
	self:_checkConf(nil)
	--
	self._children = {}
	self:setA()
	self:setXYWH()
	--
	for i,v in ipairs(self._conf.children) do
		self:_parseConfig(v)
	end
end

function Node:_draw()
	love.graphics.setColor(0.1, 0.1, 0.1, 0.9)
	love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
end

function Node:_error(...)
	local msg = string.format("[Node:%s] ", self.__name__) .. string.format(...)
	error(msg)
end

function Node:_checkConf()
	-- validate with type key values
	if self.__name__ ~= 'Gui' then
		local defaultConf = CONTROL_CONF_MAP[self.__name__]
		assert(defaultConf ~= nil, 'default values not found')
		defaultConf= table.copy(defaultConf)
		for k,v in pairs(self._conf) do
			if k == 'x' or k == 'y' or k == 'w' or k == 'h' then
				if not is_number(v) and not string.valid(v) then
					self:_error("invalid value [%s] for [%s]", tostring(v), k)
				end
			else
				if type(v) ~= type(defaultConf[k]) then
					self:_error("invalid value [%s] for [%s]", tostring(v), k)
				end
			end
		end
	end
	--
	self._conf.hide = self._conf.hide == true
	self._conf.children = self._conf.children or {}
	--
	self._isHide = self._conf.hide
	return self
end

function Node:_setLove(love)
	self._love = love
end

function Node:getLove()
	return self._love
end

function Node:getParent()
	return self._parent
end

function Node:isIgnoreEvents()
	return self._isIgnoreEvents == true
end

function Node:setIgnoreEvents(ignore)
	self._isIgnoreEvents = ignore == true
	return self
end

function Node:trigger(event, ...)
	local args = {...}
	if self[event] then self[event](unpack(args)) end
end

function Node:update(dt)
	self:foreachChildren(false, function(v) v:update(dt) end)
	if g_editor and g_editor._conf == self._conf then
		g_editor.auxiliary:onUpdate(self, dt)
	end
end

function Node:draw()
	if self._isHide then return end
	self:foreachChildren(false, function(v) v:draw() end)
	if g_editor and g_editor._conf == self._conf then
		g_editor.auxiliary:omDraw(self)
	end
end

function Node:mousepressed(x, y, button)
	self:foreachChildren(true, function(v) v:mousepressed(x, y, button) end)
end

function Node:mousemoved(x, y, dx, dy, istouch)
	self:foreachChildren(true, function(v) v:mousemoved(x, y, dx, dy, istouch) end)
end

function Node:mousereleased(x, y, button)
	self:foreachChildren(true, function(v) v:mousereleased(x, y, button) end)
end

function Node:wheelmoved(x, y)
	self:foreachChildren(true, function(v) v:wheelmoved(x, y) end)
end

function Node:keypressed(key, scancode, isrepeat)
	self:foreachChildren(true, function(v) v:keypressed(key, scancode, isrepeat) end)
end

function Node:keyreleased(key, scancode)
	self:foreachChildren(true, function(v) v:keyreleased(key, scancode) end)
end

function Node:textinput(text)
	self:foreachChildren(true, function(v) v:textinput(text) end)
end

function Node:foreachChildren(isReverse, callback)
	local children = self._children
	if isReverse then
		for i=#children,1,-1 do
			if children[i] then callback(children[i], i) end
		end
	else
		for i=1,#children,1 do
			if children[i] then callback(children[i], i) end
		end
	end
end

function Node:foreachDescendants(isReverse, callback)
	local children = self._children
	if isReverse then
		for i=#children,1,-1 do
			if children[i] then
				children[i]:foreachDescendants(isReverse, callback)
				callback(children[i])
			end
		end
	else
		callback(self)
		for i=1,#children,1 do
			if children[i] then
				callback(children[i])
				children[i]:foreachDescendants(isReverse, callback)
			end
		end
	end

end

function Node:hide()
	return self:setVisible(false)
end

function Node:show()
	return self:setVisible(true)
end

function Node:setVisible(isVisible)
	self._isHide = not isVisible
	return self
end

function Node:isVisible()
	return not self._isHide
end

function Node:setA(ax, ay)
	ax = ax or self._conf.ax
	ay = ay or self._conf.ay
	self._ax = math.max(0, math.min(1, ax or 0.5))
	self._ay = math.max(0, math.min(1, ay or 0.5))
	return self
end

function Node:_calculateNumber(useWidth, describe)
	assert(string.valid(describe))
	local calculation = nil
	if string.find(describe, "*") then
		local args = string.explode(describe, "*")
		assert(#args == 2)
		local useFlag = string.lower(args[1])
		if useFlag == "w" then
			useWidth = true
		elseif useFlag == "h" then
			useWidth = false
		end
		calculation = args[2]
	else
		calculation = describe
	end
	local equation = string.format("return %d * %s", useWidth and self._parent:getW() or self._parent:getH(), calculation)
	local func = loadstring(equation)
    return func()
end
function Node:setXYWH(x, y, w, h)
	self._conf.x = x or self._conf.x
	self._conf.y = y or self._conf.y
	self._x = is_number(self._conf.x) and self._conf.x or self:_calculateNumber(true, self._conf.x)
	self._y = is_number(self._conf.y) and self._conf.y or self:_calculateNumber(false, self._conf.y)
	if self._parent then
		self._x = self._x + self._parent:getLeft()
		self._y = self._y + self._parent:getTop()
	end
	self._conf.w = w or self._conf.w
	self._conf.h = h or self._conf.h
	self._w = is_number(self._conf.w) and self._conf.w or self:_calculateNumber(true, self._conf.w)
	self._h = is_number(self._conf.h) and self._conf.h or self:_calculateNumber(false, self._conf.h)
	self._w = math.max(0, self._w)
	self._h = math.max(0, self._h)
	for i,v in ipairs(self._children) do
		v:setXYWH()
	end
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
function Node:getBottom() return self._y + self._h * (1 - self._ay) end

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
    return mouseX > self:getLeft() and mouseX < self:getRight() and mouseY > self:getTop() and mouseY < self:getBottom()
end

function Node:onDestroy()
	local children = self._children
	self._children = {}
	for i=#children,1,-1 do
		local v = children[i]
		v:onDestroy()
	end
end

function Node:deleteChild(child)
	local key, value = table.find_value(self._children or {}, child)
	table.remove(self._children or {}, key)
	value:onDestroy()
	return self
end

function Node:removeSelf()
	assert(self._parent ~= nil)
	self._parent:deleteChild(self)
	return self
end

-- 

function Node:addTemplate(path)
	path = tostring(path)
	local configs = nil
	if g_editor then
		assert(string.valid(path) and files.is_file(path), 'invalid ui path:' .. path)
		configs = table.read_from_file(path)
	else
		if path:sub(1, 1) == "." then
			path = path:sub(2, -1)
		end
		assert(string.valid(path) and love.filesystem.getInfo(path) ~= nil, 'invalid ui path:' .. path)
		configs = string.table(love.filesystem.read(path))
	end
	assert(configs ~= nil, 'invalid ui config! in:' .. path)
	if not table.is_array(configs) then
		configs = {configs}
	end
	for i,v in ipairs(configs) do
		self:newConfig(v)
	end
	return self
end

function Node:newConfig(config, index)
	assert(_G[config.type], string.format('node [%s] not found!', config.type))
	if index then
		table.insert(self._conf.children, index, config)
	else
		table.insert(self._conf.children, config)
	end
	return self:_parseConfig(config, index)
end

function Node:_parseConfig(config, index)
	local child = _G[config.type](config, self)
	child.canvas = self.canvas or self
	if index then
		table.insert(self._children, index, child)
	else
		table.insert(self._children, child)
	end
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

function Node:refreshNode(updatedConf)
	if updatedConf == nil or updatedConf == self._conf then
		self:_checkConf()
		self:foreachChildren(false, function(v) v:refreshNode(nil) end)
	else
		self:foreachChildren(false, function(v) v:refreshNode(updatedConf) end)
	end
	return self
end
