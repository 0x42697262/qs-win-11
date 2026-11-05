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
    PinnedApps: "pinnedApps",
    PinnedAppsCustomized: "pinnedAppsCustomized",
    DoNotDisturb: "doNotDisturb",
    LocationLatitude: "location.latitude",
    LocationLongitude: "location.longitude",
    LocationPlaceName: "location.placeName",
    LocationFetchedAtMs: "location.fetchedAtMs",
});

export const SHELL_DATA_DEFINITIONS = Object.freeze([
    textListSetting(text(ShellDataKey.PinnedApps, "Desktop entry ids pinned to Start and the taskbar, in order."), []),
    booleanSetting(text(ShellDataKey.PinnedAppsCustomized, "True once the user pinned or unpinned anything."), false),
    booleanSetting(text(ShellDataKey.DoNotDisturb, "Suppress notification banners."), false),
    numberSetting(text(ShellDataKey.LocationLatitude, "Cached automatic latitude."), 0, -90, 90),
    numberSetting(text(ShellDataKey.LocationLongitude, "Cached automatic longitude."), 0, -180, 180),
    textSetting(text(ShellDataKey.LocationPlaceName, "Cached automatic place name."), ""),
    integerSetting(text(ShellDataKey.LocationFetchedAtMs, "When the cached location was fetched, 0 when never."), 0, 0, Number.MAX_SAFE_INTEGER),
]);
