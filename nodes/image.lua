--[[
	Image
]]

Image = class("Image", Node)

function Image:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setPath(self._conf.path)
	self:setQuad(self._conf.quad)
end

function Image:setPath(path)
	self._path = path
	if string.valid(path) then
		self._image = love.graphics.newImage(path)
		Node.setXYWH(self, nil, nil, self._image:getWidth(), self._image:getHeight())
	else
		self._image = nil
	end
	self:_setLove(self._image)
end

function Image:getPath()
	return self._path
end

function Image:setQuad(quad)
	if quad and self._image then
		assert(is_table(quad))
		assert(#quad == 4)
		self._quad = love.graphics.newQuad(quad[1], quad[2], quad[3], quad[4], self._image:getDimensions())
	else
		self._quad = nil
	end
end

function Image:draw()
	if not self._isHide and self._image then
		if self._quad then
			love.graphics.draw(self._image, self._quad, self:getLeft(), self:getTop())
		else
			love.graphics.draw(self._image, self:getLeft(), self:getTop())
		end
	end
	Node.draw(self)
end
