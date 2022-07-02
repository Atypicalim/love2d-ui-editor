--[[
	gui
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

require 'others/constants'
require 'others/tools'
require 'nodes/node'
require 'nodes/button'
require 'nodes/text'
require 'nodes/input'
require 'nodes/rectangle'

local Gui = class('Gui')

function Gui:__init__(pathOrTable, x, y, w, h, bgColor)
	if is_table(pathOrTable) then
		assert(not table.is_empty(pathOrTable), 'invalid ui config')
		self._config = pathOrTable
	else
		assert(string.valid(pathOrTable) and files.is_file(pathOrTable), 'invalid ui path!')
		self._config = table.read_from_file(pathOrTable)
	end
	assert(is_number(x), 'invalid ui x!')
	assert(is_number(y), 'invalid ui y!')
	assert(is_number(w), 'invalid ui w!')
	assert(is_number(h), 'invalid ui h!')
	assert(bgColor == nil or is_table(bgColor), 'invalid ui color!')
	self._id2node = {}
	self._canvas = Rectangle(self, {
		type = "Rectangle",
		id = "bgCanvas",
		x = x,
		y = y,
		w = w,
		h = h,
		color = bgColor or rgba2hex(10, 10, 10, 150),
		children = self._config,
	})
	gooi.desktopMode()
end

function Gui:update(dt)
	self._canvas:update(dt)
	gooi.update(dt)
end

function Gui:draw()
	self._canvas:draw()
	gooi.draw()
end

function Gui:mousepressed(x, y, button)
	gooi.pressed()
end

function Gui:mousereleased(x, y, button)
	gooi.released()
end

function Gui:keypressed(key, scancode, isrepeat)
	gooi.keypressed(key, scancode, isrepeat)
end

function Gui:keyreleased(key, scancode)
	gooi.keyreleased(key, scancode)
end

function Gui:textinput(text)
	gooi.textinput(text)
  end

function Gui:create(configs, parent)
	local children = {}
	for i,v in ipairs(configs) do
		assert(_G[v.type], string.format('node [%s] not found!', v.type))
		local child = _G[v.type](self, v, parent)
		table.insert(children, child)
		if string.valid(v.id) then
			assert(self._id2node[v.id] == nil, 'multiple node id:' .. v.id)
			self._id2node[v.id] = child
		end
	end
	return children
end

function Gui:getById(nodeId)
	assert(string.valid(nodeId), 'invalid node id!')
	return self._id2node[nodeId]
end

function Gui:getByType(nodeType)
	local nodes = {}
	for k,v in pairs(self._id2node) do
		if v:getConf().type == nodeType then
			table.insert(nodes, v)
		end
	end
	return nodes
end

function Gui:getRootNode()
	return self._canvas
end

return Gui
