import { booleanSetting, integerSetting, numberSetting, textListSetting, textSetting } from "../settings/definitions.mjs";

export const SHELL_DATA_SCHEMA_VERSION = 1;
const SECTION = "shellData";

/**
 * @param {string} name
 * @param {string} description
 */
function text(name, description) {
    return { key: name, section: SECTION, label: name, description };
}

export const ShellDataKey = Object.freeze({
    StartPinnedApps: "startPinnedApps",
    StartPinnedCustomized: "startPinnedCustomized",
    TaskbarPinnedApps: "taskbarPinnedApps",
    TaskbarPinnedCustomized: "taskbarPinnedCustomized",
    DoNotDisturb: "doNotDisturb",
    RunHistory: "runHistory",
    GameMode: "gameMode",
    WallpaperAccent: "wallpaperAccent.color",
    WallpaperAccentSource: "wallpaperAccent.source",
    LocationLatitude: "location.latitude",
    LocationLongitude: "location.longitude",
    LocationPlaceName: "location.placeName",
    LocationFetchedAtMs: "location.fetchedAtMs",
});

export const SHELL_DATA_DEFINITIONS = Object.freeze([
    textListSetting(text(ShellDataKey.StartPinnedApps, "Desktop entry ids pinned to Start, in order."), []),
    booleanSetting(text(ShellDataKey.StartPinnedCustomized, "True once the user changed Start pins."), false),
    textListSetting(text(ShellDataKey.TaskbarPinnedApps, "Desktop entry ids pinned to the taskbar, in order."), []),
    booleanSetting(text(ShellDataKey.TaskbarPinnedCustomized, "True once the user changed taskbar pins."), false),
    textSetting(text(ShellDataKey.WallpaperAccent, "Accent picked from the wallpaper, empty when none."), ""),
    textSetting(text(ShellDataKey.WallpaperAccentSource, "Wallpaper the cached accent was picked from."), ""),
    booleanSetting(text(ShellDataKey.GameMode, "Game mode is on."), false),
    textListSetting(text(ShellDataKey.RunHistory, "Commands run from the Run dialog, newest first."), []),
    booleanSetting(text(ShellDataKey.DoNotDisturb, "Suppress notification banners."), false),
    numberSetting(text(ShellDataKey.LocationLatitude, "Cached automatic latitude."), 0, -90, 90),
    numberSetting(text(ShellDataKey.LocationLongitude, "Cached automatic longitude."), 0, -180, 180),
    textSetting(text(ShellDataKey.LocationPlaceName, "Cached automatic place name."), ""),
    integerSetting(text(ShellDataKey.LocationFetchedAtMs, "When the cached location was fetched, 0 when never."), 0, 0, Number.MAX_SAFE_INTEGER),
]);
