--[[
	Particle
]]

Particle = class("Particle", Node)

function Particle:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:setPath(conf.path)
	self:setColor(self._conf.color or "#ffffff")
end

function Particle:setColor(color)
	self._color = rgba2love(hex2rgba(color))
end

function Particle:setPath(path)
	self._path = path
	if string.valid(path) and files.is_file(path) then
		local img = love.graphics.newImage(self._path)
		self._particle = love.graphics.newParticleSystem(img, self._conf.count or 32)
		self._particle:setParticleLifetime(self._conf.life_min or 2, self._conf.life_max or 5) -- Particles live at least 2s and at most 5s.
		self._particle:setEmissionRate(self._conf.emission or 5)
		self._particle:setSizeVariation(self._conf.size or 1)
		self._particle:setLinearAcceleration(
			self._conf.acceleration_x_min or -20,
			self._conf.acceleration_x_max or -20,
			self._conf.acceleration_y_min or 20,
			self._conf.acceleration_y_min or 20
		) -- Random movement in all directions.
	else
		self._particle = nil
	end
	self:_setLove(self._particle)
end

function Particle:getPath()
	return self._path
end

function Particle:update(dt)
	if self._particle then
		self._particle:update(dt)
	end
end

function Particle:draw()
	if not self._isHide and self._particle then
		love.graphics.setColor(unpack(self._color))
		love.graphics.draw(self._particle, self:getX(), self:getY())
	end
	Node.draw(self)
end
