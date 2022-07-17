--[[
	Point
]]

Point = class("Point", Node)

function Point:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setColor(self._conf.color)
	self:setPoints(self._conf.points)
	self:setThickness(self._conf.thickness)
end

function Point:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Point:setThickness(thickness)
	self._thickness = thickness or 2
end

function Point:setPoints(points)
	assert(is_table(points), 'invalid points value')
	self._points = {}
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
end

function Point:draw()
	if not self._isHide then
		love.graphics.setPointSize(self._thickness)
		love.graphics.setColor(unpack(self._color))
		love.graphics.points(unpack(self._points))
	end
	Node.draw(self)
end
