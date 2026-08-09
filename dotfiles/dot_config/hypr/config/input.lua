hl.config({
	input = {
		kb_layout = "dk",
		kb_variant = "nodeadkeys",
		kb_model = "",
		kb_options = "lv3:ctrl_alt_switch",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0.3,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.15,
		},
		repeat_delay = 200,
	},
})

hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })
hl.device({ name = "sigmachip-usb-mouse", sensitivity = -0.3 })
