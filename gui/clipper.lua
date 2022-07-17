--[[
	Clipper
]]

Clipper = class("Clipper", Node)

function Clipper:__init__(conf, parent)
	Node.__init__(self, conf, parent)
end

function Clipper:draw()
    love.graphics.setScissor(
        self:getLeft(),
        self:getTop(),
        self:getW(),
        self:getH()
    )
	Node.draw(self)
    love.graphics.setScissor()
end
