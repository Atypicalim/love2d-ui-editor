--[[
	editor
]]

local gui = require('gui/gui')
local Editor = class("Editor")
require('editor/constants')
Printer = require('editor/printer')
Leaf = require('editor/leaf')
Tree = require('editor/tree')
Property = require('editor/property')
Control = require('editor/control')
Attribute = require('editor/attribute')
Field = require('editor/field')
Auxiliary = require('editor/auxiliary')

function Editor:__init__()
    gui.useProxy(self)
    --
    g_editor = self
    self._workspace = nil
    self._path = nil
    self._conf = nil
    self._key = nil
    self._selecting = false
    --
    self._template = nil
    self._tree = nil
    self._attribute = nil
    self._field = nil
    self._describe = ""
    self._messages = {}
    -- 
    self.guiConf = {
        w = 500,
        h = 500,
    }
    self.auxiliary = Auxiliary()
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
    g_egui:update(0)
    g_egui.onClick = function(node)
        self:_onClick(node:getId(), node)
    end
    self._printer = Printer(g_egui)
    --
    self:pushMessage('welcome!')
    self:setWorkspace(files.cwd() .. "/template/")
    -- self:setPath("./template/app.ui.lua")
    -- self:setConf(self._template:getConf()[1], true)
    -- self:setKey('color')
    self:setPath("./editor/editor.ui.lua")
end

function Editor:update(dt)
    if self._template then
        self._template:update(dt)
    end
    if self._field then
        self._field:update(dt)
    end
end

function Editor:draw()
    if self._template then
        self._template:draw()
    else
        self._printer:print(g_egui:getById('nodeStage'), "please select a ui file ...")
    end
    if not self._tree then
        self._printer:print(g_egui:getById('bgLeft'), "no tree ...")
    end
    if not self._attribute then
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
    if key == 'f5' then
        love.event.quit('restart')
        return
    elseif key == 'f1' then
        local txt = files.read("./test.lua")
        local fun = loadstring(txt)
        if fun then
            fun()
            print('test code executed!')
        else
            print('test code invalid!')
        end
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
        if self._key then
            self:setKey(nil)
        elseif self._conf then
            self:setConf(nil, true)
        end
    end
end

function Editor:resize(width, height)
    g_egui:setXYWH(width / 2, height / 2, width, height)
    g_egui:update(0)
    self:_refreshEditor()
end

function Editor:wheelmoved(x, y)
    if self._tree then
        self._tree:wheelmoved(x, y)
    end
    if self._attribute then
        self._attribute:wheelmoved(x, y)
    end
    -- TODO: treee
    -- applyTransform
    -- translate
    -- scale
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
    if self._template then
        gui.delGUI(self._template)
    end
    if self._tree then
        self._tree:destroy()
    end
    self._path = path
    self:setConf(nil, true)
    if not self._path or not files.is_file(self._path) then
        self._template = nil
        self._tree = nil
    else
        local parent = g_egui:getById('nodeStage')
        local x = parent:getX()
        local y = parent:getY()
        local w = parent:getW() - 100
        local h = parent:getH() - 100
        self._template = gui.newGUI():setXYWH(x, y, w, h):debugTouchable():addTemplate(self._path)
        self._tree = Tree(g_egui:getById('boxTree'))
        self._template.onClick = function(node)
            self:setConf(node:getConf(), false)
        end
    end
end

function Editor:isSelect(select)
    return self._selecting == true
end

function Editor:setConf(conf, selected)
    if self._attribute then
        self._attribute:destroy()
    end
    self._conf = conf or g_editor.guiConf
    self._selecting = selected == true
    self:setKey(nil)
    if self._tree then
        self._tree:updateStatus()
    end
    if not self._conf then
        self._attribute = nil
    else
        self._attribute = Attribute(g_egui:getById('boxAttribute'))
    end
end

function Editor:setKey(key)
    if self._field then
        self._field:destroy()
    end
    self._key = key
    if self._attribute then
        self._attribute:updateStatus()
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
    self._template:refreshNode(g_editor._conf)
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
        if tools.open_url(EDITOR_GITHUB_URL) then
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
        local isOk, out = dialog.open_path(self._workspace)
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
        local guiFolder = self._workspace .. "gui/"
        local toolsFolder = self._workspace .. "tools/"
        local releaseFolder = self._workspace .. "release/"
        local appZip = self._workspace .. "app.zip"
        local function clear(removeRelase)
            os.execute("rm -rf " .. guiFolder)
            os.execute("rm -rf " .. toolsFolder)
            if removeRelase then os.execute("rm -rf " .. releaseFolder) end
            files.delete(appZip)
        end
        clear(true)
        -- 
        self:pushMessage('running build...')
        error('TODO:move gui and tools to target folder!!!')
        local isOk, out
        --
        isOk, out = tools.execute([[cd ]] .. self._workspace .. [[ && zip -9 -r "]] .. appZip .. [[" ./]])
        if not isOk then
            self:pushMessage('zip command failed...')
            print(out)
            return
        end
        --
        isOk, out = tools.where_is("love")
        if not isOk then
            self:pushMessage('love not found...')
            print(out)
            return
        end
        --
        files.sync(files.get_folder(out), releaseFolder)
        os.rename(appZip, releaseFolder .. 'app.love')
        isOk, out = tools.execute([[cd ]] .. releaseFolder .. [[ && cmd /c copy /b love.exe+app.love app.exe]])
        if not isOk then
            self:pushMessage('zip command failed...')
            print(out)
            return
        end
        --
        clear(false)
        os.remove(releaseFolder .. "app.love")
        os.remove(releaseFolder .. "Uninstall.exe")
        os.remove(releaseFolder .. "love.exe")
        os.remove(releaseFolder .. "lovec.exe")
        os.remove(releaseFolder .. "love.ico")
        os.remove(releaseFolder .. "game.ico")
        os.remove(releaseFolder .. "readme.txt")
        os.remove(releaseFolder .. "license.txt")
        os.remove(releaseFolder .. "changes.txt")
        -- 
        self:pushMessage('Finished!')
        dialog.open_path(releaseFolder)
        return
    end
end

function Editor:_tryOpenWorkspace()
    local folder = dialog.select_folder('please select a love2d project or empty folder as workspace:', files.cwd())
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
    local path = dialog.select_file('please select a ui file to open:', '*.ui.lua|*.ui.lua', self._workspace)
    if not string.valid(path) or not files.is_file(path) then
        self:pushMessage('invalid path to open!')
        return
    end
    self:setPath(path)
    self:pushMessage('file opened!')
end

function Editor:_tryCreateFile()
    local path = dialog.select_save('please enter a file to create ui:', '*.ui.lua|*.ui.lua', self._workspace)
    if not string.valid(path) then
        self:pushMessage('invalid path to create!')
        return
    end
    files.copy(files.cwd() .. 'template/app.ui.lua', path)
    self:setPath(path)
    self:pushMessage('file created!')
end

function Editor:_trySaveFile(toNewFile)
    local config = self._template:getConf().children or {}
    local content = table.string(config, nil, PROPERTY_NAME_ORDER, nil, nil, true)

    if toNewFile then
        local path = dialog.select_save('please enter a file to save ui:', '*.ui.lua|*.ui.lua', self._workspace)
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

function Editor:addControl(name, position)
    --
    local targetNode = nil
    local targetIndex = nil
    --
    local parent = nil
    local current = nil
    local index = nil
    local found = false
    self._template:foreachDescendants(false, function(descendant)
        descendant:foreachChildren(false, function(child, i)
            if child:getConf() == self._conf then
                found = true
                parent = descendant
                current = child
                index = i
            end
        end)
        return found
    end)
    if found then
        if position == 0 then
            targetNode = current
            targetIndex = #targetNode:getChildren() + 1
        elseif position == -1 then
            targetNode = parent
            targetIndex = index
        elseif position == 1 then
            targetNode = parent
            targetIndex = index + 1
        end
    elseif self._conf == self.guiConf then
        targetNode = self._template
        targetIndex = position == -1 and 1 or (#targetNode:getChildren() + 1)
    end
    if not targetNode or not targetIndex then
        self:pushMessage('add control failed, target not found!')
        return
    end
    targetNode:addChild({
        type = "Text",
        x = "0.5",
        y = "0.5",
        w = "1",
        h = "1",
        text = "insert...",
    }, targetIndex)
    self:_refreshEditor()
end

function Editor:_refreshEditor()
    if self._template then
        local parent = g_egui:getById('nodeStage')
        self._template:setXYWH(parent:getX(), parent:getY(), parent:getW() - 100, parent:getH() - 100)
        self._template:refreshNode()
    end
    if self._tree then
        self._tree:_updateTree()
    end
    if self._attribute then
        self._attribute:_updateAttribute()
    end
    if self._field then
        self:setKey(nil)
    end
end

return Editor
