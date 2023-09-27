--[[
	Clipper
]]

Clipper = class("Clipper", Node)

function Clipper:_onInit()
	Node._onInit(self)
end

function Clipper:_doDraw()
    love.graphics.setScissor(
        self:getLeft(),
        self:getTop(),
        self:getW(),
        self:getH()
    )
	Node._doDraw(self)
end

function Clipper:_onDraw()
	Node._onDraw(self)
    love.graphics.setScissor()
end

