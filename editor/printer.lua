--[[
    printer
]]

local Printer = class("Printer")

function Printer:__init__(editor)
    self._editor = editor
    self._text = Text(self._editor.eui, {
        type = "Text",
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        text = "printer ...",
    }, nil)
end

function Printer:print(parent, text)
    self._text._text = text
    self._text:setX(parent:getX())
    self._text:setY(parent:getY())
    self._text:draw()
end

return Printer
