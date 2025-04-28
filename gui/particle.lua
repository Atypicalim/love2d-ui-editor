--[[
	Particle
]]

Particle = class("Particle", Node)

function Particle:_onInit()
	Node._onInit(self)
	lua_set_delegate(self, function(key, ...)
		if self._particle and self._particle[key] then
			return self._particle[key](self._particle, ...)
		end
	end)
end

function Particle:_parseConf()
	Node._parseConf(self)
	self._color = rgba2love(hex2rgba(self._conf.color))
	if string.valid(self._conf.path) then
		local img = love.graphics.newImage(self._conf.path)
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
end

function Particle:_doUpdate(dt)
	Node._doUpdate(self, dt)
	if self._particle then
		self._particle:update(dt)
	end
end

function Particle:_doDraw()
	Node._doDraw(self)
	if not self._isHide and self._particle then
		love.graphics.setColor(unpack(self._color))
		love.graphics.draw(self._particle, self:getX(), self:getY())
	end
end
