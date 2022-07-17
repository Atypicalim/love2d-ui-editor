function love.conf(t)

    t.version = "11.3"
    t.console = false

    t.window.title = "App"
    t.window.icon = nil
    t.window.width = 800
    t.window.height = 600
    t.window.borderless = false
    t.window.resizable = true
    t.window.minwidth = 500
    t.window.minheight = 500
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.x = 500
    t.window.y = 100

    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true
    t.modules.window = true

end
