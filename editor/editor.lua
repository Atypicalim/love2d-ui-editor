--[[
	editor
]]

require('thirds/tools/test')
require('thirds/gooi/gooi')

local Editor = class("Editor")
local gui = require('gui')
require('editor/constants')
Printer = require('editor/printer')
Leaf = require('editor/leaf')
Tree = require('editor/tree')
Property = require('editor/property')
Attribute = require('editor/attribute')
Field = require('editor/field')

function Editor:__init__()
    gui.useProxy(self)
    --
    g_editor = self
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
end

function Editor:load()
	love.window.setMode(EDITOR_WIDTH, EDITOR_HEIGHT, {
        minwidth = EDITOR_WIDTH,
        minheight = EDITOR_HEIGHT,
        resizable = true,
        centered = true,
    })
	love.window.setFullscreen(false)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    --
    g_egui = gui.newGUI():setXYWH(width / 2, height / 2, width, height):addTemplate("./editor/editor.ui.lua")
    g_egui.onClick = function(id, node)
        self:_onClick(id, node)
    end
    self._printer = Printer(g_egui)
    --
    self:pushMessage('welcome!')
    self:setWorkspace(files.cwd() .. "/template/")
    -- self:setPath("./template/app.ui.lua")
    -- self:setConf(self._template:getConf()[1])
    -- self:setKey('color')
    self:setPath("./editor/editor.ui.lua")
end

function Editor:update(dt)
	gooi.update(dt)
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
	gooi.draw()
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

function Editor:keypressed(key, scancode, isrepeat)
	gooi.keypressed(key, scancode, isrepeat)
    if key == 'f5' then
        love.event.quit('restart')
        return
    end
    if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
        if key == 'o' then
            self:setKey(nil)
            if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
                self:_tryOpenWorkspace()
            else
                self:_tryOpenFile()
            end
        elseif key == 'n' then
            self:setKey(nil)
            self:_tryCreateFile()
        elseif key == 's' then
            self:setKey(nil)
            if love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') then
                self:_trySaveFile(true)
            else
                self:_trySaveFile(false)
            end
        end
    end
    if self._field then
        self._field:onKey(key)
        return
    end
    if key == 'escape' then
        if self._conf then
            self:setConf(nil)
        end
    end
end

function Editor:keyreleased(key, scancode)
	gooi.keyreleased(key, scancode)
end

function Editor:mousepressed(x, y, button)
	gooi.pressed()
end

function Editor:mousereleased(x, y, button)
	gooi.released()
end

function Editor:textinput(text)
	gooi.textinput(text)
end

function Editor:resize(width, height)
    g_egui:setXYWH(width / 2, height / 2, width, height)
    local parent = g_egui:getById('nodeStage')
    self._template:setXYWH(parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
    local path = self._path
    local conf = self._conf
    local key = self._key
    self:setPath(path)
    self:setConf(conf)
    self:setKey(key)
end

function Editor:wheelmoved(x, y)
    if self._tree then
        self._tree:wheelmoved(x, y)
    end
    if self._attribute then
        self._attribute:wheelmoved(x, y)
    end
end

function Editor:setWorkspace(workspace)
    self._workspace = workspace
    self:setPath(nil)
    if not self._workspace or not files.is_folder(self._workspace) then
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
    if not self._path or not files.is_file(self._path) then
        self._template = nil
        self._tree = nil
    else
        local parent = g_egui:getById('nodeStage')
        self._template = gui.newGUI():setXYWH(parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100):addTemplate(self._path)
        self._tree = Tree(g_egui:getById('boxTree'))
    end
end

function Editor:setConf(conf)
    if self._attribute then
        self._attribute:destroy()
    end
    self._conf = conf
    self:setKey(nil)
    if self._tree then
        self._tree:updateColor()
    end
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
    if self._attribute then
        self._attribute:updateColor()
    end
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
        self:_tryOpenWorkspace()
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
        if isOk then
            self:pushMessage('workspace opened in explorer!')
        else
            self:pushMessage('workspace open failed!')
        end
        return
    end
    --
    if id == 'btnFileOpen' then
        self:_tryOpenFile()
        return
    elseif id == 'btnFileCreate' then
        self:_tryCreateFile()
        return
    elseif not self._path then
        self:pushMessage('please select file!')
        return
    end
    --
    if id == 'btnFileSave' then
        self:_trySaveFile(false)
        return
    elseif id == 'btnPreview' then
        local isOk, out = tools.execute([[start love . "]] .. self._path .. [["]])
        self:pushMessage('preview opened!')
        return
    elseif id == 'btnBuild' then
        --
        return
    end
end

function Editor:_tryOpenWorkspace()
    local folder = tools_platform_select_folder('please select a love2d project or empty folder as workspace:', files.cwd())
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
end

function Editor:_tryOpenFile()
    local path = tools_platform_select_file('please select a ui file to open:', '*.ui.lua|*.ui.lua', self._workspace)
    if not string.valid(path) or not files.is_file(path) then
        self:pushMessage('invalid path to open!')
        return
    end
    self:setPath(path)
    self:pushMessage('file opened!')
end

function Editor:_tryCreateFile()
    local path = tools_platform_save_file('please enter a file to create ui:', '*.ui.lua|*.ui.lua', self._workspace)
    if not string.valid(path) then
        self:pushMessage('invalid path to create!')
        return
    end
    files.copy(files.cwd() .. 'template/app.ui.lua', path)
    self:setPath(path)
    self:pushMessage('file created!')
end

function Editor:_trySaveFile(toNewFile)
    local config = self._template:getConf()
    local content = table.string(config, nil, PROPERTY_NAME_ORDER)

    if toNewFile then
        local path = tools_platform_save_file('please enter a file to save ui:', '*.ui.lua|*.ui.lua', self._workspace)
        if not string.valid(path) then
            self:pushMessage('invalid path to save!')
        else
            files.write(path, content)
            self:pushMessage('file saved:' .. path)
            self:setPath(path)
            self:pushMessage('file opened!')
        end
    else
        files.write(self._path, content)
        self:pushMessage('file saved:' .. self._path)
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
