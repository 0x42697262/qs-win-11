-- Generated from src/domain/catalog/ipcCatalog.mjs. Copy what you need; the shell never binds keys itself.
-- Entries match the keymap table shape { action, bind, chord, opts }.

return {
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
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call quickLink toggle"),
		bind = "SUPER + X",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call quickSettings toggle"),
		bind = "SUPER + A",
	},
	{
		action = hl.dsp.exec_cmd("qs -c qs-win-11 ipc call session lock"),
		bind = "SUPER + L",
	},
}
