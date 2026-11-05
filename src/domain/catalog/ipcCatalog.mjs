export const SHELL_CONFIG_NAME = "qs-win-11";

/** @typedef {{ modifiers: readonly string[], key: string, onRelease?: boolean }} KeyCombo */
/** @typedef {{ name: string, description: string, suggestedKey?: KeyCombo }} IpcFunction */
/** @typedef {{ target: string, description: string, functions: readonly IpcFunction[] }} IpcTarget */

export const IpcTargetName = Object.freeze({
    Shell: "shell",
    Settings: "settings",
});

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
]);
