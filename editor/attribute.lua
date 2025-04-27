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
            self:_updateAttribute()
            g_editor:setKey(nil)
        end
    end
    --
    self._btnDown = parent:getById("btnDown"):show()
    self._btnDown.onClick = function()
        if self._attributesCount >= ATTRIBUTE_ITEM_COUNT then
            self._attributeIndent = self._attributeIndent + 1
            self:_updateAttribute()
            g_editor:setKey(nil)
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
        g_editor:setConf(g_editor._conf, false)
    end
    --
    self._nodeCtrl  = parent:getById('templateCtrl')
    self._textCtrl = self._nodeCtrl:getById('text'):setText("Ctrl")
    self._btnEditCtrl = self._nodeCtrl:getById('btnEdit'):setIcon("media/plus.png")
    self._borderCtrl = self._nodeCtrl:getById('line')
    self._btnEditCtrl.onClick = function()
        g_editor:setConf(g_editor._conf, true)
    end
    --
    self._attributeIndent = 0
    self:_updateAttribute()
end

function Attribute:refreshAttribute(conf, key)
    if g_editor:isSelect() then
        -- controll
    else
        -- property
        for i,v in ipairs(self._attributes) do
            if key and v:canHandle(key) then
                v:updateProperty()
            end
        end
    end
    self:updateStatus()
end

function Attribute:updateStatus()
    for i,v in ipairs(self._attributes or {}) do
        v:updateStatus()
    end
    self._textAttribute:setText(g_editor:isSelect() and "Controls" or "Properties")
    self._borderCtrl:setVisible(g_editor:isSelect())
    self._borderProp:setVisible(not g_editor:isSelect() and g_editor._conf ~= nil)
end

function Attribute:_updateAttribute()
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
    if g_editor:isSelect() then
        self:createControl(CONTROL_CONF_MAP)
    else
        self:createProperty(g_editor._conf)
    end
    self:updateStatus()
end

function Attribute:createProperty(conf)
    local config = Config(conf)
    for i,key in ipairs(PROPERTY_NAME_ORDER) do
        if self._attributesCount >= ATTRIBUTE_ITEM_COUNT then break end
        local info = PROPERTY_NAME_INFO[key] or {}
        if not info.ignoreProperty then
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
