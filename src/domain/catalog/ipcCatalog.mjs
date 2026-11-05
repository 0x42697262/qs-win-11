export const SHELL_CONFIG_NAME = "qs-win-11";

/** @typedef {{ modifiers: readonly string[], key: string, onRelease?: boolean }} KeyCombo */
/** @typedef {{ name: string, description: string, suggestedKey?: KeyCombo }} IpcFunction */
/** @typedef {{ target: string, description: string, functions: readonly IpcFunction[] }} IpcTarget */

export const IpcTargetName = Object.freeze({
    Shell: "shell",
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
]);
