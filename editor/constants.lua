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

TREE_ITEM_HEIGHT = 50
TREE_LEAF_MARGIN = 5
TREE_LEAF_INDENT = 15

ATTRIBUTE_ITEM_COUNT = 10
ATTRIBUTE_ITEM_MARGIN = 5

------------------------------------------

PROPERTY_BASE_KEY = {
	"type",
	"id",
}

PROPERTY_MULTIPLE_KEY = {
	"position_x_y",
	"size_w_h",
	"anchor_x_y",
}

PROPERTY_SINGLE_KEY = {
	"bg",
	"open",
	"hide",
	"path",
	"icon",
	"text",
	"size",
	"color",
	"thickness",
	"points",
	"mode",
	"disable",
	"quad",
	"count",
	"life_min",
	"life_max",
	"emission",
	"acceleration_x_min",
	"acceleration_x_max",
	"acceleration_y_min",
	"acceleration_y_min",
	"children",
}

PROPERTY_DUMP_ORDER = {}
PROPERTY_EDIT_ORDER = {}

PROPERTY_INFO_MAP = {
	type = {
		ignoreEdit = true,
	},
	id = {
		mustDump = false,
	},
	position_x_y = {
		mustDump = true,
		multiKey = true,
	},
	size_w_h = {
		mustDump = true,
		multiKey = true,
	},
	anchor_x_y = {
		mustDump = false,
		multiKey = true,
	},
	open = {
		ignoreEdit = true,
	},
	children = {
		ignoreEdit = true,
		mustDump = false,
	},
}

local function _setPropertyInfo(key, _key)
	PROPERTY_INFO_MAP[key] = PROPERTY_INFO_MAP[key] or {}
	PROPERTY_INFO_MAP[_key] = PROPERTY_INFO_MAP[_key] or PROPERTY_INFO_MAP[key]
end

for _,k in ipairs(PROPERTY_BASE_KEY) do
	table.insert(PROPERTY_DUMP_ORDER, k)
	table.insert(PROPERTY_EDIT_ORDER, k)
	_setPropertyInfo(k, k)
end
for _,k in ipairs(PROPERTY_MULTIPLE_KEY) do
	--
	local m, _, k1, k2 = parser_key(k)
	assert(m, 'invalid multiple key')
	table.insert(PROPERTY_DUMP_ORDER, k1)
	table.insert(PROPERTY_DUMP_ORDER, k2)
	_setPropertyInfo(k, k1)
	_setPropertyInfo(k, k2)
	--
	table.insert(PROPERTY_EDIT_ORDER, k)
	_setPropertyInfo(k, k)
end
for _,k in ipairs(PROPERTY_SINGLE_KEY) do
	table.insert(PROPERTY_DUMP_ORDER, k)
	table.insert(PROPERTY_EDIT_ORDER, k)
	_setPropertyInfo(k, k)
end

------------------------------------------

CONTROL_NAME_ORDER = {
	'Node',
	'Point',
	'Line',
    'Rectangle',
    'Ellipse',
    'Polygon',
    'Arc',
    'Text',
    'Image',
    'Video',
    'Input',
	'Layer',
	'Check',
    'Button',
    'Particle',
    'Template',
    'Clipper',
}

BORDER_OFF_COLOR = "#000000ee"
BORDER_ON_COLOR = "#aaaaaa55"
