import {
    booleanSetting, colorSetting, enumSetting, integerSetting, numberSetting, textListSetting, textSetting,
} from "../settings/definitions.mjs";
import {
    CompositorKind, CriticalBatteryAction, FirstDayOfWeek, LocationMode, QuickTile, TaskbarAlignment, TemperatureUnit, ThemeMode,
} from "./enums.mjs";
import { FeatureName, ExperimentalFeatureName, FEATURE_DEFAULTS } from "./features.mjs";

export const SETTINGS_SCHEMA_VERSION = 1;
const CLOCK_TIME_PATTERN = /^([01]\d|2[0-3]):[0-5]\d$/;

export const SettingsSection = Object.freeze({
    Theme: "theme",
    Compositor: "compositor",
    Taskbar: "taskbar",
    StartMenu: "startMenu",
    QuickSettings: "quickSettings",
    Notifications: "notifications",
    Clock: "clock",
    Power: "power",
    Idle: "idle",
    Weather: "weather",
    Commands: "commands",
    Features: "features",
    Experimental: "experimental",
});

/**
 * @param {string} section
 * @param {string} name
 * @param {string} label
 * @param {string} description
 */
function text(section, name, label, description) {
    return { key: `${section}.${name}`, section, label, description };
}

const featureDefinitions = Object.values(FeatureName).map((feature) => booleanSetting(
    text(SettingsSection.Features, `${feature}.enabled`, `Enable ${feature}`, `Turns the ${feature} feature on or off. It still stays off when its requirements are missing.`),
    FEATURE_DEFAULTS[feature],
));

const experimentalDefinitions = Object.values(ExperimentalFeatureName).map((feature) => booleanSetting(
    text(SettingsSection.Experimental, feature, `Experimental: ${feature}`, "Unfinished feature. May misbehave. See docs/flags.md."),
    false,
));

export const SETTING_DEFINITIONS = Object.freeze([
    enumSetting(text(SettingsSection.Theme, "mode", "Theme", "Light, dark, or switch automatically at the times below."), ThemeMode, ThemeMode.Dark),
    textSetting(text(SettingsSection.Theme, "lightStartsAt", "Light theme starts at", "24-hour HH:MM, used when the theme is auto."), "07:00", CLOCK_TIME_PATTERN),
    textSetting(text(SettingsSection.Theme, "darkStartsAt", "Dark theme starts at", "24-hour HH:MM, used when the theme is auto."), "19:00", CLOCK_TIME_PATTERN),
    colorSetting(text(SettingsSection.Theme, "accentColor", "Accent color", "Color for highlights, toggles and the active app indicator, as #RRGGBB."), "#0078d4"),
    textSetting(text(SettingsSection.Theme, "fontFamily", "Font", "Any installed font family."), "Inter"),
    numberSetting(text(SettingsSection.Theme, "scale", "Scale", "Multiplies every size in the shell."), 1, 0.75, 2),
    booleanSetting(text(SettingsSection.Theme, "transparency", "Transparency effects", "Translucent taskbar and flyouts. Blur comes from your compositor."), true),
    booleanSetting(text(SettingsSection.Theme, "reduceMotion", "Reduce motion", "Makes animations nearly instant."), false),

    enumSetting(text(SettingsSection.Compositor, "kind", "Compositor integration", "Auto detects Hyprland; generic works on any wlr-foreign-toplevel compositor."), CompositorKind, CompositorKind.Auto),

    enumSetting(text(SettingsSection.Taskbar, "alignment", "Taskbar alignment", "Where the Start button and apps sit."), TaskbarAlignment, TaskbarAlignment.Center),
    booleanSetting(text(SettingsSection.Taskbar, "autoHide", "Automatically hide the taskbar", "Slides away until the pointer touches the bottom edge."), false),
    booleanSetting(text(SettingsSection.Taskbar, "showSearch", "Show Search", "Search button on the taskbar."), true),
    booleanSetting(text(SettingsSection.Taskbar, "showTaskView", "Show Task view", "Task view button on the taskbar."), true),
    booleanSetting(text(SettingsSection.Taskbar, "showWidgets", "Show Widgets", "Weather and widgets button on the taskbar."), true),
    textListSetting(text(SettingsSection.Taskbar, "initialPinned", "Initially pinned apps", "Desktop entry ids on the taskbar before you pin anything yourself."), ["org.gnome.Nautilus", "firefox", "kitty"]),
    booleanSetting(text(SettingsSection.Taskbar, "windowsOnAllMonitors", "Show apps on all taskbars", "Off shows each window only on its own monitor's taskbar."), false),

    booleanSetting(text(SettingsSection.StartMenu, "showRecommended", "Show recommended files", "Recently used files in Start."), true),
    textListSetting(text(SettingsSection.StartMenu, "initialPinned", "Initially pinned apps", "Desktop entry ids pinned before you pin anything yourself."), ["firefox", "org.gnome.Nautilus", "kitty", "org.gnome.TextEditor", "org.gnome.Calculator"]),

    textListSetting(text(SettingsSection.QuickSettings, "tiles", "Quick Settings tiles", "Tiles shown, in order. Unsupported tiles hide themselves."), Object.values(QuickTile), Object.values(QuickTile)),

    integerSetting(text(SettingsSection.Notifications, "toastSeconds", "Notification display time", "Seconds a notification banner stays up, unless the app asks otherwise."), 5, 1, 60),
    integerSetting(text(SettingsSection.Notifications, "historyLimit", "Notification history size", "Oldest notifications are dropped beyond this."), 50, 1, 500),

    booleanSetting(text(SettingsSection.Clock, "use24Hour", "24-hour clock", "Shows 13:00 instead of 1:00 PM."), false),
    booleanSetting(text(SettingsSection.Clock, "showSeconds", "Show seconds", "Seconds in the taskbar clock."), false),
    enumSetting(text(SettingsSection.Clock, "firstDayOfWeek", "First day of week", "First column in the calendar."), FirstDayOfWeek, FirstDayOfWeek.Sunday),

    integerSetting(text(SettingsSection.Power, "lowBatteryPercent", "Low battery level", "Warns at this battery percentage."), 15, 1, 50),
    integerSetting(text(SettingsSection.Power, "criticalBatteryPercent", "Critical battery level", "Takes the critical action at this percentage."), 5, 1, 25),
    enumSetting(text(SettingsSection.Power, "criticalAction", "Critical battery action", "What happens at the critical level."), CriticalBatteryAction, CriticalBatteryAction.Suspend),

    integerSetting(text(SettingsSection.Idle, "dimSeconds", "Dim screen after", "Seconds of inactivity. 0 turns it off."), 270, 0, 86400),
    integerSetting(text(SettingsSection.Idle, "lockSeconds", "Lock after", "Seconds of inactivity. 0 turns it off."), 300, 0, 86400),
    integerSetting(text(SettingsSection.Idle, "screenOffSeconds", "Turn screen off after", "Seconds of inactivity. 0 turns it off."), 330, 0, 86400),
    integerSetting(text(SettingsSection.Idle, "suspendSeconds", "Sleep after", "Seconds of inactivity. 0 turns it off."), 900, 0, 86400),

    enumSetting(text(SettingsSection.Weather, "unit", "Temperature unit", "Unit for weather."), TemperatureUnit, TemperatureUnit.Celsius),
    enumSetting(text(SettingsSection.Weather, "locationMode", "Location", "Auto tries GeoClue, then an IP lookup if allowed."), LocationMode, LocationMode.Auto),
    booleanSetting(text(SettingsSection.Weather, "allowIpLookup", "Allow IP location lookup", "Sends your IP address to ipwho.is when GeoClue is unavailable."), true),
    numberSetting(text(SettingsSection.Weather, "manualLatitude", "Manual latitude", "Used when location is manual."), 0, -90, 90),
    numberSetting(text(SettingsSection.Weather, "manualLongitude", "Manual longitude", "Used when location is manual."), 0, -180, 180),
    textSetting(text(SettingsSection.Weather, "manualPlaceName", "Manual place name", "Shown on the weather widget when location is manual."), ""),

    textSetting(text(SettingsSection.Commands, "terminal", "Terminal", "Command that opens a terminal."), "kitty"),
    textSetting(text(SettingsSection.Commands, "fileManager", "File manager", "Command that opens the file manager."), "nautilus"),
    textSetting(text(SettingsSection.Commands, "taskManager", "Task manager", "Command that opens a task manager."), "gnome-system-monitor"),
    textSetting(text(SettingsSection.Commands, "lock", "Lock command", "Used when the built-in lock screen is off."), "loginctl lock-session"),
    textSetting(text(SettingsSection.Commands, "signOut", "Sign out command", "Empty uses the compositor's own exit."), ""),
    textSetting(text(SettingsSection.Commands, "nightLight", "Night light command", "Runs while night light is on and is stopped when it turns off."), "hyprsunset -t 4000"),
    textSetting(text(SettingsSection.Commands, "brightness", "Brightness command", "{percent} is replaced with 0-100."), "brightnessctl set {percent}%"),
    textSetting(text(SettingsSection.Commands, "soundSettings", "Sound settings", "Opened from the volume slider. Empty hides the link."), "pavucontrol"),
    textSetting(text(SettingsSection.Commands, "networkSettings", "Network settings", "Opened from the Wi-Fi page. Empty hides the link."), "nm-connection-editor"),
    textSetting(text(SettingsSection.Commands, "bluetoothSettings", "Bluetooth settings", "Opened from the Bluetooth page. Empty hides the link."), "blueman-manager"),
    textSetting(text(SettingsSection.Commands, "displaySettings", "Display settings", "Opened from the desktop menu. Empty hides the link."), ""),

    ...featureDefinitions,
    ...experimentalDefinitions,
]);
