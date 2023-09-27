--[[
	Video
]]

Video = class("Video", Node)

function Video:_onInit()
	Node._onInit(self)
end

function Video:_parseConf()
	Node._parseConf(self)
	if string.valid(self._conf.path) then
		self._video = love.graphics.newVideo(self._conf.path)
		self._w = self._video:getWidth()
		self._h = self._video:getHeight()
	else
		self._video = nil
		self._w = nil
		self._h = nil
	end
	lua_set_delegate(self, function(key)
		if self._video then
			return self._video[key](self._video)
		end
	end)
	return self
end

function Video:setPath(path)
	self._conf.path = path
	self:_setDirty()
	return self
end

function Video:getPath()
	return self._conf.path
end

function Video:_doDraw()
	Node._doDraw(self)
	if not self._isHide and self._video then
		-- love.graphics.setColor(0.1, 0.1, 0.1, 0.3)
		-- love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
		love.graphics.draw(self._video, self:getLeft(), self:getTop())
	end
end
