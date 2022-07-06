--[[
	Image
]]

Image = class("Image", Node)

function Image:__init__(conf, parent)
	self:setPath(conf.path)
	Node.__init__(self, conf, parent)
end

function Image:setXYWH(x, y , will , h)
	if self._image then
		w = self._image:getWidth()
		h = self._image:getHeight()
	end
	Node.setXYWH(self, x, y , w , h)
end

function Image:setPath(path)
	self._path = path
	if string.valid(path) then
		self._image = love.graphics.newImage(path)
	else
		self._image = nil
	end
end

function Image:getPath()
	return self._path
end

function Image:draw()
	if not self._isHide and self._image then
		love.graphics.draw(self._image, self:getLeft(), self:getTop())
	end
	Node.draw(self)
end
