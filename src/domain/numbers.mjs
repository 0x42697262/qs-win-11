/**
 * @param {number} value
 * @param {number} minimum
 * @param {number} maximum
 * @returns {number}
 */
export function clamp(value, minimum, maximum) {
    return Math.min(Math.max(value, minimum), maximum);
}

/**
 * @param {number} value
 * @param {number} step
 * @returns {number}
 */
export function roundToStep(value, step) {
    return Math.round(value / step) * step;
}
