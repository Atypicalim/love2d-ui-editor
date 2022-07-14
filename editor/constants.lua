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
	"ax",
	"ay",
	'open',
	"hide",
	'path',
	'icon',
	'text',
	'size',
	'color',
	'thickness',
	'points',
	'mode',
	'disable',
	'quad',
	'children',
	'count',
	'life_min',
	'life_max',
	'emission',
	'acceleration_x_min',
	'acceleration_x_max',
	'acceleration_y_min',
	'acceleration_y_min',
}

CONTROL_NAME_ORDER = {
	'Node',
	'Point',
	'Line',
    'Rectangle',
    'Ellipse',
    'Polygon',
    'Arc',
    'Text',
    'Input',
    'Button',
    'Image',
    'Video',
    'Particle',
    'Template',
    'Clipper',
}

PROPERTY_NAME_INFO = {
	['open'] = {
		ignoreProperty = true,
	},
	['children'] = {
		ignoreProperty = true,
	},
	['type'] = {
		ignoreEdit = true,
	},
}

BORDER_OFF_COLOR = "#000000ee"
BORDER_ON_COLOR = "#ffffffee"
