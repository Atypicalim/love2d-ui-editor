--[[
    test
]]

package.path = package.path .. ";../?.lua"


local gui = require('../gui')
local WIDTH = 500
local HEIGHT = 500

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    gui = gui.newGUI("./app.ui.lua"):customize(WIDTH / 2, HEIGHT / 2, WIDTH, HEIGHT)
end
