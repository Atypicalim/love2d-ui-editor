--[[
	gui
]]

package.path = package.path .. ";" .. "G:/Tests/LuaTest/?.lua"
require 'pure-lua-tools/test'

require 'gui/constants'
require 'gui/tools'
require 'gui/node'
require 'gui/text'
require 'gui/image'
require 'gui/video'
require 'gui/input'
require 'gui/layer'
require 'gui/check'
require 'gui/button'
require 'gui/rectangle'
require 'gui/ellipse'
require 'gui/polygon'
require 'gui/arc'
require 'gui/line'
require 'gui/point'
require 'gui/particle'
require 'gui/clipper'
require 'gui/template'

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

function Gui:mousepressed(x, y, button)
    local pressedNode = nil
	self:foreachDescendants(true, function(v)
        if not pressedNode and v:isHover() and not v:isIgnoreEvents() then
            pressedNode = v
            return true
        end
    end)
    if pressedNode then
        pressedNode:trigger(NODE_EVENTS.ON_MOUSE_DOWN, x, y, button)
    end
    self._pressedNode = pressedNode
    Node.mousepressed(self, x, y, button)
    self:trigger(NODE_EVENTS.ON_MOUSE_DOWN, x, y, button)
end

function Gui:mousemoved(x, y, dx, dy, istouch)
    local movedNode = nil
	self:foreachDescendants(true, function(v)
        if not movedNode and v:isHover() and not v:isIgnoreEvents() then
            movedNode = v
            return true
        end
    end)
    if movedNode and not self._movedNode then
        movedNode:trigger(NODE_EVENTS.ON_MOUSE_IN, x, y, dx, dy, istouch)
        self:trigger(NODE_EVENTS.ON_MOUSE_IN, movedNode, x, y, dx, dy, istouch)
    elseif not movedNode and self._movedNode then
        self._movedNode:trigger(NODE_EVENTS.ON_MOUSE_OUT, x, y, dx, dy, istouch)
        self:trigger(NODE_EVENTS.ON_MOUSE_OUT, self._movedNode, x, y, dx, dy, istouch)
    elseif self._movedNode ~= movedNode then
        self._movedNode:trigger(NODE_EVENTS.ON_MOUSE_OUT, x, y, dx, dy, istouch)
        self:trigger(NODE_EVENTS.ON_MOUSE_OUT, self._movedNode, x, y, dx, dy, istouch)
        movedNode:trigger(NODE_EVENTS.ON_MOUSE_IN, x, y, dx, dy, istouch)
        self:trigger(NODE_EVENTS.ON_MOUSE_IN, movedNode, x, y, dx, dy, istouch)
    end
    self._movedNode = movedNode
    Node.mousemoved(self, x, y, dx, dy, istouch)
    self:trigger(NODE_EVENTS.ON_MOUSE_MOVE, x, y, dx, dy, istouch)
end

function Gui:mousereleased(x, y, button)
    local releaseddNode = nil
	self:foreachDescendants(true, function(v)
        if not releaseddNode and v:isHover() and not v:isIgnoreEvents() then
            releaseddNode = v
            return true
        end
    end)
    if releaseddNode then
        releaseddNode:trigger(NODE_EVENTS.ON_MOUSE_UP, x, y, button)
        if self._pressedNode == releaseddNode then
            releaseddNode:trigger(NODE_EVENTS.ON_CLICK, x, y, button)
            self:trigger(NODE_EVENTS.ON_CLICK, releaseddNode, x, y, button)
        elseif self._pressedNode then
            self._pressedNode:trigger(NODE_EVENTS.ON_CANCEL, x, y, button)
            self:trigger(NODE_EVENTS.ON_CANCEL, self._pressedNode, x, y, button)
        end
    elseif self._pressedNode then
        self._pressedNode:trigger(NODE_EVENTS.ON_CANCEL, x, y, button)
        self:trigger(NODE_EVENTS.ON_CANCEL, self._pressedNode, x, y, button)
    end
    self._releaseddNode = releaseddNode
    Node.mousereleased(self, x, y, button)
    self:trigger(NODE_EVENTS.ON_MOUSE_UP, x, y, button)
end

function Gui:getFocus()
    return self._pressedNode
end

function Gui:setTarget()
    return self._movedNode
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
