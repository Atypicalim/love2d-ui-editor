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

function Gui:__init__(uiPath, x, y, w, h, bgColor)
	assert(string.valid(uiPath) and files.is_file(uiPath), 'invalid ui path!')
	assert(is_number(x), 'invalid ui x!')
	assert(is_number(y), 'invalid ui y!')
	assert(is_number(w), 'invalid ui w!')
	assert(is_number(h), 'invalid ui h!')
	assert(bgColor == nil or is_table(bgColor), 'invalid ui color!')
	self._canvasX = x
	self._canvasY = y
	self._canvasW = w
	self._canvasH = h
	self._config = table.read_from_file(uiPath)
	self:doRefreshUi()
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

function Gui:getUiConfig()
	return self._config
end

function Gui:doRefreshUi()
	self._id2node = {}
	if self._canvas then
		self._canvas:destroy()
	end
	self._canvas = Rectangle(self, {
		x = self._canvasX,
		y = self._canvasY,
		w = self._canvasW,
		h = self._canvasH,
		color = bgColor or rgba2hex(10, 10, 10, 150),
		children = self._config,
	})
end

return Gui
