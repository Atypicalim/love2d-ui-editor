--[[
	Auxiliary
]]


local Block = class("AuxBlock")
function Block:__init__(dirX, dirY)
    self._unit = 10
    self._dirX = dirX
    self._dirY = dirY
end
function Block:setXY(posX, posY)
    self._posX = posX
    self._posY = posY
end
function Block:checkXY(posX, posY, x, y)
    self:setXY(posX, posY)
    return math.abs(posX - x) < self._unit and math.abs(posY - y) < self._unit
end
function Block:drawXY(posX, posY)
    self:setXY(posX, posY)
    local unit = self._unit
    local x = self._posX
    local y = self._posY
    -- x = x + self._dirX * unit
    -- y = y + self._dirY * unit
    love.graphics.rectangle("fill", x - unit, y - unit, unit * 2, unit * 2)
end


Auxiliary = class("Auxiliary")

function Auxiliary:__init__()
    local targetConf = g_editor:getTargetConf()
    local targetNode = g_editor.guiNode:getByConf(targetConf)
    assert(targetNode ~= nil)
    self._auxConf = targetConf
    self._auxNode = targetNode
    self._auxExtend = 5
    self._blockLT = Block(-1, -1)
    self._blockLB = Block(-1, 1)
    self._blockRT = Block(1, -1)
    self._blockRB = Block(1, 1)
end

function Auxiliary:isAuxing()
    return self._auxConf ~= nil and self._startConf ~= nil
end

function Auxiliary:_isAround(val, num)
    return math.abs(val - num) < self._auxExtend
end

function Auxiliary:tryAuxStart(x, y)
    assert(self._auxNode ~= nil, 'invalid aux state')
    --
    if not self._auxNode:isHover() then
        return false
    end 
    --
    self._startConf = self._auxNode:dumpConf(false)
    self._startAuxX = x
    self._startAuxY = y
    -- 
    self._startNodeX = self._auxNode:getX()
    self._startNodeY = self._auxNode:getY()
    self._startNodeW = self._auxNode:getW()
    self._startNodeH = self._auxNode:getH()
    -- 
    self._startNodeL = self._auxNode:getLeft()
    self._startNodeR = self._auxNode:getRight()
    self._startNodeT = self._auxNode:getTop()
    self._startNodeB = self._auxNode:getBottom()
    -- 
    self._operateLT = self._blockLT:checkXY(self._startNodeL, self._startNodeT, x, y)
    self._operateLB = self._blockLB:checkXY(self._startNodeL, self._startNodeB, x, y)
    self._operateRT = self._blockRT:checkXY(self._startNodeR, self._startNodeT, x, y)
    self._operateRB = self._blockRB:checkXY(self._startNodeR, self._startNodeB, x, y)
    -- 
    self._operateL = self:_isAround(self._startNodeL, x)
    self._operateR = self:_isAround(self._startNodeR, x)
    self._operateT = self:_isAround(self._startNodeT, y)
    self._operateB = self:_isAround(self._startNodeB, y)
    self._operateLR = self._operateL or self._operateR
    self._operateTB = self._operateT or self._operateB
    --
    self._operateBlock = self._operateLT or self._operateLB or self._operateRT or self._operateRB
    self._operateLine = not self._operateBlock and (self._operateLR or self._operateTB)
    self._operateW = self._operateBlock or self._operateLR
    self._operateH = self._operateBlock or self._operateTB
    --
    -- 
    self._operateResize = self._operateBlock or self._operateLine
    self._operateMove = not self._operateResize
    -- 
    return true
end

function Auxiliary:_countResize(endN, startN, isVertical)
    assert(self._auxNode ~= nil, 'invalid aux state')
    local center = isVertical and self._auxNode:getY() or self._auxNode:getX()
    local anchor = isVertical and self._auxNode:getAy() or self._auxNode:getAx()
    local startLeft = startN < center
    local startRight = startN > center
    local endLeft = endN < center
    local endRight = endN > center
    --
    local onLeft = startLeft and endLeft
    local onRight = startRight and endRight
    local isValid = onLeft or onRight
    if not isValid then
        return 0
    end
    --
    local indent = endN - startN
    local toLeft = indent < 0
    local toRight = indent > 0
    local isMove = toLeft or toRight
    if not isMove then
        return 0
    end
    --
    local isBigger = false
    local isSmaller = false
    if onLeft then
        isBigger = toLeft
        isSmaller = toRight
    elseif onRight then
        isBigger = toRight
        isSmaller = toLeft
    else
        return 0
    end
    --
    local slide = isBigger and math.abs(indent) or -math.abs(indent)
    local rate = math.abs((onLeft and 0 or 1) - anchor)
    local change = rate == 0 or slide / rate
    return change
end

function Auxiliary:onAuxMove(x, y)
    assert(self._auxNode ~= nil, 'invalid aux state')
    local xMove = x - self._startAuxX
    local yMove = y - self._startAuxY
    if self._operateMove then
        local xTarget = self._startNodeX + xMove
        local yTarget = self._startNodeY + yMove
        self._auxNode:setXYWHForNode(xTarget, yTarget, nil, nil)
    elseif self._operateResize then
        local wChange = self._operateW and self:_countResize(x, self._startAuxX, false) or 0
        local hChange = self._operateH and self:_countResize(y, self._startAuxY, true) or 0
        local wTarget = self._startNodeW + wChange
        local hTarget = self._startNodeH + hChange
        self._auxNode:setXYWHForNode(nil, nil, wTarget, hTarget)
    end
end

function Auxiliary:onAuxEnd(x, y)
    assert(self._startConf ~= nil, 'invalid aux state')
    local endConf = self._auxNode:dumpConf(false)
    local xMove = x - self._startAuxX
    local yMove = y - self._startAuxY
    -- 
    if self._operateMove then
        local xTarget = describe4indent(self._startConf.px or "0.5", xMove)
        local yTarget = describe4indent(self._startConf.py or "0.5", yMove)
        self._auxNode:setXYWHForConf(xTarget, yTarget, nil, nil)
    elseif self._operateResize then
        local wChange = self._operateW and self:_countResize(x, self._startAuxX, false) or 0
        local hChange = self._operateH and self:_countResize(y, self._startAuxY, true) or 0
        local wTarget = describe4indent(self._startConf.sw or "0.5", wChange)
        local hTarget = describe4indent(self._startConf.sh or "0.5", hChange)
        self._auxNode:setXYWHForConf(nil, nil, wTarget, hTarget)
    end
    g_editor:onEditEnd(g_editor:getTargetConf(), nil)
    self._startConf = nil
end

function Auxiliary:onAuxCancel()
    assert(self._startConf ~= nil, 'invalid aux state')
    self._auxNode:setXYWHForConf(nil, nil, nil, nil)
    self._startConf = nil
end

function Auxiliary:update(dt)
end

function Auxiliary:draw()
    if self._auxNode then
        local node = self._auxNode
        love.graphics.setColor(1, 0, 0, 0.75)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", node:getLeft(), node:getTop(), node:getW(), node:getH())
        love.graphics.setColor(1, 0, 0, 0.5)
        self._blockLT:drawXY(node:getLeft(), node:getTop())
        self._blockLB:drawXY(node:getLeft(), node:getBottom())
        self._blockRT:drawXY(node:getRight(), node:getTop())
        self._blockRB:drawXY(node:getRight(), node:getBottom())
    end
end

function Auxiliary:destroy()
    if self:isAuxing() then
        self:onAuxCancel()
    end
    self._auxConf = nil
    self._auxNode = nil
end

return Auxiliary
