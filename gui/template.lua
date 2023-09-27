--[[
	Template
]]

Template = class("Template", Node)

function Template:_onInit()
	Node._onInit(self)
	self:_createTemplate(self._conf.path)
end
