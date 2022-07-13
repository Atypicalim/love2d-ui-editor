--[[
	Auxiliary
]]

Auxiliary = class("Auxiliary")

function Auxiliary:__init__()
end

function Auxiliary:onUpdate(node, dt)
end

function Auxiliary:omDraw(node)
    love.graphics.setColor(1, 0, 0, 0.75)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", node:getLeft(), node:getTop(), node:getW(), node:getH())
end

return Auxiliary
