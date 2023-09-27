--[[
	check
]]

Check = class("Check", Node)

function Check:_onInit()
	Node._onInit(self)
	self._layer = self:newLayer({w = "50", h = '50',})
	self._imgOff = self:newImage({})
	self._imgOn = self:newImage({})
	self._layer.onClick = function()
		self._conf.checked = not self._isChecked
		self:_setDirty()
	end
	self:_updateState()
	self:_updateInner()
end

function Check:_parseConf()
	Node._parseConf(self)
	self._isDisabled = self._conf.disable == true
	self._isChecked = self._conf.checked == true
	self._lyrColor = self._conf.color
	self._pathOff = self._conf.img_off
	self._pathOn = self._conf.img_on
	return self
end

function Check:_onUpdate(isChange)
	if isChange then
		self:_updateState()
		self:_updateInner()
	end
end

function Check:isDisabled()
	return self._isDisabled
end

function Check:setDisable(isDisable)
	self._conf.disable = isDisable == true
	self:_setDirty()
	return self
end

function Check:setEnable(isEnable)
	self._conf.disable = isEnable ~= true
	self:_setDirty()
	return self
end

function Check:setColor(color)
	self._conf.color = color
	self:_setDirty()
	return self
end

function Check:setImageOff(path)
	self._conf.img_off = path
	self:_setDirty()
	self:_updateInner()
	return self
end

function Check:setImageOn(path)
	self._conf.img_on = path
	self:_setDirty()
	self:_updateInner()
	return self
end

function Check:setChecked(isChecked)
	self._conf.checked = true
	self:_setDirty()
	self:_updateState()
	return self
end

function Check:isChecked()
	return self._isChecked
end

function Check:_updateInner()
	self._layer:setColor(self._lyrColor)
	self._imgOn:setPath(self._pathOn)
	self._imgOff:setPath(self._pathOff)
	return self
end

function Check:_updateState()
	self._imgOff:setVisible(not self._isChecked)
	self._imgOn:setVisible(self._isChecked)
	return self
end
