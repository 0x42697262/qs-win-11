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
