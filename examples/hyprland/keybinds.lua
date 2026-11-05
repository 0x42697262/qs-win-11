-- Generated from src/domain/catalog. Copy what you need; the shell never binds keys or edits your config.
-- Entries match the keymap table shape { action, bind, chord, opts }.

return {
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call settings open"),
		bind = "SUPER + I",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call start toggle"),
		bind = "SUPER + SUPER_L",
		opts = { release = true },
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call search toggle"),
		bind = "SUPER + S",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call run toggle"),
		bind = "SUPER + R",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call keyboard nextLayout"),
		bind = "SUPER + SPACE",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call keyboard lockKeys"),
		bind = "Caps_Lock",
		opts = { release = true },
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call quickLink toggle"),
		bind = "SUPER + X",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call quickSettings toggle"),
		bind = "SUPER + A",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call notifications toggle"),
		bind = "SUPER + N",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call audio volumeUp"),
		bind = "XF86AudioRaiseVolume",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call audio volumeDown"),
		bind = "XF86AudioLowerVolume",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call audio toggleMute"),
		bind = "XF86AudioMute",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call audio toggleMicrophoneMute"),
		bind = "XF86AudioMicMute",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call brightness up"),
		bind = "XF86MonBrightnessUp",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call brightness down"),
		bind = "XF86MonBrightnessDown",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call taskView toggle"),
		bind = "SUPER + Tab",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call altTab next"),
		bind = "ALT + Tab",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call altTab previous"),
		bind = "ALT + SHIFT + Tab",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call altTab commit"),
		bind = "ALT + ALT_L",
		opts = { release = true },
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call desktop toggle"),
		bind = "SUPER + D",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call widgets toggle"),
		bind = "SUPER + W",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call snip open"),
		bind = "SUPER + SHIFT + S",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call snip screen"),
		bind = "Print",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call snip record"),
		bind = "SUPER + ALT + R",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call colorPicker open"),
		bind = "SUPER + SHIFT + C",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call snap open"),
		bind = "SUPER + Z",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call session lock"),
		bind = "SUPER + L",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call session menu"),
		bind = "CTRL + ALT + Delete",
	},
}
