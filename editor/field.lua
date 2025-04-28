--[[
    Field
]]

local Field = class("Field")

function Field:__init__(parent, yesFunc, noFunc)
    g_input = self
    self._parent = parent
    --
    self._input = self._parent:addChild({
        type = "Input",
        x = '0.5',
        y = '0.5',
        w = '0.7',
        h = '0.5',
        color = "#111111aa",
    })
    
    local targetConf = g_editor:getTargetConf()
    local targetKey = g_editor:getTargetKey()
    local targetVal = targetConf[targetKey]
    self._input:setText(tostring(targetVal))
    --
    self._btnOk = self._parent:addChild({
        type = "Button",
        x = '0.9',
        y = '0.5',
        w = 25,
        h = 25,
    })
    self._btnOk:setIcon("media/confirm.png")
    self._btnOk.onClick = function()
        yesFunc(self._input:getText())
    end
    --
    self._btnNo = self._parent:addChild({
        type = "Button",
        x = '0.1',
        y = '0.5',
        w = 25,
        h = 25,
    })
    self._btnNo:setIcon("media/cancel.png")
    self._btnNo.onClick = function()
        noFunc(self._input:getText())
    end
    self._input:setFocus(true)
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
    self._input:removeSelf()
    self._btnOk:removeSelf()
    self._btnNo:removeSelf()
end

function Field:onKey(key)
    if key == 'escape' then
        self._btnNo.onClick()
    elseif key == 'return' then
        self._btnOk.onClick()
    end
end

return Field
