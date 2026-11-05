import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { IPC_TARGETS, IpcTargetName } from "../src/domain/catalog/ipcCatalog.mjs";

const IPC_DIRECTORY = new URL("../src/ipc/", import.meta.url).pathname;
const TARGET_PATTERN = /target:\s*IpcCatalog\.IpcTargetName\.(\w+)/;
const FUNCTION_PATTERN = /^\s{4}function\s+(\w+)\s*\(/gm;

/** @type {Map<string, Set<string>>} */
const implemented = new Map();
for (const file of readdirSync(IPC_DIRECTORY).filter((name) => name.endsWith(".qml"))) {
    const source = readFileSync(join(IPC_DIRECTORY, file), "utf8");
    const targetKey = source.match(TARGET_PATTERN)?.[1];
    const target = targetKey ? IpcTargetName[/** @type {keyof typeof IpcTargetName} */ (targetKey)] : undefined;
    if (!target) {
        console.error(`check-ipc: ${file} has no catalog target`);
        process.exit(1);
    }
    implemented.set(target, new Set([...source.matchAll(FUNCTION_PATTERN)].map((match) => match[1] ?? "")));
}

/** @type {string[]} */
const problems = [];
for (const target of IPC_TARGETS) {
    const functions = implemented.get(target.target);
    if (!functions) {
        problems.push(`target "${target.target}" has no handler in src/ipc`);
        continue;
    }
    for (const ipcFunction of target.functions) {
        if (!functions.has(ipcFunction.name)) {
            problems.push(`"${target.target} ${ipcFunction.name}" is cataloged but not implemented`);
        }
    }
    for (const name of functions) {
        if (!target.functions.some((ipcFunction) => ipcFunction.name === name)) {
            problems.push(`"${target.target} ${name}" is implemented but not cataloged`);
        }
    }
}
problems.forEach((problem) => console.error(`check-ipc: ${problem}`));
if (problems.length > 0) {
    process.exit(1);
}
console.info(`check-ipc: ${IPC_TARGETS.length} targets match`);
