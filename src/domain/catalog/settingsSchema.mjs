import {
    booleanSetting, colorSetting, enumSetting, integerSetting, numberSetting, textListSetting, textSetting,
} from "../settings/definitions.mjs";
import {
    AllAppsView, CompositorKind, PerformanceMetric, ScreenCorner, CriticalBatteryAction, FirstDayOfWeek, InputIndicatorMode, LocationMode, QuickTile, TaskbarAlignment, TemperatureUnit, ThemeMode, WallpaperFill, WallpaperMode,
} from "./enums.mjs";
import { APP_THEME_TARGETS } from "./appThemes.mjs";
import { FeatureName, ExperimentalFeatureName, FEATURE_DEFAULTS } from "./features.mjs";
import { CornerModel } from "../shape/corners.mjs";
import { VALUE_DEFINITIONS } from "../settings/valueDefinitions.mjs";
import { APPEARANCE_DEFINITIONS } from "../settings/appearanceDefinitions.mjs";

export const SETTINGS_SCHEMA_VERSION = 1;
const CLOCK_TIME_PATTERN = /^([01]\d|2[0-3]):[0-5]\d$/;

export const SettingsSection = Object.freeze({
    Theme: "theme",
    Compositor: "compositor",
    Corners: "corners",
    Backdrop: "backdrop",
    Wallpaper: "wallpaper",
    LockScreen: "lockScreen",
    AppTheming: "appTheming",
    Profiles: "profiles",
    AppIcons: "appIcons",
    Taskbar: "taskbar",
    StartMenu: "startMenu",
    QuickSettings: "quickSettings",
    Notifications: "notifications",
    Clock: "clock",
    Power: "power",
    Idle: "idle",
    Weather: "weather",
    Widgets: "widgets",
    DesktopClock: "desktopClock",
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
    booleanSetting(text(SettingsSection.Theme, "accentFromWallpaper", "Accent from wallpaper", "Pick the accent color from the wallpaper's most vivid color. Needs ImageMagick."), false),
    textSetting(text(SettingsSection.Theme, "fontFamily", "Font", "Any installed font family."), "Inter"),
    numberSetting(text(SettingsSection.Theme, "scale", "Scale", "Multiplies every size in the shell."), 1, 0.75, 2),
    numberSetting(text(SettingsSection.Theme, "fontScale", "Text size", "Multiplies text sizes only, on top of scale."), 1, 0.75, 2),
    numberSetting(text(SettingsSection.Theme, "textContrast", "Text contrast", "Negative softens secondary text for calmer reading, positive makes all text stronger."), 0, -0.5, 0.5),
    booleanSetting(text(SettingsSection.Theme, "transparency", "Transparency effects", "Translucent taskbar and flyouts. Blur comes from your compositor."), true),
    booleanSetting(text(SettingsSection.Theme, "reduceMotion", "Reduce motion", "Makes animations nearly instant."), false),

    ...APPEARANCE_DEFINITIONS,

    enumSetting(text(SettingsSection.Corners, "model", "Corner model", "smoothing uses the iOS-style continuous-corner formula; superellipse uses |x|^n + |y|^n = 1 per corner. Circular corners are chosen through the appearance corners effect."), CornerModel, CornerModel.Smoothing),
    numberSetting(text(SettingsSection.Corners, "smoothing", "Corner smoothing", "0 is a circle; 0.6 matches iOS; 1 is the smoothest."), 0.6, 0, 1),
    numberSetting(text(SettingsSection.Corners, "overlaySmoothing", "Surface corner smoothing", "Smoothing for flyouts, cards and toasts. -1 uses the global value."), -1, -1, 1),
    numberSetting(text(SettingsSection.Corners, "controlSmoothing", "Control corner smoothing", "Smoothing for buttons, tiles and list items. -1 uses the global value."), -1, -1, 1),
    numberSetting(text(SettingsSection.Corners, "exponent", "Superellipse exponent", "2 is a circle, 4-5 is Apple-like, higher gets squarer."), 5, 2, 20),
    integerSetting(text(SettingsSection.Corners, "segments", "Superellipse segments", "Line segments per corner for the superellipse model."), 12, 2, 64),

    textSetting(text(SettingsSection.AppIcons, "theme", "App icon theme", "Icon theme folder name for app icons (e.g. Papirus, Adwaita). Empty follows your Qt icon theme. Missing icons fall back to it."), ""),
    textListSetting(text(SettingsSection.AppIcons, "overrides", "Per-app icons", "appId=icon entries; icon is a theme icon name, an absolute path, image:<path> or a URL. Example: firefox=/home/me/icons/fox.svg"), []),

    textListSetting(text(SettingsSection.Profiles, "active", "Active profiles", "Profile folder names applied in order; later ones win, your own settings win last. A profile with activateWhen applies only while its conditions hold."), []),
    textListSetting(text(SettingsSection.Profiles, "trustedCommands", "Profiles allowed to change commands", "Profiles listed here may set commands.*; others have those keys skipped, because commands run programs."), []),

    enumSetting(text(SettingsSection.Wallpaper, "mode", "Wallpaper drawn by", "external: your wallpaper tool draws it and the shell only reads wallpaper.path for mica. shell: the shell draws it too."), WallpaperMode, WallpaperMode.External),
    textListSetting(text(SettingsSection.AppTheming, "targets", "Apps to theme", "Bundled templates rendered when app theming runs. Your own templates in the template folder always render."), APP_THEME_TARGETS.map(target => target.id), APP_THEME_TARGETS.map(target => target.id)),
    textSetting(text(SettingsSection.AppTheming, "outputDirectory", "Theme output folder", "Rendered files land here; include them from each app's config. Empty uses <config>/qs-win-11/themes. ~ is your home."), ""),
    textSetting(text(SettingsSection.AppTheming, "templateDirectory", "Your templates folder", "Files named <name>.tmpl here replace a bundled template of the same name or add a new one. Empty uses <output>/templates."), ""),
    booleanSetting(text(SettingsSection.LockScreen, "useWallpaper", "Wallpaper on the lock screen", "Shows wallpaper.path behind the clock; off uses the accent gradient."), true),
    booleanSetting(text(SettingsSection.LockScreen, "blurOnPrompt", "Blur when signing in", "Blurs the background while the password field shows. Follows the effects level."), true),
    booleanSetting(text(SettingsSection.LockScreen, "showWeather", "Weather on the lock screen", "Current temperature and conditions."), true),
    booleanSetting(text(SettingsSection.LockScreen, "showMedia", "Media on the lock screen", "What is playing, with play and pause."), true),
    booleanSetting(text(SettingsSection.LockScreen, "showStatus", "Status on the lock screen", "Network, battery and the number of notifications."), true),
    textSetting(text(SettingsSection.Wallpaper, "directory", "Wallpaper folder", "Folder the wallpaper picker and wallpaper next read images from. ~ is your home."), "~/Pictures/Wallpapers"),
    textSetting(text(SettingsSection.Wallpaper, "path", "Wallpaper file", "Image path. Needed for the mica backdrop; mica falls back to acrylic without it."), ""),
    enumSetting(text(SettingsSection.Wallpaper, "fillMode", "Wallpaper fit", "How the image fills the screen."), WallpaperFill, WallpaperFill.Crop),

    numberSetting(text(SettingsSection.Backdrop, "tintOpacity", "Tint opacity", "Opacity of the color layer over the plain tint backdrop. -1 keeps each color's own alpha."), -1, -1, 1),
    numberSetting(text(SettingsSection.Backdrop, "acrylicTintOpacity", "Acrylic tint opacity", "Opacity of the color layer over compositor blur."), 0.72, 0, 1),
    numberSetting(text(SettingsSection.Backdrop, "micaTintOpacity", "Mica tint opacity", "Opacity of the color layer over the blurred wallpaper."), 0.8, 0, 1),
    numberSetting(text(SettingsSection.Backdrop, "micaBlur", "Mica blur", "Blur strength, 0 to 1 of mica blur radius."), 1, 0, 1),
    integerSetting(text(SettingsSection.Backdrop, "micaBlurRadius", "Mica blur radius", "Largest blur radius in pixels."), 64, 1, 256),
    numberSetting(text(SettingsSection.Backdrop, "micaSaturation", "Mica saturation", "-1 grayscale, 0 unchanged, 1 vivid."), 0.25, -1, 1),
    numberSetting(text(SettingsSection.Backdrop, "micaBrightness", "Mica brightness", "-1 darker, 0 unchanged, 1 brighter."), 0, -1, 1),
    numberSetting(text(SettingsSection.Backdrop, "grainOpacity", "Grain opacity", "Strength of the noise texture."), 0.035, 0, 1),
    numberSetting(text(SettingsSection.Backdrop, "grainScale", "Grain scale", "Size multiplier of the noise texture."), 1, 0.25, 8),

    enumSetting(text(SettingsSection.Compositor, "kind", "Compositor integration", "Auto detects Hyprland; generic works on any wlr-foreign-toplevel compositor."), CompositorKind, CompositorKind.Auto),

    enumSetting(text(SettingsSection.Taskbar, "alignment", "Taskbar alignment", "Where the Start button and apps sit."), TaskbarAlignment, TaskbarAlignment.Center),
    booleanSetting(text(SettingsSection.Taskbar, "autoHide", "Automatically hide the taskbar", "Slides away until the pointer touches the bottom edge."), false),
    enumSetting(text(SettingsSection.Taskbar, "inputIndicator", "Input indicator", "Keyboard layout button near the clock. Auto shows it when more than one layout is configured."), InputIndicatorMode, InputIndicatorMode.Auto),
    booleanSetting(text(SettingsSection.Taskbar, "showSearch", "Show Search", "Search button on the taskbar."), true),
    booleanSetting(text(SettingsSection.Taskbar, "showTaskView", "Show Task view", "Task view button on the taskbar."), true),
    booleanSetting(text(SettingsSection.Taskbar, "showWidgets", "Show Widgets", "Weather and widgets button on the taskbar."), true),
    textListSetting(text(SettingsSection.Taskbar, "initialPinned", "Initially pinned apps", "Desktop entry ids on the taskbar before you pin anything yourself."), ["org.gnome.Nautilus", "firefox", "kitty"]),
    booleanSetting(text(SettingsSection.Taskbar, "windowsOnAllMonitors", "Show apps on all taskbars", "Off shows each window only on its own monitor's taskbar."), false),

    booleanSetting(text(SettingsSection.StartMenu, "showRecommended", "Show recommended files", "Recently used files in Start."), true),
    booleanSetting(text(SettingsSection.StartMenu, "searchCalculator", "Calculator in search", "Typing math in Start or Search shows the result first."), true),
    booleanSetting(text(SettingsSection.StartMenu, "searchSettings", "Settings in search", "Matching settings appear below apps in search results."), true),
    enumSetting(text(SettingsSection.StartMenu, "allAppsView", "All apps view", "How the All section in Start lists apps."), AllAppsView, AllAppsView.Category),
    textListSetting(text(SettingsSection.StartMenu, "initialPinned", "Initially pinned apps", "Desktop entry ids pinned before you pin anything yourself."), ["firefox", "org.gnome.Nautilus", "kitty", "org.gnome.TextEditor", "org.gnome.Calculator"]),

    textSetting(text(SettingsSection.QuickSettings, "vpnConnection", "VPN connection", "Name of the VPN the tile turns on. Empty uses the first VPN NetworkManager knows."), ""),
    textSetting(text(SettingsSection.QuickSettings, "gameModeProfile", "Game mode profile", "Profile applied while game mode is on. Without a profile folder of this name, a built-in one sets the effects level to 0."), "game"),
    booleanSetting(text(SettingsSection.QuickSettings, "gameModeSilencesNotifications", "Game mode silences notifications", "No banners while game mode is on; critical ones still show."), true),
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

    textListSetting(text(SettingsSection.Widgets, "performanceMetrics", "Performance metrics", "Rows in the Performance card, in order. Metrics this PC cannot report hide themselves."), Object.values(PerformanceMetric), Object.values(PerformanceMetric)),
    textSetting(text(SettingsSection.Widgets, "storagePath", "Storage to watch", "Any path on the disk shown in the Performance card."), "/"),
    enumSetting(text(SettingsSection.DesktopClock, "position", "Desktop clock position", "Where the desktop clock sits on each screen."), ScreenCorner, ScreenCorner.TopRight),
    booleanSetting(text(SettingsSection.DesktopClock, "showDate", "Show the date", "Long date under the desktop clock."), true),
    enumSetting(text(SettingsSection.Weather, "unit", "Temperature unit", "Unit for weather."), TemperatureUnit, TemperatureUnit.Celsius),
    enumSetting(text(SettingsSection.Weather, "locationMode", "Location", "Auto tries GeoClue, then an IP lookup if allowed."), LocationMode, LocationMode.Auto),
    booleanSetting(text(SettingsSection.Weather, "allowIpLookup", "Allow IP location lookup", "Sends your IP address to ipwho.is when GeoClue is unavailable."), true),
    numberSetting(text(SettingsSection.Weather, "manualLatitude", "Manual latitude", "Used when location is manual."), 0, -90, 90),
    numberSetting(text(SettingsSection.Weather, "manualLongitude", "Manual longitude", "Used when location is manual."), 0, -180, 180),
    textSetting(text(SettingsSection.Weather, "manualPlaceName", "Manual place name", "Shown on the weather widget when location is manual."), ""),

    textSetting(text(SettingsSection.Commands, "afterAppTheme", "After app theming", "Runs after themed files are written, e.g. pkill -USR1 kitty. Empty runs nothing."), ""),
    textSetting(text(SettingsSection.Commands, "terminal", "Terminal", "Command that opens a terminal."), "kitty"),
    textSetting(text(SettingsSection.Commands, "fileManager", "File manager", "Command that opens the file manager."), "nautilus"),
    textSetting(text(SettingsSection.Commands, "taskManager", "Task manager", "Command that opens a task manager."), "gnome-system-monitor"),
    textSetting(text(SettingsSection.Commands, "lock", "Lock command", "Used when the built-in lock screen is off."), "loginctl lock-session"),
    textSetting(text(SettingsSection.Commands, "signOut", "Sign out command", "Empty uses the compositor's own exit."), ""),
    textSetting(text(SettingsSection.Commands, "nightLight", "Night light command", "Runs while night light is on and is stopped when it turns off."), "hyprsunset -t 4000"),
    textSetting(text(SettingsSection.Commands, "brightness", "Brightness command", "{percent} is replaced with 0-100."), "brightnessctl set {percent}%"),
    textSetting(text(SettingsSection.Commands, "screenOff", "Screen off command", "Used by idle handling. Empty skips the screen-off step."), "hyprctl dispatch dpms off"),
    textSetting(text(SettingsSection.Commands, "screenOn", "Screen on command", "Runs when activity resumes after screen off."), "hyprctl dispatch dpms on"),
    textSetting(text(SettingsSection.Commands, "soundSettings", "Sound settings", "Opened from the volume slider. Empty hides the link."), "pavucontrol"),
    textSetting(text(SettingsSection.Commands, "networkSettings", "Network settings", "Opened from the Wi-Fi page. Empty hides the link."), "nm-connection-editor"),
    textSetting(text(SettingsSection.Commands, "bluetoothSettings", "Bluetooth settings", "Opened from the Bluetooth page. Empty hides the link."), "blueman-manager"),
    textSetting(text(SettingsSection.Commands, "displaySettings", "Display settings", "Opened from the desktop menu. Empty hides the link."), ""),

    ...featureDefinitions,
    ...experimentalDefinitions,
    ...VALUE_DEFINITIONS,
]);

export const SettingKey = Object.freeze({
    ThemeMode: "theme.mode",
    QuickSettingsTiles: "quickSettings.tiles",
    TaskbarAlignment: "taskbar.alignment",
    StartAllAppsView: "startMenu.allAppsView",
    WallpaperPath: "wallpaper.path",
});
