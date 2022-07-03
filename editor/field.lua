--[[
    Field
]]

local Field = class("Field")

function Field:__init__(parent, yesFunc, noFunc)
    g_input = self
    self._parent = parent
    --
    self._input = Input(g_egui, {
        x = '0.5',
        y = '0.5',
        w = '0.7',
        h = '0.5',
    }, self._parent)
    self._input:setText(tostring(g_editor._conf[g_editor._key]))
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
        yesFunc(self._input:getText())
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
        noFunc(self._input:getText())
    end
    -- focus text input
    self._input.text.hasFocus = true
    gooi.focused = self._input.text
    love.keyboard.setTextInput(true)

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

function Field:onKey(key)
    if key == 'escape' then
        self._btnNo.onClick()
        love.keyboard.setTextInput(false)
    elseif key == 'return' then
        self._btnOk.onClick()
        love.keyboard.setTextInput(false)
    else
        if love.keyboard.isDown('lctrl') or love.keyboard.isDown('rctrl') then
            if key == 'x' then
                love.system.setClipboardText(self._input:getText())
                self._input:setText("")
            elseif key == 'c' then
                love.system.setClipboardText(self._input:getText())
            elseif key == 'v' then
                local txt = self._input:getText()
                self._input:setText(txt .. love.system.getClipboardText())
            end
        else
            if key == 'backspace' then
                -- self._input.text:deleteBack()
            elseif key == 'delete' then
                -- self._input.text:deleteDel()
            elseif key == 'right' then
                -- self._input.text:moveRight()
            elseif key == 'left' then
                -- self._input.text:moveLeft()
            end
        end
    end
end

return Field
