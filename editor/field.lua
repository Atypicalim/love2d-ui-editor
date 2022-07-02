--[[
    Field
]]

local Field = class("Field")

function Field:__init__(parent)
    g_input = self
    self._parent = parent
    --
    self._input = Input(g_egui, {
        x = '0.5',
        y = '0.5',
        w = '0.7',
        h = '0.5',
    }, self._parent)
    self._input:setText(g_editor._conf[g_editor._key])
    --
    self._btnOk = Button(g_egui, {
        x = '0.9',
        y = '0.5',
        w = 25,
        h = 25,
        color = rgba2hex(255, 0, 0),
    }, self._parent)
    self._btnOk:setIcon("/media/confirm.png")
    self._btnOk.onClick = function()
        g_editor:setValue(self._input:getText())
        g_editor:setKey(nil)
    end
    --
    self._btnNo = Button(g_egui, {
        x = '0.1',
        y = '0.5',
        w = 25,
        h = 25,
        color = rgba2hex(255, 0, 0),
    }, self._parent)
    self._btnNo:setIcon("/media/cancel.png")
    self._btnNo.onClick = function()
        g_editor:setKey(nil)
    end
end

function Field:update(dt)
    self._input:update(dt)
    self._btnOk:update(dt)
    self._btnNo:update(dt)
end

function Field:draw()
    self._input:draw()
    self._btnOk:draw()
    self._btnNo:draw()
end

function Field:destroy()
    self._input:destroy()
    self._btnOk:destroy()
    self._btnNo:destroy()
end

return Field
