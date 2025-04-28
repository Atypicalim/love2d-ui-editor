--[[
	Template
]]

Template = class("Template", Node)

function Template:_onInit()
	Node._onInit(self)
	self:_addTemplate(self._conf.path, true)
end
