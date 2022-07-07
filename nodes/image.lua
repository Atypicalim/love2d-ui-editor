--[[
	Image
]]

Image = class("Image", Node)

function Image:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setPath(self._conf.path)
end

function Image:setPath(path)
	self._path = path
	if string.valid(path) then
		self._image = love.graphics.newImage(path)
		Node.setXYWH(self, nil, nil, self._image:getWidth(), self._image:getHeight())
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
