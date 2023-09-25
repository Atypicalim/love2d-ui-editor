--[[
	check
]]

Check = class("Check", Node)

function Check:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self._layer = self:_parseConfig({
		type = "Layer",
		id = "checkLayer",
		x = '0.5',
		y = '0.5',
		w = "h*0.7",
		h = 'h*0.7',
		bg = "#777777aa",
	})
	self._imgOff = self:_parseConfig({
        type = "Image",
        id = "checkImg1",
        x = "0.5",
        y = "0.5",
        w = "0.9",
        h = "0.9",
        path = self._conf.img_off,
    })
	self._imgOn = self:_parseConfig({
        type = "Image",
        id = "checkImg2",
        x = "0.5",
        y = "0.5",
        w = "0.9",
        h = "0.9",
        path = self._conf.img_on,
    })
	self._layer:setColor(self._conf.bg)
	self._layer.onClick = function()
		self._isChecked = not self._isChecked
		self:_updateStatus()
	end
	self:_updateStatus()
end

function Check:_checkConf()
	Node._checkConf(self)
	self._isDisabled = self._conf.disable == true
	self._isChecked = self._conf.checked == true
end

function Check:isDisabled()
	return self._isDisabled
end

function Check:setDisable(isDisable)
	self._isDisabled = isDisable == true
	return self
end

function Check:setColor(color)
	self._layer:setColor(color)
end

function Check:getColor()
	return self._layer:getColor()
end

function Check:setImageOff(path)
	self._imgOff:setPath(path)
end

function Check:getImageOff()
	return self._imgOff:getPath()
end

function Check:setImageOn(path)
	self._imgOn:setPath(path)
end

function Check:getImageOn()
	return self._imgOn:getPath()
end

function Check:setChecked(isChecked)
	self._isChecked = isChecked
	self:_updateStatus()
end

function Check:isChecked()
	return self._isChecked
end

function Check:_updateStatus()
	self._imgOff:setVisible(not self._isChecked)
	self._imgOn:setVisible(self._isChecked)
end
