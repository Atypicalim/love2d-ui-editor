--[[
	Clipper
]]

Clipper = class("Clipper", Node)

function Clipper:_onInit()
	Node._onInit(self)
end

function Clipper:_doDraw()
	Node._doDraw(self)
    love.graphics.setScissor(
        self:getLeft(),
        self:getTop(),
        self:getW(),
        self:getH()
    )
end

