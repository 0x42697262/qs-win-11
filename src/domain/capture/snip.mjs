/** @typedef {{ x: number, y: number, width: number, height: number }} Rect */

const TIMESTAMP_PLACEHOLDER = "{timestamp}";
const FILE_PLACEHOLDER = "{file}";
const PAD_WIDTH = 2;
const MONTH_OFFSET = 1;

/**
 * @param {number} startX
 * @param {number} startY
 * @param {number} endX
 * @param {number} endY
 * @returns {Rect}
 */
export function normalizeRect(startX, startY, endX, endY) {
    return {
        x: Math.round(Math.min(startX, endX)),
        y: Math.round(Math.min(startY, endY)),
        width: Math.round(Math.abs(endX - startX)),
        height: Math.round(Math.abs(endY - startY)),
    };
}

/**
 * @param {Rect} rect
 * @param {number} originX
 * @param {number} originY
 * @returns {string}
 */
export function grimGeometry(rect, originX, originY) {
    return `${Math.round(rect.x + originX)},${Math.round(rect.y + originY)} ${Math.max(1, Math.round(rect.width))}x${Math.max(1, Math.round(rect.height))}`;
}

/**
 * @param {Rect} rect
 * @param {number} originX
 * @param {number} originY
 * @returns {string}
 */
export function gpuRecorderRegion(rect, originX, originY) {
    return `${Math.max(1, Math.round(rect.width))}x${Math.max(1, Math.round(rect.height))}+${Math.round(rect.x + originX)}+${Math.round(rect.y + originY)}`;
}

/**
 * @param {Date} date
 * @returns {string}
 */
export function timestamp(date) {
    const pad = (/** @type {number} */ value) => String(value).padStart(PAD_WIDTH, "0");
    return `${date.getFullYear()}-${pad(date.getMonth() + MONTH_OFFSET)}-${pad(date.getDate())}_${pad(date.getHours())}-${pad(date.getMinutes())}-${pad(date.getSeconds())}`;
}

/**
 * @param {string} directory
 * @param {string} pattern
 * @param {Date} date
 * @returns {string}
 */
export function capturePath(directory, pattern, date) {
    return `${directory}/${pattern.split(TIMESTAMP_PLACEHOLDER).join(timestamp(date))}`;
}

/**
 * @param {readonly { id: string, x: number, y: number, width: number, height: number }[]} windows
 * @param {number} pointX
 * @param {number} pointY
 * @returns {{ id: string, x: number, y: number, width: number, height: number } | null}
 */
export function windowAt(windows, pointX, pointY) {
    return windows.find(window => pointX >= window.x && pointX < window.x + window.width && pointY >= window.y && pointY < window.y + window.height) ?? null;
}

/**
 * @param {string} template
 * @param {string} path
 * @returns {string}
 */
export function fillFileCommand(template, path) {
    const quoted = `'${path.split("'").join("'\\''")}'`;
    return template.split(FILE_PLACEHOLDER).join(quoted);
}

const RecorderBinary = Object.freeze({ gpu: "gpu-screen-recorder", wf: "wf-recorder" });
const RecorderPreference = Object.freeze({ auto: "auto", gpu: "gpuScreenRecorder", wf: "wfRecorder" });

/**
 * @param {string} choice
 * @param {{ gpu: boolean, wf: boolean }} available
 * @returns {string}
 */
export function pickRecorder(choice, available) {
    if (choice === RecorderPreference.gpu) {
        return available.gpu ? RecorderBinary.gpu : "";
    }
    if (choice === RecorderPreference.wf) {
        return available.wf ? RecorderBinary.wf : "";
    }
    return available.gpu ? RecorderBinary.gpu : available.wf ? RecorderBinary.wf : "";
}

/**
 * @param {string} binary
 * @param {Rect | null} rect
 * @param {{ x: number, y: number, name: string }} screen
 * @param {string} path
 * @param {boolean} audio
 * @returns {string[]}
 */
export function recorderCommand(binary, rect, screen, path, audio) {
    if (binary === RecorderBinary.gpu) {
        const target = rect ? ["-w", "region", "-region", gpuRecorderRegion(rect, screen.x, screen.y)] : ["-w", screen.name];
        return (/** @type {string[]} */ ([binary])).concat(target, audio ? ["-a", "default_output"] : [], ["-o", path]);
    }
    if (binary === RecorderBinary.wf) {
        const target = rect ? ["-g", grimGeometry(rect, screen.x, screen.y)] : ["-o", screen.name];
        return (/** @type {string[]} */ ([binary])).concat(target, audio ? ["--audio"] : [], ["-f", path]);
    }
    return [];
}
