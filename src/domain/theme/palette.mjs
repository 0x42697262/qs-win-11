import { ResolvedThemeMode } from "../catalog/enums.mjs";
import { ACCENT_SHADES, BLACK, DARK_BASE, LIGHT_BASE, TRANSLUCENT_SURFACE_KEYS, WHITE } from "../catalog/tokens.mjs";
import { mixHex, toQtColor } from "./color.mjs";

/** @typedef {keyof typeof DARK_BASE | "accent" | "accentHover" | "accentPressed" | "accentDisabled" | "accentText" | "textOnAccent"} PaletteKey */
/** @typedef {Readonly<Record<PaletteKey, string>>} Palette */

/**
 * @param {string} resolvedMode
 * @param {string} accentHex
 * @param {boolean} transparency
 * @returns {Palette}
 */
export function buildPalette(resolvedMode, accentHex, transparency) {
    const isDark = resolvedMode === ResolvedThemeMode.Dark;
    const base = isDark ? DARK_BASE : LIGHT_BASE;
    /** @type {Record<string, string>} */
    const palette = {};
    for (const [key, token] of Object.entries(base)) {
        const opaque = !transparency && TRANSLUCENT_SURFACE_KEYS.includes(key);
        palette[key] = toQtColor(opaque ? { hex: token.hex, alpha: 1 } : token);
    }
    const accentHexForMode = isDark
        ? mixHex(accentHex, WHITE, ACCENT_SHADES.darkModeMixWithWhite)
        : mixHex(accentHex, BLACK, ACCENT_SHADES.lightModeMixWithBlack);
    palette.accent = toQtColor({ hex: accentHexForMode, alpha: 1 });
    palette.accentHover = toQtColor({ hex: accentHexForMode, alpha: ACCENT_SHADES.hoverAlpha });
    palette.accentPressed = toQtColor({ hex: accentHexForMode, alpha: ACCENT_SHADES.pressedAlpha });
    palette.accentDisabled = toQtColor({ hex: accentHexForMode, alpha: ACCENT_SHADES.disabledAlpha });
    palette.accentText = palette.accent;
    palette.textOnAccent = toQtColor({ hex: isDark ? BLACK : WHITE, alpha: 1 });
    return /** @type {Palette} */ (Object.freeze(palette));
}
