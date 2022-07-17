--[[
	constants
]]

LOVE_PROXY_FUNCTIONS = {
    update = true,
    draw = true,
    mousepressed = true,
    mousemoved = true,
    mousereleased = true,
    keypressed = true,
    keyreleased = true,
    textinput = true,
    resize = true,
    wheelmoved = true,
}

NODE_EVENTS = {
    ON_MOUSE_MOVE = "onMouseMove",
    ON_MOUSE_IN = "onMouseIn",
    ON_MOUSE_OUT = "onMouseOut",
    ON_MOUSE_UP = "onMouseUp",
    ON_MOUSE_DOWN = "onMouseDown",
    ON_CLICK = "onClick",
    ON_CANCEL = "onCancel",
    ON_WHEEL_MOVE = "onWheelMove",
}

CONTROL_CONF_COMMON = {
    type = nil,
	id = "empty",
    bg = "101010cc",
	x = "0.5",
	y = "0.5",
	w = "0.75",
	h = "0.75",
    ax = "0.5",
    ay = "0.5",
    open = true,
    hide = false,
    children = {},
}
CONTROL_CONF_MAP = {
    ['Node'] = {},
	['Point'] = {
        color = "#101010ff",
        thickness = 5,
        points = {0, 0},
    },
	['Line'] = {
        color = "#101010ff",
        thickness = 5,
        points = {0, 0, 50, 50},
    },
    ['Rectangle'] = {
        mode = "line",
        thickness = 2,

    },
    ['Ellipse'] = {
        color = "#101010ff",
        mode = "line",
        thickness = 2,
    },
    ['Polygon'] = {
        mode = "line",
        thickness = 2,
        points = {0, 0, 50, 50, -50, 50},
    },
    ['Arc'] = {
        mode = "line",
        thickness = 2,
        points = {0, 0, 50, 50, -50, 50},
    },
    ['Text'] = {
        color = "#101010ff",
        size = 12,
        text = "text...",
    },
    ['Input'] = {
        color = "#101010ff",
        size = 12,
        text = "text...",
    },
    ['Button'] = {
        text = "text...",
        icon = "",
        disable = false,
    },
    ['Image'] = {
        path ="",
        quad = {0, 0, 100, 100},
    },
    ['Video'] = {
        path = "",
    },
    ['Particle'] = {
        color = "#ffffffff",
        path = "",
        count = 50,
        life_min = 2,
        life_max = 5,
        emission = 5,
        size = 1,
        acceleration_x_min = -20,
        acceleration_x_max = -20,
        acceleration_y_min = 20,
        acceleration_y_min = 20,
    },
    ['Template'] = {
        path = "",
    },
    ['Clipper'] = {},
}
for name,conf in pairs(CONTROL_CONF_MAP) do
	for k,v in pairs(CONTROL_CONF_COMMON) do
		if conf[k] == nil then
			conf[k] = v
		end
	end
    conf.type = name
end
