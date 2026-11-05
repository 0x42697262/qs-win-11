/** @typedef {{ defaultValue: number, minimum: number, maximum: number, unit: string, description: string }} ValueSpec */

export const Unit = Object.freeze({
    Milliseconds: "ms",
    Seconds: "s",
    Pixels: "px",
    Count: "count",
    Fraction: "fraction",
    Percent: "%",
    Score: "score",
    Weight: "weight",
    Factor: "factor",
});

/**
 * @param {number} defaultValue
 * @param {number} minimum
 * @param {number} maximum
 * @param {string} unit
 * @param {string} description
 * @returns {ValueSpec}
 */
export function spec(defaultValue, minimum, maximum, unit, description) {
    return Object.freeze({ defaultValue, minimum, maximum, unit, description });
}
