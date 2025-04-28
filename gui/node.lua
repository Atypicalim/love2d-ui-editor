--[[
	node
]]

Node = class("Node")

function Node:__init__(conf)
	self:_doInit()
	self._name = self.__name__
	self._conf = conf
	self._type = conf.type
	self._children = {}
	self._isDirty = true
	self._isMessy = true
	self._edity = false
	self._touchy = false
	self._conf:checkConf(self)
	self._conf:proxConf(self)
	self:_parseConf()
	self:_onInit()
end

function Node:_doInit()
end

function Node:_onInit()
end

function Node:isInnerNode()
	return self._isInnerNode == true
end

function Node:isOuterNode()
	return self._isOuterNode == true
end

function Node:adjustNode(node)
	if node then
		self._w = node:getWidth()
		self._h = node:getHeight()
	else
		self._w = 0
		self._h = 0
	end
end

function Node:_setDirty()
	self._isDirty = true
	self._isMessy = true
	self:foreachChildren(false, function(v)
		v:_setDirty()
	end)
	return self
end

function Node:_parseConf()
	self._isHide = self._conf.hide == true
	self._ax = math.max(0, math.min(1, self._conf.ax or 0.5))
	self._ay = math.max(0, math.min(1, self._conf.ay or 0.5))
	self._x = describe2xywh(true, self._conf.px, self:_parentW(), self:_parentH()) + self:_parentLeft()
	self._y = describe2xywh(false, self._conf.py, self:_parentW(), self:_parentH()) + self:_parentTop()
	self._w = math.max(0, describe2xywh(true, self._conf.sw, self:_parentW(), self:_parentH()))
	self._h = math.max(0, describe2xywh(false, self._conf.sh, self:_parentW(), self:_parentH()))
end

function Node:dumpConf()
	if self:isInnerNode() then
		return nil
	end
    local config = self._conf:dumpConf()
	for i,node in ipairs(self._children) do
		local _config = node:dumpConf()
		if _config then
			table.insert(config.children, _config)
		end
	end
	return config
end

function Node:addTemplate(path)
	return self:_addTemplate(path, false)
end

function Node:_addTemplate(path, inner)
	local configs = read_template(path)
	for i,config in ipairs(configs) do
		self:_addChild(config, inner)
	end
	return self
end

function Node:addChild(conf)
	return self:_addChild(conf, false)
end

function Node:_addChild(conf, inner)
	local _conf = Config.loadConf(conf)
	local _type = conf.type
	if not _G[_type] then
		error('invalid gui conf! content:' .. table.string(conf))
	end
	local node = _G[_type](_conf)
	if not node then
		error('invalid gui conf! content:' .. table.string(conf))
	end
	--
	node._isOuterNode = inner == false
	node._isInnerNode = inner == true
	if self._edity then
		node:setEdity()
	end
	--
	self:insertChild(node)
	for i,conf in ipairs(_conf:getConfChildren()) do
		node:_addChild(conf, inner)
	end
	return node
end

function Node:_error(...)
	local msg = string.format("[Node:%s] ", self.__name__) .. string.format(...)
	error(msg)
end

function Node:_assert(bCheck, ...)
	if bCheck ~= true then
		self:_error(...)
	end
end

function Node:getParent()
	return self._parent
end

function Node:isEdity()
	return self._edity == true
end

function Node:setEdity()
	self._edity = true
	return self
end

function Node:isTouchy()
	return self._touchy == true
end

function Node:setTouchy(touchy)
	self._touchy = touchy == true
	return self
end

function Node:trigger(event, ...)
	local args = {...}
	if self[event] then self[event](unpack(args)) end
end

function Node:update(dt)
	self:_doUpdate(dt)
	local isChange = self._isDirty
	if self._isDirty then
		self._isDirty = false
	end
	if isChange then
		self:_parseConf()
	end
	self:foreachChildren(false, function(v) v:update(dt) end)
	if g_editor then
		local targetConf = g_editor:getTargetConf()
		local selectCurrent = targetConf == self._conf
		if selectCurrent then
			g_editor.auxiliary:omUpdate(self, dt)
		end
	end
	self:_onUpdate(dt, isChange)
end

function Node:_doUpdate(dt, isChange)
end

function Node:_onUpdate(dt, isChange)
end

function Node:draw()
	if self._isHide then
		return
	end
	self:_doDraw()
	local isChange = self._isMessy
	if self._isMessy then
		self._isMessy = false
	end
	self:foreachChildren(false, function(v) v:draw() end)
	if g_editor then
		local targetConf = g_editor:getTargetConf()
		local selectCurrent = targetConf == self._conf
		if selectCurrent then
			g_editor.auxiliary:omDraw(self)
		end
	end
	self:_onDraw(isChange)
end

function Node:_doDraw()
end

function Node:_onDraw()
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
	self:setHide(not isVisible)
	self:_setDirty()
	return self
end

function Node:isVisible()
	return not self._isHide
end

function Node:setAnchor(ax, ay)
	self._conf:setConfAnchor(ax, ay)
	self:_setDirty()
	return self
end

function Node:setXYWH(x, y, w, h)
	self._conf:setConfXYWH(x, y, w, h)
	self:_setDirty()
	return self
end

function Node:setXY(x, y)
	return self:setXYWH(x, y, nil, nil)
end
function Node:getXY() return self:getX(), self:getY() end
function Node:setX(x) return self:setXY(x, nil) end
function Node:setY(y) return self:setXY(nil, y) end
function Node:getX() return self._x end
function Node:getY() return self._y end

function Node:setWH(w, h)
	return self:setXYWH(nil, nil, w, h)
end
function Node:getWH() return self:getW(), self:getH() end
function Node:setW(w) return self:setXY(w, nil) end
function Node:setH(h) return self:setXY(nil, h) end
function Node:getW() return self._w end
function Node:getH() return self._h end

function Node:getLeft() return self._x - self._w * self._ax end
function Node:getRight() return self._x + self._w * ((1 - self._ax)) end
function Node:getTop() return self._y - self._h * self._ay end
function Node:getBottom() return self._y + self._h * (1 - self._ay) end

function Node:_parentLeft()
	return self._parent and self._parent:getLeft() or 0
end
function Node:_parentTop()
	return self._parent and self._parent:getTop() or 0
end
function Node:_parentW()
	return self._parent and self._parent:getW() or 0
end
function Node:_parentH()
	return self._parent and self._parent:getH() or 0
end

function Node:getConf()
	return self._conf
end

function Node:getChildren()
	return self._children
end

function Node:hasOuterChildren()
	local res = false
	for i,v in ipairs(self._children) do
		if v:isOuterNode() then
			res = true
		end
	end
	return res
end

function Node:hasInnerChildren()
	local res = false
	for i,v in ipairs(self._children) do
		if v:isInnerNode() then
			res = true
		end
	end
	return res
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
	self._parent = nil
	local children = self._children
	self._children = {}
	for i=#children,1,-1 do
		local v = children[i]
		v:onDestroy()
	end
end

function Node:insertChild(child, index)
	if is_node(child._parent) then
		child._parent:removeChild(child, true)
	end
	if index then
		table.insert(self._children, index, child)
	else
		table.insert(self._children, child)
	end
	child._parent = self
end

function Node:removeChild(child, noDestory)
	local key = table.find_value(self._children, child)
	if key then
		table.remove(self._children, key)
	end
	if not noDestory then
		child:onDestroy()
	else
		child._parent = nil
	end
	return self
end

function Node:removeChildren(noDestory)
	local children = self._children
	self._children = {}
	for i=#children,1,-1 do
		local v = children[i]
		v:onDestroy()
	end
end

function Node:removeSelf(noDestory)
	assert(self._parent ~= nil)
	if is_node(self._parent) then
		self._parent:removeChild(self, noDestory)
	end
	return self
end

-- 

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
	if self._conf.type == nodeType then
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
		self:_setDirty()
		self:foreachChildren(false, function(v) v:refreshNode(nil) end)
	else
		self:foreachChildren(false, function(v) v:refreshNode(updatedConf) end)
	end
	return self
end
