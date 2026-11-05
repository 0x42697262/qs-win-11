const WHITESPACE = /\s+/;
const IDLE_FIELDS = Object.freeze([3, 4]);
const MEMINFO_TOTAL = "MemTotal";
const MEMINFO_AVAILABLE = "MemAvailable";

/** @typedef {{ idle: number, total: number }} CpuSample */

/**
 * @param {string} text
 * @returns {CpuSample}
 */
export function parseCpuSample(text) {
    const firstLine = text.split("\n")[0] ?? "";
    const fields = firstLine.trim().split(WHITESPACE).slice(1).map(Number);
    const total = fields.reduce((sum, value) => sum + value, 0);
    const idle = IDLE_FIELDS.reduce((sum, index) => sum + (fields[index] ?? 0), 0);
    return { idle, total };
}

/**
 * @param {CpuSample} previous
 * @param {CpuSample} next
 * @returns {number}
 */
export function cpuUsage(previous, next) {
    const totalDelta = next.total - previous.total;
    if (totalDelta <= 0) {
        return 0;
    }
    return Math.min(1, Math.max(0, 1 - (next.idle - previous.idle) / totalDelta));
}

/**
 * @param {string} text
 * @returns {number}
 */
export function memoryUsage(text) {
    /** @type {Record<string, number>} */
    const values = {};
    text.split("\n").forEach((line) => {
        const [name, value] = line.split(":");
        if (name && value) {
            values[name.trim()] = Number.parseFloat(value);
        }
    });
    const total = values[MEMINFO_TOTAL] ?? 0;
    const available = values[MEMINFO_AVAILABLE] ?? 0;
    return total > 0 ? Math.min(1, Math.max(0, (total - available) / total)) : 0;
}
