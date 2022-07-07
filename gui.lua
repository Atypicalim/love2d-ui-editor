--[[
	gui
]]

require('tools/test')

require 'others/constants'
require 'others/tools'
require 'nodes/node'
require 'nodes/button'
require 'nodes/text'
require 'nodes/image'
require 'nodes/video'
require 'nodes/input'
require 'nodes/rectangle'
require 'nodes/ellipse'
require 'nodes/polygon'
require 'nodes/line'
require 'nodes/point'
require 'nodes/particle'
require 'nodes/clipper'

-- gui

Gui = class("Gui", Node)

function Gui:__init__()
	Node.__init__(self, {
		x = 0,
		y = 0,
		w = 0,
		h = 0,
	}, nil)
end

function Gui:draw()
	if not self._isHide then
		love.graphics.setColor(0.1, 0.1, 0.1, 150)
	    love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	end
	Node.draw(self)
end

-- interfaces

local gui = {}

local proxyObjects = {}

local function _initProxy()
    for k,v in pairs(LOVE_PROXY_FUNCTIONS) do
        local originFunction
        if love[k] then
            originFunction = love[k]
        end
        love[k] = function(...)
            local args = {...}
            for i,v in ipairs(proxyObjects) do
                if v[k] then
                    v[k](v, unpack(args))
                end
            end
            if originFunction then
                originFunction(unpack(args))
            end
        end
    end
end

function gui.useProxy(obj)
    assert(love ~= nil)
    if not love.usingProxy then
        _initProxy()
        love.usingProxy = true
    end
    if not table.find_value(proxyObjects, obj) then
		proxyObjects = {obj, unpack(proxyObjects)} -- using insert will cause a bug related to ipairs when trigger love2d event
    end
end

function gui.cancelProxy(obj)
    for i,v in ipairs(proxyObjects) do
        if obj == v then
            table.remove(proxyObjects, i)
            break
        end
    end
end

function gui.newGUI()
	local ui = Gui(self)
	gui.useProxy(ui)
	return ui
end

function gui.delGUI(ui)
	assert(ui.__name__ == Gui.__name__)
	gui.cancelProxy(ui)
end

return gui
