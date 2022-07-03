--[[
    test
]]

local Editor = require('editor/editor')
local Previewer = require('editor/previewer')

function love.load()
    if string.valid(arg[2]) and files.is_file(arg[2]) and string.find(arg[2], '.ui.lua') then
        previewer = Previewer(arg[2])
        previewer:load()
    else
        editor = Editor()
        editor:load()
    end
end
