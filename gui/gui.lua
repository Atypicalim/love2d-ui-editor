--[[
	gui
]]

package.path = package.path .. ";../?.lua"
require 'pure-lua-tools/tools'

require 'gui/constants'
require 'gui/tools'
require 'gui/config'
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
	local _config = Config.loadConf({
        type = "Gui",
		px = 0,
		py = 0,
		sw = '0.5',
		sh = '0.5',
	})
	Node.__init__(self, _config, nil)
end

function Gui:draw()
	if not self._isHide then
		love.graphics.setColor(0.1, 0.1, 0.1, 150)
	    love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
	end
	Node.draw(self)
end

function Gui:_getHoverTouchyNode()
    local node = nil
    if self:isEdity() then
        self:foreachDescendants(true, function(v)
            if not node and v:isHover() and v:isOuterNode() then
                node = v
                return true
            end
        end)
    else
        self:foreachDescendants(true, function(v)
            if not node and v:isHover() and v:isTouchy() then
                node = v
                return true
            end
        end)
    end
    return node
end

function Gui:_safeTriggerNodeEvent(event, node, ...)
    self:trigger(event, node, ...)
    if node and not node:isEdity() then
        node:trigger(event, ...)
    end
end

-- x, y, button
function Gui:mousepressed(...)
    self._pressedNode = self:_getHoverTouchyNode()
    self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_DOWN, self._pressedNode, ...)
    Node.mousepressed(self, ...)
end

-- x, y, dx, dy, istouch
function Gui:mousemoved(...)
    local movedNode = self:_getHoverTouchyNode()
    if movedNode and not self._movedNode then
        self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_IN, movedNode, ...)
    elseif not movedNode and self._movedNode then
        self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_OUT, self._movedNode, ...)
    elseif self._movedNode ~= movedNode then
        self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_OUT, self._movedNode, ...)
        self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_IN, movedNode, ...)
    end
    self._movedNode = movedNode
    self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_MOVE, self._movedNode, ...)
    Node.mousemoved(self, ...)
end

-- x, y, button
function Gui:mousereleased(...)
    self._releaseddNode = self:_getHoverTouchyNode()
    if self._releaseddNode then
        if self._pressedNode == self._releaseddNode then
            self:_safeTriggerNodeEvent(NODE_EVENTS.ON_CLICK, self._releaseddNode, ...)
        elseif self._pressedNode then
            self:_safeTriggerNodeEvent(NODE_EVENTS.ON_CANCEL, self._pressedNode, ...)
        end
    elseif self._pressedNode then
        self:_safeTriggerNodeEvent(NODE_EVENTS.ON_CANCEL, self._pressedNode, ...)
    end
    self:_safeTriggerNodeEvent(NODE_EVENTS.ON_MOUSE_UP, self._releaseddNode, ...)
    Node.mousereleased(self, ...)
end

-- helper

for ctrl,_ in pairs(CONTROL_CONF_MAP) do
    if ctrl ~= "Gui" then
        local cls = _G[ctrl]
        assert(cls ~= nil, 'control not found for ctrl:' .. ctrl)
        assert(Node['new' .. ctrl] == nil, 'multiple new func for ctrl:', ctrl)
        Node['_new' .. ctrl] = function(self, conf)
            assert(conf.type == nil, 'multiple type value for ctrl:', ctrl)
            conf.type = ctrl
            local node = self:_addChild(conf, true)
            return node
        end
        Node['New' .. ctrl] = function(self, conf)
            assert(conf.type == nil, 'multiple type value for ctrl:', ctrl)
            conf.type = ctrl
            local node = self:_addChild(conf, false)
            return node
        end
    end
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
