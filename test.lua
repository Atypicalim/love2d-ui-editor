--[[
    test codes
]]

require 'thirds/pure-lua-tools/initialize'
require 'others/tools'

local folder = files.cwd():sub(1, -2):gsub('/', '\\')
tools_platform_select_folder(nil, folder)