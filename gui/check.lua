--[[
	check
]]

Check = class("Check", Node)

function Check:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self._layer = self:_parseConfig({
		type = "Layer",
		w = "100",
		h = '100',
	})
	self._imgOff = self:_parseConfig({
        type = "Image",
    })
	self._imgOn = self:_parseConfig({
        type = "Image",
    })
	self._layer.onClick = function()
		self._conf.checked = not self._isChecked
		self:_consumeConf()
		self:_updateState()
	end
	self:_updateState()
	self:_updateInner()
end

function Check:_consumeConf()
	Node._consumeConf(self)
	self._isDisabled = self._conf.disable == true
	self._isChecked = self._conf.checked == true
	self._lyrColor = self._conf.color
	self._imgOff = self._conf.img_off
	self._imgOn = self._conf.img_on
	return self
end

function Check:isDisabled()
	return self._isDisabled
end

function Check:setDisable(isDisable)
	self._conf.disable = isDisable == true
	self:_consumeConf()
	return self
end

function Check:setEnable(isEnable)
	self._conf.disable = isEnable ~= true
	self:_consumeConf()
	return self
end

function Check:setColor(color)
	self._conf.color = color
	self:_consumeConf()
	return self
end

function Check:setImageOff(path)
	self._conf.img_off = path
	self:_consumeConf()
	self:_updateInner()
	return self
end

function Check:setImageOn(path)
	self._conf.img_on = path
	self:_consumeConf()
	self:_updateInner()
	return self
end

function Check:setChecked(isChecked)
	self._conf.checked = true
	self:_consumeConf()
	self:_updateState()
	return self
end

function Check:isChecked()
	return self._isChecked
end

function Check:_updateInner()
	self._layer:setColor(self._lyrColor)
	self._imgOn:setPath(self._imgOn)
	self._imgOff:setPath(self._imgOff)
	return self
end

function Check:_updateState()
	self._imgOff:setVisible(not self._isChecked)
	self._imgOn:setVisible(self._isChecked)
	return self
end
