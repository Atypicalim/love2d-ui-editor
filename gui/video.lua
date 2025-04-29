--[[
	Video
]]

Video = class("Video", Node)

function Video:_onInit()
	Node._onInit(self)
	-- lua_set_delegate(self, function(key, ...)
	-- 	if self._video and self._video[key] then
	-- 		return self._video[key](self._video, ...)
	-- 	end
	-- end)
end

function Video:_parseConf()
	Node._parseConf(self)
	if string.valid(self._conf.path) then
		self._video = love.graphics.newVideo(self._conf.path)
		self._w = self._video:getWidth()
		self._h = self._video:getHeight()
	else
		self._video = nil
		self._w = 0
		self._h = 0
	end
	self:adjustNode(self._video)
	return self
end

function Video:_doDraw()
	Node._doDraw(self)
	if not self._isHide and self._video then
		-- love.graphics.setColor(0.1, 0.1, 0.1, 0.3)
		-- love.graphics.rectangle("fill", self:getLeft(), self:getTop(), self:getW(), self:getH())
		love.graphics.draw(self._video, self:getLeft(), self:getTop())
	end
end
