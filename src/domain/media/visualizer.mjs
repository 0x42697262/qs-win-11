const BAR_DELIMITER = ";";
const BAR_DELIMITER_CODE = 59;
const FRAME_DELIMITER_CODE = 10;

/**
 * @param {number} bars
 * @param {number} framerate
 * @param {number} maxRange
 * @returns {string}
 */
export function cavaConfig(bars, framerate, maxRange) {
    return [
        "[general]",
        `bars = ${Math.max(1, Math.round(bars))}`,
        `framerate = ${Math.max(1, Math.round(framerate))}`,
        "[input]",
        "method = pipewire",
        "[output]",
        "method = raw",
        "raw_target = /dev/stdout",
        "data_format = ascii",
        `ascii_max_range = ${Math.max(1, Math.round(maxRange))}`,
        `bar_delimiter = ${BAR_DELIMITER_CODE}`,
        `frame_delimiter = ${FRAME_DELIMITER_CODE}`,
        "",
    ].join("\n");
}

/**
 * @param {string} line
 * @param {number} maxRange
 * @returns {number[]}
 */
export function parseCavaFrame(line, maxRange) {
    const range = Math.max(1, maxRange);
    return line.split(BAR_DELIMITER)
        .map(part => part.trim())
        .filter(part => part !== "")
        .map(part => Math.min(1, Math.max(0, Number(part) / range)))
        .filter(value => Number.isFinite(value));
}
