const BINARY_PREFIX = "bin";
const BUS_PREFIX = "bus";
const BACKLIGHT_PREFIX = "backlight";
const SYSTEM_BUS_PREFIX = "sysbus";
const FIELD_SEPARATOR = "\t";
const PROBE_SHELL = "sh";
const DECIMAL_RADIX = 10;

/** @typedef {{ binaries: ReadonlySet<string>, busOwners: ReadonlyMap<string, number>, systemBusNames: ReadonlySet<string>, backlights: readonly string[] }} ProbeResult */

/**
 * @param {readonly string[]} binaries
 * @param {readonly string[]} busNames
 * @param {readonly string[]} systemBusNames
 * @returns {string[]}
 */
export function buildProbeCommand(binaries, busNames, systemBusNames) {
    const script = [
        `for name in ${binaries.map(quote).join(" ")}; do command -v "$name" >/dev/null 2>&1 && printf '${BINARY_PREFIX}\\t%s\\n' "$name"; done`,
        `for bus in ${busNames.map(quote).join(" ")}; do pid=$(busctl --user status "$bus" 2>/dev/null | sed -n 's/^PID=//p'); [ -n "$pid" ] && printf '${BUS_PREFIX}\\t%s\\t%s\\n' "$bus" "$pid"; done`,
        `for bus in ${systemBusNames.map(quote).join(" ")}; do busctl --system status "$bus" >/dev/null 2>&1 && printf '${SYSTEM_BUS_PREFIX}\\t%s\\n' "$bus"; done`,
        `for device in /sys/class/backlight/*; do [ -e "$device/brightness" ] && printf '${BACKLIGHT_PREFIX}\\t%s\\n' "$device"; done`,
        "true",
    ].join("; ");
    return [PROBE_SHELL, "-c", script];
}

/**
 * @param {string} value
 * @returns {string}
 */
function quote(value) {
    return `'${value.split("'").join("'\\''")}'`;
}

/**
 * @param {string} output
 * @returns {ProbeResult}
 */
export function parseProbeOutput(output) {
    /** @type {Set<string>} */
    const binaries = new Set();
    /** @type {Map<string, number>} */
    const busOwners = new Map();
    /** @type {string[]} */
    const backlights = [];
    /** @type {Set<string>} */
    const systemBusNames = new Set();
    for (const line of output.split("\n")) {
        const [kind, first, second] = line.split(FIELD_SEPARATOR);
        if (kind === BINARY_PREFIX && first) {
            binaries.add(first);
        } else if (kind === BUS_PREFIX && first && second) {
            busOwners.set(first, Number(second));
        } else if (kind === SYSTEM_BUS_PREFIX && first) {
            systemBusNames.add(first);
        } else if (kind === BACKLIGHT_PREFIX && first) {
            backlights.push(first);
        }
    }
    return { binaries, busOwners, systemBusNames, backlights };
}

/**
 * @param {ReadonlyMap<string, number>} busOwners
 * @param {number} ownProcessId
 * @returns {string[]}
 */
export function busNamesTakenByOthers(busOwners, ownProcessId) {
    return [...busOwners.entries()].filter(([, owner]) => owner !== ownProcessId).map(([name]) => name);
}

/**
 * @param {string} statText
 * @returns {number}
 */
export function processIdFromStat(statText) {
    return Number.parseInt(statText.split(" ")[0] ?? "", DECIMAL_RADIX);
}

/**
 * @param {string} command
 * @returns {string}
 */
export function commandBinary(command) {
    return command.trim().split(/\s+/)[0] ?? "";
}
