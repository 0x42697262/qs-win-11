export const SHELL_CONFIG_NAME = "qs-win-11";

/** @typedef {{ modifiers: readonly string[], key: string, onRelease?: boolean }} KeyCombo */
/** @typedef {{ name: string, description: string, suggestedKey?: KeyCombo }} IpcFunction */
/** @typedef {{ target: string, description: string, functions: readonly IpcFunction[] }} IpcTarget */

export const IpcTargetName = Object.freeze({
    Shell: "shell",
    Settings: "settings",
    Start: "start",
    Search: "search",
    QuickLink: "quickLink",
    Session: "session",
    QuickSettings: "quickSettings",
    Notifications: "notifications",
    Audio: "audio",
    Brightness: "brightness",
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
        target: IpcTargetName.Session,
        description: "Lock, sleep, sign out, restart, shut down.",
        functions: [
            { name: "lock", description: "Lock the session.", suggestedKey: { modifiers: [SUPER], key: "L" } },
            { name: "suspend", description: "Sleep." },
            { name: "hibernate", description: "Hibernate." },
            { name: "signOut", description: "Sign out of the session." },
            { name: "restart", description: "Restart the computer." },
            { name: "powerOff", description: "Shut down the computer." },
        ],
    },
]);
