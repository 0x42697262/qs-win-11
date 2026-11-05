import { SHELL_CONFIG_NAME } from "../src/domain/catalog/ipcCatalog.mjs";

/** @typedef {import("../src/domain/catalog/ipcCatalog.mjs").IpcTarget} IpcTarget */
/** @typedef {import("../src/domain/catalog/ipcCatalog.mjs").KeyCombo} KeyCombo */
/** @typedef {{ target: string, functionName: string, description: string, key: KeyCombo }} BoundCall */

const HEADER_NOTE = "Generated from src/domain/catalog/ipcCatalog.mjs. Copy what you need; the shell never binds keys itself.";

/** @param {string} target @param {string} functionName @returns {string} */
export function ipcCommand(target, functionName) {
    return `qs -c ${SHELL_CONFIG_NAME} ipc call ${target} ${functionName}`;
}

/** @param {readonly IpcTarget[]} targets @returns {BoundCall[]} */
function boundCalls(targets) {
    return targets.flatMap((target) => target.functions.flatMap((ipcFunction) => ipcFunction.suggestedKey
        ? [{ target: target.target, functionName: ipcFunction.name, description: ipcFunction.description, key: ipcFunction.suggestedKey }]
        : []));
}

/** @param {KeyCombo} key @param {string} joiner @returns {string} */
function comboText(key, joiner) {
    return [...key.modifiers, key.key].join(joiner);
}

/** @param {readonly IpcTarget[]} targets @returns {string} */
export function renderKeybindsMarkdown(targets) {
    const rows = targets.flatMap((target) => target.functions.map((ipcFunction) =>
        `| \`${target.target} ${ipcFunction.name}\` | ${ipcFunction.description} | ${ipcFunction.suggestedKey ? `\`${comboText(ipcFunction.suggestedKey, "+")}\`${ipcFunction.suggestedKey.onRelease ? " (on release)" : ""}` : ""} |`));
    return `<!-- ${HEADER_NOTE} -->\n\n# IPC and keybinds\n\nEvery action is an IPC call:\n\n\`\`\`bash\nqs -c ${SHELL_CONFIG_NAME} ipc call <target> <function>\n\`\`\`\n\nSuggested keys follow Windows 11. Ready-to-copy versions for plain Hyprland binds, Hyprland Lua configs and hyprchords are in [\`examples/hyprland/\`](../examples/hyprland/). Check for clashes with your existing binds first.\n\n| Call | Does | Suggested key |\n|---|---|---|\n${rows.join("\n")}\n`;
}

/** @param {readonly IpcTarget[]} targets @returns {string} */
export function renderHyprlandConf(targets) {
    const lines = boundCalls(targets).map((call) => {
        const bindKind = call.key.onRelease ? "bindr" : "bind";
        return `${bindKind} = ${call.key.modifiers.join(" ")}, ${call.key.key}, exec, ${ipcCommand(call.target, call.functionName)}`;
    });
    return `# ${HEADER_NOTE}\n\n${lines.join("\n")}\n`;
}

/** @param {readonly IpcTarget[]} targets @returns {string} */
export function renderHyprlandLua(targets) {
    const entries = boundCalls(targets).map((call) => {
        const options = call.key.onRelease ? "\n\t\topts = { release = true }," : "";
        return `\t{\n\t\taction = hl.dsp.exec_cmd("${ipcCommand(call.target, call.functionName)}"),\n\t\tbind = "${comboText(call.key, " + ")}",${options}\n\t},`;
    });
    return `-- ${HEADER_NOTE}\n-- Entries match the keymap table shape { action, bind, chord, opts }.\n\nreturn {\n${entries.join("\n")}\n}\n`;
}

/** @param {readonly IpcTarget[]} targets @returns {string} */
export function renderHyprchords(targets) {
    const lines = boundCalls(targets).filter((call) => !call.key.onRelease).map((call) =>
        `chord = ${comboText(call.key, "+")} , exec , ${ipcCommand(call.target, call.functionName)}`);
    return `# ${HEADER_NOTE}\n# Place inside plugin { hyprchords { ... } }.\n\n${lines.join("\n")}\n`;
}
