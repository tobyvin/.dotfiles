local switch = function(dir)
	return function()
		swayimg.viewer.switch_image(dir)
	end
end

local mv = function(x, y)
	return function()
		local wnd = swayimg.get_window_size()
		local pos = swayimg.viewer.get_position()
		swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width * x), math.floor(pos.y + wnd.height * y))
	end
end

local zoom = function(dir)
	return function()
		local pos = swayimg.get_mouse_pos()
		local scale = swayimg.viewer.get_scale()
		swayimg.viewer.set_abs_scale(scale + (scale / 10) * dir, pos.x, pos.y)
	end
end

swayimg.text.set_foreground(0xffffffff)
swayimg.text.set_background(0xee000000)
swayimg.viewer.set_window_background(0x00000000)
swayimg.viewer.set_image_background(0x00000000)
swayimg.viewer.on_key("q", swayimg.exit)
swayimg.viewer.on_key("g", switch("first"))
swayimg.viewer.on_key("Shift+g", switch("last"))
swayimg.viewer.on_key("Right", switch("prev"))
swayimg.viewer.on_key("Ctrl+p", switch("prev"))
swayimg.viewer.on_key("Left", switch("next"))
swayimg.viewer.on_key("Ctrl+n", switch("next"))
swayimg.viewer.on_key("l", mv(-0.05, 0))
swayimg.viewer.on_key("h", mv(0.05, 0))
swayimg.viewer.on_key("j", mv(0, -0.05))
swayimg.viewer.on_key("k", mv(0, 0.05))
swayimg.viewer.on_key("Ctrl+l", swayimg.viewer.reset)
swayimg.viewer.on_mouse("ScrollUp", zoom(1))
swayimg.viewer.on_mouse("ScrollDown", zoom(-1))
