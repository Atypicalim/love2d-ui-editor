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
require 'nodes/rectangle'

local Gui = class('Gui')

function Gui:__init__(uiPath, x, y, w, h, bgColor)
	assert(string.valid(uiPath) and files.is_file(uiPath), 'invalid ui path!')
	assert(is_number(x), 'invalid ui x!')
	assert(is_number(y), 'invalid ui y!')
	assert(is_number(w), 'invalid ui w!')
	assert(is_number(h), 'invalid ui h!')
	assert(bgColor == nil or is_table(bgColor), 'invalid ui color!')
	self._config = table.read_from_file(uiPath)
	self._canvas = Rectangle({
		type = "Rectangle",
		id = "bgCanvas",
		x = x,
		y = y,
		w = w,
		h = h,
		color = bgColor or {10, 10, 10, 150},
	})
	self._children = tools_create_nodes(self._config, self._canvas)
end

function Gui:update(dt)
	self._canvas:update(dt)
	for i,v in ipairs(self._children) do
		v:update(dt)
	end
end

function Gui:draw()
	self._canvas:draw()
	for i,v in ipairs(self._children) do
		v:draw()
	end
end

function Gui:getById(nodeId)
	return {}
end

function Gui:getByType(nodeType)
end

return Gui
