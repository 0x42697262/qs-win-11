const HEX_RADIX = 16;
const CHANNEL_MAX = 255;
const HEX_PAIR_LENGTH = 2;
const RED_OFFSET = 1;
const GREEN_OFFSET = 3;
const BLUE_OFFSET = 5;

/** @typedef {{ red: number, green: number, blue: number }} Rgb */
/** @typedef {import("../catalog/tokens.mjs").ColorToken} ColorToken */

/**
 * @param {string} hex
 * @returns {Rgb}
 */
export function parseHex(hex) {
    const channel = (/** @type {number} */ offset) => Number.parseInt(hex.slice(offset, offset + HEX_PAIR_LENGTH), HEX_RADIX);
    return { red: channel(RED_OFFSET), green: channel(GREEN_OFFSET), blue: channel(BLUE_OFFSET) };
}

/**
 * @param {number} value
 * @returns {string}
 */
function toHexPair(value) {
    return Math.round(Math.min(Math.max(value, 0), CHANNEL_MAX)).toString(HEX_RADIX).padStart(HEX_PAIR_LENGTH, "0");
}

/**
 * @param {Rgb} rgb
 * @returns {string}
 */
export function formatHex(rgb) {
    return `#${toHexPair(rgb.red)}${toHexPair(rgb.green)}${toHexPair(rgb.blue)}`;
}

/**
 * @param {string} baseHex
 * @param {string} otherHex
 * @param {number} amount
 * @returns {string}
 */
export function mixHex(baseHex, otherHex, amount) {
    const base = parseHex(baseHex);
    const other = parseHex(otherHex);
    const blend = (/** @type {number} */ from, /** @type {number} */ to) => from + (to - from) * amount;
    return formatHex({ red: blend(base.red, other.red), green: blend(base.green, other.green), blue: blend(base.blue, other.blue) });
}

/**
 * @param {ColorToken} token
 * @returns {string}
 */
export function toQtColor(token) {
    return `#${toHexPair(token.alpha * CHANNEL_MAX)}${token.hex.slice(1)}`;
}
