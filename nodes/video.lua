--[[
	Video
]]

Video = class("Video", Node)

function Video:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setPath(self._conf.path)
end

function Video:setPath(path)
	self._path = path
	if string.valid(path) then
		self._video = love.graphics.newVideo(path)
		Node.setXYWH(self, nil, nil, self._video:getWidth(), self._video:getHeight())
	else
		self._video = nil
	end
	self:_setLove(self._video)
end

function Video:getPath()
	return self._path
end

function Video:draw()
	if not self._isHide and self._video then
		love.graphics.draw(self._video, self:getLeft(), self:getTop())
	end
	Node.draw(self)
end
