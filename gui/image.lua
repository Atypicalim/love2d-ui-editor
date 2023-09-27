--[[
	Image
]]

Image = class("Image", Node)

function Image:_onInit()
	Node._onInit(self)
end

function Image:_parseConf()
	Node._parseConf(self)
	-- 
	if string.valid(self._conf.path) then
		self._image = love.graphics.newImage(self._conf.path)
		self._w = self._image:getWidth()
		self._h = self._image:getHeight()
	else
		self._image = nil
		self._w = 0
		self._h = 0
	end
	--
	local quad = self._conf.quad
	if self._image and not table.is_empty(quad) then
		assert(#quad == 4, 'invalid quad for image!')
		self._quad = love.graphics.newQuad(quad[1], quad[2], quad[3], quad[4], self._image:getDimensions())
	else
		self._quad = nil
	end
	--
	lua_set_delegate(self, function(key)
		if self._image then
			return self._image[key](self._video)
		end
	end)
	--
	return self
end

function Image:setPath(path)
	self._conf.path = path
	self:_setDirty()
end

function Image:getPath()
	return self._conf.path
end

function Image:setQuad(quad)
	self._conf.quad = quad
	self:_setDirty()
end

function Image:_doDraw()
	Node._doDraw(self)
	if not self._isHide and self._image then
		if self._quad then
			love.graphics.draw(self._image, self._quad, self:getLeft(), self:getTop())
		else
			love.graphics.draw(self._image, self:getLeft(), self:getTop())
		end
	end
end
