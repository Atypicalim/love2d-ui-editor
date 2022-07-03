--[[
	editor
]]

require('thirds/pure-lua-tools/initialize')
require('thirds/gooi/gooi')

local Editor = class("Editor")
local Gui = require('gui')
require('editor/constants')
Printer = require('editor/printer')
Leaf = require('editor/leaf')
Tree = require('editor/tree')
Property = require('editor/property')
Attribute = require('editor/attribute')
Field = require('editor/field')

local EDITOR_X = 100
local EDITOR_Y = 100
local EDITOR_W = 1000
local EDITOR_H = 800

function Editor:__init__()
    --
    g_editor = self
    g_egui = Gui("./editor/editor.ui.lua", EDITOR_W / 2, EDITOR_H / 2, EDITOR_W, EDITOR_H)
    self._printer = Printer()
    --
    self._workspace = nil
    self._path = nil
    self._conf = nil
    self._key = nil
    --
    self._template = nil
    self._tree = nil
    self._attribute = nil
    self._field = nil
    self._describe = ""
    self._messages = {}
    -- 
    g_egui.onClick = function(id, node)
        self:_onClick(id, node)
    end
    --
    self:pushMessage('welcome!')
    self:setWorkspace(nil)
    -- self:setPath("./editor/editor.ui.lua")
end

function Editor:load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
	love.window.setMode(EDITOR_W, EDITOR_H)
	love.window.setPosition(EDITOR_X, EDITOR_Y)
	love.window.setFullscreen(false)
end

function Editor:update(dt)
    g_egui:update(dt)
    if self._template then
        self._template:update(dt)
    end
    if self._tree then
        self._tree:update(dt)
    end
    if self._attribute then
        self._attribute:update(dt)
    end
    if self._field then
        self._field:update(dt)
    end
end

function Editor:draw()
    g_egui:draw()
    if self._template then
        self._template:draw()
    else
        self._printer:print(g_egui:getById('nodeStage'), "please select a ui file ...")
    end
    if self._tree then
        self._tree:draw()
    else
        self._printer:print(g_egui:getById('bgLeft'), "no tree ...")
    end
    if self._attribute then
        self._attribute:draw()
    else
        self._printer:print(g_egui:getById('bgRight'), "no attribute ...")
    end
    if self._field then
        self._field:draw()
    else
        local distance = (1 - MESSAGE_MARGIN_RATE * 2) / (#self._messages * 2)
        for i,v in ipairs(self._messages) do
            self._printer:print(g_egui:getById('bgBottom'), v, nil, tostring(distance * (i * 2 - 1) + MESSAGE_MARGIN_RATE))
        end
    end
    self._printer:print(g_egui:getById('nodeStage'), self._describe, '0.5', '0+15')
end

function Editor:mousepressed(x, y, button)
	g_egui:mousepressed(x, y, button)
end

function Editor:mousereleased(x, y, button)
	g_egui:mousereleased(x, y, button)
end

function Editor:keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
    if self._field then
        self._field:onKey(key)
        return
    end
	g_egui:keypressed(key, scancode, isrepeat)
end

function Editor:keyreleased(key, scancode)
	g_egui:keyreleased(key, scancode)
end

function Editor:textinput(text)
	g_egui:textinput(text)
end

function Editor:setWorkspace(workspace)
    self._workspace = workspace
    self:setPath(nil)
    if not self._workspace then
        love.window.setTitle("Editor! workspace [empty]")
    else
        love.window.setTitle(string.format("Editor! workspace [%s]", self._workspace))
    end
end

function Editor:setPath(path)
    if self._tree then
        self._tree:destroy()
    end
    self._path = path
    self:setConf(nil)
    if not self._path then
        self._template = nil
        self._tree = nil
    else
        local parent = g_egui:getById('nodeStage')
        self._template = Gui(self._path, parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
        self._tree = Tree(g_egui:getById('boxTree'))
    end
end

function Editor:setConf(conf)
    if self._attribute then
        self._attribute:destroy()
    end
    self._conf = conf
    self:setKey(nil)
    if not self._conf then
        self._attribute = nil
    else
        self._attribute = Attribute(g_egui:getById('boxProp'))
    end
end

function Editor:setKey(key)
    if self._field then
        self._field:destroy()
    end
    self._key = key
    if not self._key then
        self._field = nil
    else
        self._field = Field(g_egui:getById('bgBottom'), function(text)
            self:setValue(text)
            self:setKey(nil)
        end, function(text)
            self:setKey(nil)
        end)
    end
    self:_updateDescribe()
end

function Editor:setValue(textValue)
    local oldValue = g_editor._conf[g_editor._key]
    local newValue = to_type(textValue, type(oldValue))
    if newValue ~= nil then
        g_editor._conf[g_editor._key] = newValue
    end
    g_attribute:_updateAttribute()
    self._template:doRefreshUi()
end

function Editor:_updateDescribe()
    local LENGTH = 15
    self._describe = ""
    if not self._path then return end
    self._describe = 'editing: [' .. tostring(self._path) .. ']'
    if not self._conf then return end
    local tp = tostring(self._conf.type)
    local id = tostring(self._conf.id)
    tp = #tp <= LENGTH and tp or string.sub(tp, 1, LENGTH) .. "..."
    id = #id <= LENGTH and id or string.sub(id, 1, LENGTH) .. "..."
    self._describe = self._describe .. "  [" .. tp .."]"
    self._describe = self._describe .. "  [" .. id .. "]"
    if not self._key then return end
    local key = tostring(self._key)
    key = #key <= LENGTH and key or string.sub(key, 1, LENGTH) .. "..."
    self._describe = self._describe .. "  [" .. key .."]"
end

function Editor:_onClick(id, event)
    --
    if id == 'btnClose' then
        love.event.quit()
        return
    elseif id == 'btnGithub' then
        if tools_platform_open_url(EDITOR_GITHUB_URL) then
            self:pushMessage('github opened in browser!')
        else
            self:pushMessage('github open failed!')
        end
        return
    end
    --
    if id == 'btnWorkspace' then
        local folder = tools_platform_select_folder('please select a love2d project or empty folder as workspace:', EDITOR_ROOT_FOLDER)
        if not string.valid(folder) or not files.is_folder(folder) then
            self:pushMessage('invalid folder!')
            return
        end
        local templateFiles = files.list(files.cwd() .. 'template')
        local workspaceFiles = files.list(folder)
        for i,v in ipairs(templateFiles) do
            if not files.is_file(folder .. "/" .. v) then
                files.copy(files.cwd() .. 'template/' .. v, folder .. "/" .. v)
                self:pushMessage('workspace created:' .. v)
            end
        end
        self:setWorkspace(folder)
        self:pushMessage('workspace selected!')
        return
    elseif not self._workspace then
        self:pushMessage('please select workspace!')
        return
    end
    -- 
    if id == 'btnCode' then
        local isOk, out = tools.execute([[code "]] .. self._workspace .. [["]])
        if isOk then
            self:pushMessage('workspace opened in vscode!')
            return
        end
        isOk, out = tools.execute([[subl "]] .. self._workspace .. [["]])
        if isOk then
            self:pushMessage('workspace opened in sublime!')
            return
        end
        self:pushMessage('no editor(vscode or sublime) found!')
        return
    end
    --
    if id == 'btnExplorer' then
        local isOk, out = tools_platform_open_path(self._workspace)
        print("===>", isOk, out)
        if isOk then
            self:pushMessage('workspace opened in explorer!')
        else
            self:pushMessage('workspace open failed!')
        end
        return
    end
    --
    if id == 'btnFileOpen' then
        local path = tools_platform_select_file('please select a ui file:', '*.ui.lua|*.ui.lua', self._workspace)
        if not string.valid(path) or not files.is_file(path) then
            self:pushMessage('invalid path in open!')
            return
        end
        self:setPath(path)
        self:pushMessage('file opened!')
        return
    elseif id == 'btnFileCreate' then
        local path = tools_platform_save_file('please target a ui file:', '*.ui.lua|*.ui.lua', self._workspace)
        if not string.valid(path) then
            self:pushMessage('invalid path in create!')
            return
        end
        files.copy(files.cwd() .. 'template/app.ui.lua', path)
        self:setPath(path)
        self:pushMessage('file created!')
        return
    elseif not self._path then
        self:pushMessage('please select file!')
        return
    end
end

function Editor:pushMessage(message)
    local date = os.date("%Y-%m-%d_%H:%M:%S", os.time())
    local msg = string.format("[%s] %s", date, tostring(message))
    local new = {msg}
    for i=#self._messages,1,-1 do
        if #new < MESSAGE_MAX_COUNT then
            table.insert(new, 1, self._messages[i])
        end
    end
    self._messages = new
end

return Editor
