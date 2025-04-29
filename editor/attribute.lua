--[[
    Attribute
]]

local Attribute = class("Attribute")

function Attribute:__init__(parent, setPropertyFunc)
    g_attribute = self
    self._parent = parent
    self._setPropertyFunc = setPropertyFunc
    self._background = parent:getById("bgAttribute"):show()
    --
    self._btnUp = parent:getById("btnUp"):show()
    self._btnUp.onClick = function()
        if self._attributeIndent > 0 then
            self._attributeIndent = self._attributeIndent - 1
            self:refreshAttr()
            g_editor:tryEndEdit(nil)
        end
    end
    --
    self._btnDown = parent:getById("btnDown"):show()
    self._btnDown.onClick = function()
        if self._attributesCount >= ATTRIBUTE_ITEM_COUNT then
            self._attributeIndent = self._attributeIndent + 1
            self:refreshAttr()
            g_editor:tryEndEdit(nil)
        end
    end
    --
    self._textAttribute = parent:getById("textAttribute")
    --
    self._nodeProp  = parent:getById('templateProp')
    self._textProp = self._nodeProp:getById('text'):setText("Prop")
    self._btnEditProp = self._nodeProp:getById('btnEdit')
    self._borderProp = self._nodeProp:getById('line')
    self._btnEditProp.onClick = function()
        g_editor:setTargetConf(g_editor:getTargetConf(), false)
    end
    --
    self._nodeCtrl  = parent:getById('templateCtrl')
    self._textCtrl = self._nodeCtrl:getById('text'):setText("Ctrl")
    self._btnEditCtrl = self._nodeCtrl:getById('btnEdit'):setIcon("media/plus.png")
    self._borderCtrl = self._nodeCtrl:getById('line')
    self._btnEditCtrl.onClick = function()
        g_editor:setTargetConf(g_editor:getTargetConf(), true)
    end
    --
    self._attributeIndent = 0
    self:refreshAttr()
end

function Attribute:refreshItem(conf, key)
    if g_editor:isSelectingConf() then
        -- controll
    elseif g_editor:isEditingConf() then
        -- property
        for i,v in ipairs(self._attributes) do
            if not key or v:canHandle(key) then
                v:updateProperty()
            end
        end
    else
        error('invalid editor state')
    end
    self:updateAttr()
end

function Attribute:updateAttr()
    for i,v in ipairs(self._attributes or {}) do
        v:updateStatus()
    end
    local selecting = g_editor:isSelectingConf()
    local editing = g_editor:isEditingConf()
    self._textAttribute:setText(selecting and "Controls" or "Properties")
    self._borderCtrl:setVisible(selecting)
    self._borderProp:setVisible(editing)
end

function Attribute:refreshAttr()
    for i,v in ipairs(self._attributes or {}) do
        v:destroy()
    end
    self._attributes = {}
    local bgW = self._background:getW()
    local bgH = self._background:getH()
    self._attributeW = bgW * 0.9
    self._attributeH = (bgH - ATTRIBUTE_ITEM_MARGIN * ATTRIBUTE_ITEM_COUNT * 2) / ATTRIBUTE_ITEM_COUNT
    self._skippedCount = 0
    self._attributesCount = 0
    if g_editor:isSelectingConf() then
        self:createControl(CONTROL_CONF_MAP)
    elseif g_editor:isEditingConf() then
        self:createProperty(g_editor:getTargetConf())
    end
    self:updateAttr()
end

function Attribute:createProperty(config)
    for i,key in ipairs(PROPERTY_EDIT_ORDER) do
        if self._attributesCount >= ATTRIBUTE_ITEM_COUNT then break end
        local info = PROPERTY_INFO_MAP[key] or {}
        if not info.ignoreEdit then
            local y = self._attributeH / 2 + ATTRIBUTE_ITEM_MARGIN + (self._attributeH + ATTRIBUTE_ITEM_MARGIN * 2) * (#self._attributes)
            Property(key, config, '0.5', y, self._attributeW, self._attributeH)
        end
    end
end

function Attribute:createControl(config)
    for i,name in ipairs(CONTROL_NAME_ORDER) do
        if self._attributesCount >= ATTRIBUTE_ITEM_COUNT then break end
        local conf = config[name]
        if conf ~= nil then
            local y = self._attributeH / 2 + ATTRIBUTE_ITEM_MARGIN + (self._attributeH + ATTRIBUTE_ITEM_MARGIN * 2) * (#self._attributes)
            Control(name, conf, '0.5', y, self._attributeW, self._attributeH)
        end
    end
end

function Attribute:wheelmoved(x, y)
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX < self._background:getLeft() or mouseX > self._background:getRight() then
        return
    elseif mouseY < self._background:getTop() or mouseY > self._background:getBottom() then
        return
    end
    if y > 0 then
        self._btnUp.onClick()
    end
    if y < 0 then
        self._btnDown.onClick()
    end
end

function Attribute:destroy()
    for i,v in ipairs(self._attributes or {}) do
        v:destroy()
    end
    self._background:hide()
    self._btnUp:hide()
    self._btnDown:hide()
end

return Attribute
