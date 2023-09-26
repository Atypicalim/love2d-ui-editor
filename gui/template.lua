--[[
	Template
]]

Template = class("Template", Node)

function Template:__init__(conf, parent)
	Node.__init__(self, conf, parent)
	self:_createTemplate(self._conf.path)
end
