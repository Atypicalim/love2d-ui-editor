--[[
	gui
]]

require 'others/constants'
require 'others/tools'
require 'nodes/node'
require 'nodes/button'
require 'nodes/text'
require 'nodes/rectangle'

local Gui = Node:ext()

function Gui:init(uiPath)
	self._config = table.read_from_file(uiPath)
	self._options = self._config.options
	self._window = self._config.window
	Node.init(self, self._window, nil)
	self._children = tools_create_nodes(self._config.children, self)
end

function Gui:load()
	love.window.setMode(self._window.w, self._window.h)
	love.window.setPosition(self._window.x, self._window.y)
	love.window.setTitle(self._options.title)
	love.window.setFullscreen(self._options.fullscreen)
end

function Gui:update(dt)
	for i,v in ipairs(self._children) do
		v:update()
	end
end

function Gui:draw()
	tools_set_color(self._options.background)
    love.graphics.rectangle("fill", 0, 0, self._window.w, self._window.h)
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
