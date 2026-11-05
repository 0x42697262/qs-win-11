/** @typedef {{ bus: string, model: string }} DdcDisplay */

const BUS_PATTERN = /I2C bus:\s*\/dev\/i2c-(\d+)/;
const MONITOR_PATTERN = /Monitor:\s*(.*)$/;
const DISPLAY_HEADER = /^Display\s+\d+/;
const VCP_PATTERN = /^VCP\s+\w+\s+C\s+(\d+)\s+(\d+)/m;
const MODEL_SEPARATOR = ":";
const MODEL_FIELD = 1;
const PERCENT = 100;

/**
 * @param {string} output
 * @returns {DdcDisplay[]}
 */
export function parseDdcDisplays(output) {
    /** @type {DdcDisplay[]} */
    const displays = [];
    /** @type {DdcDisplay | null} */
    let current = null;
    output.split("\n").forEach(line => {
        if (DISPLAY_HEADER.test(line.trim())) {
            current = { bus: "", model: "" };
            displays.push(current);
            return;
        }
        if (line.trim() !== "" && !/^\s/.test(line)) {
            current = null;
        }
        if (!current) {
            return;
        }
        const bus = BUS_PATTERN.exec(line);
        if (bus) {
            current.bus = bus[1];
        }
        const monitor = MONITOR_PATTERN.exec(line.trim());
        if (monitor) {
            const parts = monitor[1].split(MODEL_SEPARATOR);
            current.model = (parts.length > MODEL_FIELD ? parts[MODEL_FIELD] : monitor[1]).trim();
        }
    });
    return displays.filter(display => display.bus !== "");
}

/**
 * @param {string} output
 * @returns {number | null}
 */
export function parseVcpPercent(output) {
    const match = VCP_PATTERN.exec(output);
    if (!match) {
        return null;
    }
    const maximum = Number(match[2]);
    return maximum > 0 ? Math.round(Number(match[1]) / maximum * PERCENT) : null;
}
