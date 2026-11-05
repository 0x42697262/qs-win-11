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

const LOOPBACK = "lo";
const NET_RX_FIELD = 0;
const NET_TX_FIELD = 8;
const DF_SIZE_FIELD = 1;
const DF_USED_FIELD = 2;
const PERCENT = 100;
const BYTE_STEP = 1024;
const SIZE_DIGITS = 1;
const GPU_SEPARATOR = ",";
const GpuSource = Object.freeze({ amd: "amd", nvidia: "nvidia", intel: "intel" });

/** @typedef {{ rx: number, tx: number }} NetSample */
/** @typedef {{ used: number, total: number }} Usage */

/**
 * @param {string} text
 * @returns {NetSample}
 */
export function parseNetDev(text) {
    let rx = 0;
    let tx = 0;
    text.split("\n").forEach(line => {
        const colon = line.indexOf(":");
        if (colon < 0) {
            return;
        }
        const name = line.slice(0, colon).trim();
        if (name === LOOPBACK || name === "") {
            return;
        }
        const fields = line.slice(colon + 1).trim().split(WHITESPACE).map(Number);
        rx += fields[NET_RX_FIELD] || 0;
        tx += fields[NET_TX_FIELD] || 0;
    });
    return { rx, tx };
}

/**
 * @param {NetSample} previous
 * @param {NetSample} next
 * @param {number} seconds
 * @returns {NetSample}
 */
export function netRate(previous, next, seconds) {
    if (seconds <= 0) {
        return { rx: 0, tx: 0 };
    }
    return { rx: Math.max(0, (next.rx - previous.rx) / seconds), tx: Math.max(0, (next.tx - previous.tx) / seconds) };
}

/**
 * @param {string} output
 * @returns {Usage}
 */
export function parseDiskUsage(output) {
    const lines = output.split("\n").filter(line => line.trim() !== "");
    const fields = (lines[1] ?? "").trim().split(WHITESPACE);
    return { used: Number(fields[DF_USED_FIELD]) || 0, total: Number(fields[DF_SIZE_FIELD]) || 0 };
}

/**
 * @param {string} output
 * @returns {number | null}
 */
export function parseGpuUsage(output) {
    const line = output.split("\n").find(candidate => candidate.trim() !== "") ?? "";
    const [source, value] = line.trim().split(/\s+/, 2);
    if (!value) {
        return null;
    }
    const percent = source === GpuSource.nvidia ? Number(value.split(GPU_SEPARATOR)[0]) : Number(value);
    return Number.isFinite(percent) ? Math.min(1, Math.max(0, percent / PERCENT)) : null;
}

/**
 * @param {number} bytes
 * @param {readonly string[]} suffixes
 * @returns {string}
 */
export function formatBytes(bytes, suffixes) {
    let value = Math.max(0, bytes);
    let index = 0;
    while (value >= BYTE_STEP && index < suffixes.length - 1) {
        value /= BYTE_STEP;
        index += 1;
    }
    return `${index === 0 ? Math.round(value) : value.toFixed(SIZE_DIGITS)} ${suffixes[index] ?? ""}`;
}

/**
 * @param {readonly number[]} history
 * @param {number} value
 * @param {number} limit
 * @returns {number[]}
 */
export function pushHistory(history, value, limit) {
    return history.concat([value]).slice(-Math.max(1, limit));
}
