export const SHELL_CONFIG_NAME = "qs-win-11";
export const SHELL_VERSION = "0.1.0";

/** @typedef {{ modifiers: readonly string[], key: string, onRelease?: boolean }} KeyCombo */
/** @typedef {{ name: string, description: string, suggestedKey?: KeyCombo }} IpcFunction */
/** @typedef {{ target: string, description: string, functions: readonly IpcFunction[] }} IpcTarget */

export const IpcTargetName = Object.freeze({
    Shell: "shell",
    Settings: "settings",
    Start: "start",
    Search: "search",
    Run: "run",
    Modes: "modes",
    Keyboard: "keyboard",
    QuickLink: "quickLink",
    Session: "session",
    QuickSettings: "quickSettings",
    Notifications: "notifications",
    Audio: "audio",
    Brightness: "brightness",
    TaskView: "taskView",
    AltTab: "altTab",
    Desktop: "desktop",
    Widgets: "widgets",
    Snap: "snap",
    Profiles: "profiles",
});

const SUPER = "SUPER";
const SHIFT = "SHIFT";
const CONTROL = "CTRL";
const ALT = "ALT";
export const Modifier = Object.freeze({ Super: SUPER, Shift: SHIFT, Control: CONTROL, Alt: ALT });

/** @type {readonly IpcTarget[]} */
export const IPC_TARGETS = Object.freeze([
    {
        target: IpcTargetName.Shell,
        description: "The shell itself.",
        functions: [
            { name: "reload", description: "Reload the shell configuration." },
        ],
    },
    {
        target: IpcTargetName.Settings,
        description: "Read and change settings from scripts.",
        functions: [
            { name: "get", description: "Print the effective value of a setting key, as JSON." },
            { name: "set", description: "Set a setting key to a JSON value (bare words are treated as text)." },
            { name: "reset", description: "Return a setting key to its default." },
            { name: "open", description: "Open the Settings app.", suggestedKey: { modifiers: [SUPER], key: "I" } },
            { name: "exportProfile", description: "Write every changed setting to a profile file (absolute path)." },
            { name: "importProfile", description: "Replace all changed settings with a profile file; invalid keys are skipped and reported." },
        ],
    },
    {
        target: IpcTargetName.Start,
        description: "Start menu.",
        functions: [
            { name: "toggle", description: "Open or close Start.", suggestedKey: { modifiers: [SUPER], key: "SUPER_L", onRelease: true } },
            { name: "allApps", description: "Open Start on the All apps list." },
        ],
    },
    {
        target: IpcTargetName.Search,
        description: "Search flyout.",
        functions: [
            { name: "toggle", description: "Open or close Search.", suggestedKey: { modifiers: [SUPER], key: "S" } },
        ],
    },
    {
        target: IpcTargetName.Run,
        description: "Run dialog.",
        functions: [
            { name: "toggle", description: "Open or close the Run dialog.", suggestedKey: { modifiers: [SUPER], key: "R" } },
        ],
    },
    {
        target: IpcTargetName.Modes,
        description: "Stay awake and game mode.",
        functions: [
            { name: "toggleStayAwake", description: "Keep the screen on until turned off again." },
            { name: "toggleGameMode", description: "Apply the game mode profile and silence banners." },
        ],
    },
    {
        target: IpcTargetName.Keyboard,
        description: "Keyboard layout and lock keys.",
        functions: [
            { name: "nextLayout", description: "Switch to the next keyboard layout (Hyprland).", suggestedKey: { modifiers: [SUPER], key: "SPACE" } },
            { name: "lockKeys", description: "Show Caps Lock and Num Lock state on screen; bind to the key release.", suggestedKey: { modifiers: [], key: "Caps_Lock", onRelease: true } },
        ],
    },
    {
        target: IpcTargetName.QuickLink,
        description: "Quick Link menu (right-click on Start).",
        functions: [
            { name: "toggle", description: "Open or close the Quick Link menu.", suggestedKey: { modifiers: [SUPER], key: "X" } },
        ],
    },
    {
        target: IpcTargetName.QuickSettings,
        description: "Quick Settings flyout.",
        functions: [
            { name: "toggle", description: "Open or close Quick Settings.", suggestedKey: { modifiers: [SUPER], key: "A" } },
        ],
    },
    {
        target: IpcTargetName.Notifications,
        description: "Notification center and calendar.",
        functions: [
            { name: "toggle", description: "Open or close the notification center.", suggestedKey: { modifiers: [SUPER], key: "N" } },
            { name: "clearAll", description: "Dismiss every notification." },
            { name: "toggleDoNotDisturb", description: "Turn do not disturb on or off." },
        ],
    },
    {
        target: IpcTargetName.Audio,
        description: "Volume and microphone, with the on-screen display.",
        functions: [
            { name: "volumeUp", description: "Raise volume by one step.", suggestedKey: { modifiers: [], key: "XF86AudioRaiseVolume" } },
            { name: "volumeDown", description: "Lower volume by one step.", suggestedKey: { modifiers: [], key: "XF86AudioLowerVolume" } },
            { name: "toggleMute", description: "Mute or unmute output.", suggestedKey: { modifiers: [], key: "XF86AudioMute" } },
            { name: "toggleMicrophoneMute", description: "Mute or unmute the microphone.", suggestedKey: { modifiers: [], key: "XF86AudioMicMute" } },
        ],
    },
    {
        target: IpcTargetName.Brightness,
        description: "Screen brightness, with the on-screen display.",
        functions: [
            { name: "up", description: "Raise brightness by one step.", suggestedKey: { modifiers: [], key: "XF86MonBrightnessUp" } },
            { name: "down", description: "Lower brightness by one step.", suggestedKey: { modifiers: [], key: "XF86MonBrightnessDown" } },
        ],
    },
    {
        target: IpcTargetName.TaskView,
        description: "Task View: open windows and workspaces.",
        functions: [
            { name: "toggle", description: "Open or close Task View.", suggestedKey: { modifiers: [SUPER], key: "Tab" } },
        ],
    },
    {
        target: IpcTargetName.AltTab,
        description: "Alt+Tab switcher in most-recently-used order.",
        functions: [
            { name: "next", description: "Open the switcher or move to the next window.", suggestedKey: { modifiers: [ALT], key: "Tab" } },
            { name: "previous", description: "Move to the previous window.", suggestedKey: { modifiers: [ALT, SHIFT], key: "Tab" } },
            { name: "commit", description: "Focus the selected window and close the switcher.", suggestedKey: { modifiers: [ALT], key: "ALT_L", onRelease: true } },
            { name: "cancel", description: "Close the switcher without switching." },
        ],
    },
    {
        target: IpcTargetName.Desktop,
        description: "Show the desktop.",
        functions: [
            { name: "toggle", description: "Minimize all windows, or restore them.", suggestedKey: { modifiers: [SUPER], key: "D" } },
        ],
    },
    {
        target: IpcTargetName.Widgets,
        description: "Widgets board.",
        functions: [
            { name: "toggle", description: "Open or close the widgets board.", suggestedKey: { modifiers: [SUPER], key: "W" } },
        ],
    },
    {
        target: IpcTargetName.Snap,
        description: "Snap layouts for the focused window.",
        functions: [
            { name: "open", description: "Open the snap layout picker.", suggestedKey: { modifiers: [SUPER], key: "Z" } },
        ],
    },
    {
        target: IpcTargetName.Profiles,
        description: "Stackable profiles: icon packs, color schemes, effect modes, whole looks.",
        functions: [
            { name: "list", description: "Installed profiles as JSON: name, active, conditions, problems." },
            { name: "activate", description: "Add a profile to the top of the active stack." },
            { name: "deactivate", description: "Remove a profile from the active stack." },
            { name: "order", description: "Set the whole active stack, comma-separated, first is lowest." },
            { name: "create", description: "Save your changed settings for some sections (comma-separated, e.g. icons,colors) as a new profile." },
            { name: "absorb", description: "Copy a profile's values into your own settings." },
            { name: "trust", description: "Allow a profile to change commands.*." },
            { name: "untrust", description: "Stop a profile from changing commands.*." },
        ],
    },
    {
        target: IpcTargetName.Session,
        description: "Lock, sleep, sign out, restart, shut down.",
        functions: [
            { name: "lock", description: "Lock the session.", suggestedKey: { modifiers: [SUPER], key: "L" } },
            { name: "menu", description: "Open the full-screen session menu.", suggestedKey: { modifiers: [CONTROL, ALT], key: "Delete" } },
            { name: "suspend", description: "Sleep." },
            { name: "hibernate", description: "Hibernate." },
            { name: "signOut", description: "Sign out of the session." },
            { name: "restart", description: "Restart the computer." },
            { name: "powerOff", description: "Shut down the computer." },
        ],
    },
]);
