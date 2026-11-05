/** @typedef {{ id: string, template: string, output: string, apply: string }} AppThemeTarget */

export const TEMPLATE_DIRECTORY = "assets/app-themes";
export const TEMPLATE_EXTENSION = ".tmpl";

/** @type {readonly AppThemeTarget[]} */
export const APP_THEME_TARGETS = Object.freeze([
    { id: "gtk", template: "gtk.css", output: "gtk/colors.css", apply: "Add @import url(\"file://<themes>/gtk/colors.css\"); to ~/.config/gtk-3.0/gtk.css and ~/.config/gtk-4.0/gtk.css." },
    { id: "qt", template: "qt.conf", output: "qt/qs-win-11.conf", apply: "Copy or link into ~/.config/qt6ct/colors/ (and qt5ct), then pick the scheme in qt6ct." },
    { id: "foot", template: "foot.ini", output: "foot/colors.ini", apply: "Add include=<themes>/foot/colors.ini under [main] in foot.ini." },
    { id: "kitty", template: "kitty.conf", output: "kitty/colors.conf", apply: "Add include <themes>/kitty/colors.conf to kitty.conf; kitty reloads it on SIGUSR1." },
    { id: "alacritty", template: "alacritty.toml", output: "alacritty/colors.toml", apply: "Add the path to general.import in alacritty.toml; alacritty reloads it live." },
    { id: "btop", template: "btop.theme", output: "btop/qs-win-11.theme", apply: "Link into ~/.config/btop/themes/ and set color_theme = \"qs-win-11\"." },
    { id: "fish", template: "fish.fish", output: "fish/colors.fish", apply: "Add source <themes>/fish/colors.fish to config.fish." },
    { id: "starship", template: "starship.toml", output: "starship/palette.toml", apply: "Copy the [palettes.qs-win-11] table into starship.toml and set palette = \"qs-win-11\"." },
    { id: "nvim", template: "nvim.lua", output: "nvim/qs-win-11.lua", apply: "Run :luafile <themes>/nvim/qs-win-11.lua or dofile() it from init.lua." },
    { id: "zed", template: "zed.json", output: "zed/qs-win-11.json", apply: "Link into ~/.config/zed/themes/ and pick \"qs-win-11\" in the theme selector." },
    { id: "vscode", template: "vscode.json", output: "vscode/settings-colors.json", apply: "Merge the object into workbench.colorCustomizations in your VS Code settings.json." },
    { id: "fuzzel", template: "fuzzel.ini", output: "fuzzel/colors.ini", apply: "Add include=<themes>/fuzzel/colors.ini to fuzzel.ini." },
]);
