--[[
	constants
]]

EDITOR_GITHUB_URL = "https://github.com/kompasim/love2d-ui-editor"
EDITOR_WIDTH = 1000
EDITOR_HEIGHT = 700
PREVIEW_WIDTH = 500
PREVIEW_HEIGHT = 500

MESSAGE_MAX_COUNT = 5
MESSAGE_MARGIN_RATE = 0.05

TREE_ITEM_COUNT = 10
TREE_LEAF_MARGIN = 5
TREE_LEAF_INDENT = 15

ATTRIBUTE_ITEM_COUNT = 10
ATTRIBUTE_ITEM_MARGIN = 5


PROPERTY_NAME_ORDER = {
	'type',
	'id',
	'x',
	'y',
	'w',
	'h',
	'text',
	'icon',
	'color',
	'open',
}

PROPERTY_NAME_INFO = {
	['open'] = {
		ignoreProperty = true,
	},
	['type'] = {
		ignoreEdit = true,
	}
}

BORDER_OFF_COLOR = "#000000"
BORDER_ON_COLOR = "#ffffff"

CONTROL_NAME_ORDER = {
	"Point",
	"Line",
}

CONTROL_CONF_COMMON = {
	id = "empty",
	x = "0.5",
	y = "0.5",
	y = "1",
	h = "1",
}
CONTROL_CONF_MAP = {
	['Point'] = {},
	['Line'] = {},
}
for name,conf in pairs(CONTROL_CONF_MAP) do
	for k,v in pairs(CONTROL_CONF_COMMON) do
		if conf[k] == nil then
			conf[k] = v
		end
	end
end
