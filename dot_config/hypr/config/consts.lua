return {
	APPS = {
		TERMINAL = "kitty",
		BROWSER = "firefox",
		NETWORK = "NetworkManager",
		FILE_MANAGER = "dolphin",
		WALLPAPER = "awww-daemon",
		MENU_INIT = "walker --gapplication-service",
		MENU_OPEN = "nc -U /run/user/1000/walker/walker.sock",
		APPLETS = { "nm-applet --indicator", "blueman-applet" },
	},
	DIRS = {
		SCIPTS = ".config/hypr/scripts",
	},
	MAIN_MOD = "SUPER",
}
