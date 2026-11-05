import { ResolvedThemeMode } from "../catalog/enums.mjs";
import { TRANSLUCENT_SURFACE_KEYS } from "../catalog/tokens.mjs";
import { mixHex } from "./color.mjs";

const OPAQUE_ALPHA = "ff";
export const OPAQUE_SUFFIX = "Opaque";
const HEX_PAIR = 2;
const ARGB_LENGTH = 9;
const CHANNEL_MAX = 255;
const HEX_RADIX = 16;
const TEXT_KEYS = Object.freeze(["textPrimary", "textSecondary", "textTertiary"]);

/** @typedef {Readonly<Record<string, string>>} Palette */
/** @typedef {{ darkModeMixWithWhite: number, lightModeMixWithBlack: number, hoverAlpha: number, pressedAlpha: number, disabledAlpha: number }} AccentShades */
/** @typedef {{ dark: Readonly<Record<string, string>>, light: Readonly<Record<string, string>>, accentMixLight: string, accentMixDark: string }} ColorSettings */

/**
 * @param {string} color
 * @returns {string}
 */
function rgbPart(color) {
    return color.length === ARGB_LENGTH ? `#${color.slice(1 + HEX_PAIR)}` : color;
}

/**
 * @param {string} rgb
 * @param {number} alpha
 * @returns {string}
 */
function withAlpha(rgb, alpha) {
    const alphaHex = Math.round(Math.min(Math.max(alpha, 0), 1) * CHANNEL_MAX).toString(HEX_RADIX).padStart(HEX_PAIR, "0");
    return `#${alphaHex}${rgb.slice(1)}`;
}

/**
 * @param {string} resolvedMode
 * @param {string} accentHex
 * @param {boolean} transparency
 * @param {ColorSettings} colors
 * @param {AccentShades} shades
 * @param {number} [textContrast]
 * @returns {Palette}
 */
export function buildPalette(resolvedMode, accentHex, transparency, colors, shades, textContrast = 0) {
    const isDark = resolvedMode === ResolvedThemeMode.Dark;
    const base = isDark ? colors.dark : colors.light;
    /** @type {Record<string, string>} */
    const palette = {};
    Object.keys(base).forEach((key) => {
        const color = base[key] ?? "";
        const opaque = `#${OPAQUE_ALPHA}${rgbPart(color).slice(1)}`;
        palette[key] = !transparency && TRANSLUCENT_SURFACE_KEYS.includes(key) ? opaque : color;
        if (TRANSLUCENT_SURFACE_KEYS.includes(key)) {
            palette[`${key}${OPAQUE_SUFFIX}`] = opaque;
        }
    });
    TEXT_KEYS.forEach((key) => {
        const color = palette[key];
        if (color && color.length === ARGB_LENGTH && textContrast !== 0) {
            const alpha = Number.parseInt(color.slice(1, 1 + HEX_PAIR), HEX_RADIX) / CHANNEL_MAX;
            palette[key] = withAlpha(`#${color.slice(1 + HEX_PAIR)}`, alpha * (1 + textContrast));
        }
    });
    const accent = rgbPart(accentHex);
    const accentForMode = isDark
        ? mixHex(accent, rgbPart(colors.accentMixLight), shades.darkModeMixWithWhite)
        : mixHex(accent, rgbPart(colors.accentMixDark), shades.lightModeMixWithBlack);
    palette.accent = withAlpha(accentForMode, 1);
    palette.accentHover = withAlpha(accentForMode, shades.hoverAlpha);
    palette.accentPressed = withAlpha(accentForMode, shades.pressedAlpha);
    palette.accentDisabled = withAlpha(accentForMode, shades.disabledAlpha);
    palette.accentText = palette.accent;
    palette.textOnAccent = withAlpha(rgbPart(isDark ? colors.accentMixDark : colors.accentMixLight), 1);
    return Object.freeze(palette);
}
