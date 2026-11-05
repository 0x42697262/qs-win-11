-- Generated from src/domain/catalog. Copy what you need; the shell never binds keys or edits your config.
-- Blur behind the shell's translucent surfaces (Hyprland 0.55+ Lua).

hl.layer_rule({ match = { namespace = "qs-win-11-taskbar" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ match = { namespace = "qs-win-11-flyout" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ match = { namespace = "qs-win-11-toast" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ match = { namespace = "qs-win-11-osd" }, blur = true, ignore_alpha = 0.3 })
