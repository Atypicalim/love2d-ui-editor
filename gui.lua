--[[
	gui
]]

require('thirds/tools/test')
require('thirds/gooi/gooi')

require 'others/constants'
require 'others/tools'
require 'nodes/node'
require 'nodes/button'
require 'nodes/text'
require 'nodes/image'
require 'nodes/input'
require 'nodes/rectangle'
require 'nodes/canvas'
require 'nodes/clipper'

-- interfaces

local gui = {}

local proxyObjects = {}

function gui._initProxy()
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
        gui._initProxy()
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
	gooi.desktopMode()
	local canvas = Canvas(self)
	gui.useProxy(canvas)
	return canvas
end

function gui.delGUI(canvas)
	assert(canvas:getConf().type == 'Canvas')
	gui.cancelProxy(canvas)
end

return gui
