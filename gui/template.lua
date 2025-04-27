--[[
	Template
]]

Template = class("Template", Node)

function Template:_onInit()
	Node._onInit(self)
	self:addTemplate(self._conf.path)
end
