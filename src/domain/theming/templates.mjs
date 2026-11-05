import { formatHex, mixHex, parseHex } from "../theme/color.mjs";
import { BLACK } from "../catalog/tokens.mjs";

/** @typedef {Readonly<Record<string, string>>} TemplateScheme */
/** @typedef {{ text: string, unknown: string[] }} RenderResult */

const ARGB_LENGTH = 9;
const RGB_LENGTH = 7;
const HEX_PAIR = 2;
const HEX_RADIX = 16;
const CHANNEL_MAX = 255;
const FLOAT_DIGITS = 4;
const PLACEHOLDER = /\{\{\s*([A-Za-z][\w]*)(?:\.([A-Za-z][\w]*))?\s*\}\}/g;

export const ValueFormat = Object.freeze({
    Hex: "hex",
    Strip: "strip",
    Rgb: "rgb",
    RgbCss: "rgbCss",
    Red: "red",
    Green: "green",
    Blue: "blue",
    Float: "float",
    Argb: "argb",
});

const SCHEME_SOURCES = Object.freeze({
    background: "micaBase",
    surface: "flyoutBackground",
    surfaceAlt: "cardBackground",
    foreground: "textPrimary",
    foregroundMuted: "textSecondary",
    foregroundSubtle: "textTertiary",
    foregroundDisabled: "textDisabled",
    border: "surfaceStroke",
    divider: "divider",
    accent: "accent",
    accentForeground: "textOnAccent",
    success: "success",
    warning: "caution",
    error: "critical",
    attention: "attention",
    black: "terminalBlack",
    red: "terminalRed",
    green: "terminalGreen",
    yellow: "terminalYellow",
    blue: "terminalBlue",
    magenta: "terminalMagenta",
    cyan: "terminalCyan",
    white: "terminalWhite",
    brightBlack: "terminalBrightBlack",
    brightRed: "terminalBrightRed",
    brightGreen: "terminalBrightGreen",
    brightYellow: "terminalBrightYellow",
    brightBlue: "terminalBrightBlue",
    brightMagenta: "terminalBrightMagenta",
    brightCyan: "terminalBrightCyan",
    brightWhite: "terminalBrightWhite",
});

/**
 * @param {string} color
 * @param {string} backgroundHex
 * @returns {string}
 */
export function flattenOver(color, backgroundHex) {
    if (color.length === RGB_LENGTH) {
        return color.toLowerCase();
    }
    if (color.length !== ARGB_LENGTH) {
        return backgroundHex;
    }
    const alpha = Number.parseInt(color.slice(1, 1 + HEX_PAIR), HEX_RADIX) / CHANNEL_MAX;
    return mixHex(backgroundHex, `#${color.slice(1 + HEX_PAIR)}`, alpha);
}

/**
 * @param {Readonly<Record<string, string>>} palette
 * @param {number} selectionMix
 * @returns {TemplateScheme}
 */
export function buildTemplateScheme(palette, selectionMix) {
    const background = flattenOver(palette.micaBase ?? BLACK, BLACK);
    /** @type {Record<string, string>} */
    const scheme = {};
    Object.keys(SCHEME_SOURCES).forEach(name => {
        const source = /** @type {Record<string, string>} */ (SCHEME_SOURCES)[name];
        scheme[name] = flattenOver(palette[source] ?? background, background);
    });
    scheme.selection = mixHex(background, scheme.accent, selectionMix);
    scheme.cursor = scheme.accent;
    return Object.freeze(scheme);
}

/**
 * @param {string} hex
 * @param {string} format
 * @returns {string | null}
 */
export function formatValue(hex, format) {
    const rgb = parseHex(hex);
    switch (format) {
    case "":
    case ValueFormat.Hex:
        return formatHex(rgb);
    case ValueFormat.Strip:
        return formatHex(rgb).slice(1);
    case ValueFormat.Rgb:
        return `${rgb.red}, ${rgb.green}, ${rgb.blue}`;
    case ValueFormat.RgbCss:
        return `rgb(${rgb.red}, ${rgb.green}, ${rgb.blue})`;
    case ValueFormat.Red:
        return String(rgb.red);
    case ValueFormat.Green:
        return String(rgb.green);
    case ValueFormat.Blue:
        return String(rgb.blue);
    case ValueFormat.Float:
        return [rgb.red, rgb.green, rgb.blue].map(channel => (channel / CHANNEL_MAX).toFixed(FLOAT_DIGITS)).join(" ");
    case ValueFormat.Argb:
        return `#ff${formatHex(rgb).slice(1)}`;
    default:
        return null;
    }
}

/**
 * @param {string} template
 * @param {TemplateScheme} scheme
 * @param {Readonly<Record<string, string>>} words
 * @returns {RenderResult}
 */
export function renderTemplate(template, scheme, words) {
    /** @type {string[]} */
    const unknown = [];
    const text = template.replace(PLACEHOLDER, (whole, name, format) => {
        if (name in words && !format) {
            return words[name];
        }
        const color = scheme[name];
        const value = color ? formatValue(color, format ?? "") : null;
        if (value === null) {
            unknown.push(whole);
            return whole;
        }
        return value;
    });
    return { text, unknown };
}
