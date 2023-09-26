--[[
	Line
]]

Line = class("Line", Node)

function Line:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.color)
	self:setPoints(self._conf.points)
	self:setThickness(self._conf.thickness)
end

function Line:_consumeConf()
	Node._consumeConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	self._thickness = self._conf.thickness
	self._mode = self._conf.fill and 'fill' or 'line'
	self._points = {}
	local points = self._conf.points
	local count = math.floor(#points / 2)
	for i=1,count*2,2 do
		local x = points[i]
		local y = points[i+1]
		assert(is_number(x) and is_number(y), 'invalid points format')
		if x > 0 then
			x = self:getX() + self:getW() / 2 + x
		elseif x < 0 then
			x = self:getX() - self:getW() / 2 + x
		else
			x = self:getX()
		end
		if y > 0 then
			y = self:getY() + self:getH() / 2 + y
		elseif y < 0 then
			y = self:getY() - self:getH() / 2 + y
		else
			y = self:getY()
		end
		table.insert(self._points, x)
		table.insert(self._points, y)
	end
	return self
end

function Line:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Line:setThickness(thickness)
	self._conf.thickness = thickness
	self:_consumeConf()
	return self
end

function Line:setPoints(points)
	self._conf.points = points
	self:_consumeConf()
	return self
end

function Line:draw()
	Node.draw(self)
	if not self._isHide then
		love.graphics.setLineWidth(self._thickness)
		love.graphics.setColor(unpack(self._color))
		love.graphics.line(unpack(self._points))
	end
end
