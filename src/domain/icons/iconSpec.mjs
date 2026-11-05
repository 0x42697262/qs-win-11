import { FLUENT_FILLED_SUFFIX, FLUENT_NAME_PREFIX, FLUENT_REGULAR_SUFFIX, ICON_SPEC_SEPARATOR, IconSpecKind } from "../catalog/icons.mjs";

const HEX_RADIX = 16;

/** @typedef {{ kind: string, text: string, fontFamily: string, source: string }} ResolvedIcon */

export const EMPTY_ICON = Object.freeze({ kind: IconSpecKind.Font, text: "", fontFamily: "", source: "" });

/**
 * @param {string} spec
 * @param {boolean} filled
 * @param {Readonly<Record<string, number>>} regularMap
 * @param {Readonly<Record<string, number>>} filledMap
 * @param {{ regular: string, filled: string }} fluentFamilies
 * @returns {ResolvedIcon}
 */
export function resolveIconSpec(spec, filled, regularMap, filledMap, fluentFamilies) {
    const separator = spec.indexOf(ICON_SPEC_SEPARATOR);
    const kind = separator < 0 ? IconSpecKind.Fluent : spec.slice(0, separator);
    const rest = separator < 0 ? spec : spec.slice(separator + 1);
    if (kind === IconSpecKind.Image) {
        return { kind, text: "", fontFamily: "", source: rest };
    }
    if (kind === IconSpecKind.Font) {
        const familyEnd = rest.lastIndexOf(ICON_SPEC_SEPARATOR);
        const family = familyEnd < 0 ? "" : rest.slice(0, familyEnd);
        const codePoint = Number.parseInt(familyEnd < 0 ? rest : rest.slice(familyEnd + 1), HEX_RADIX);
        return Number.isFinite(codePoint) ? { kind, text: String.fromCodePoint(codePoint), fontFamily: family, source: "" } : EMPTY_ICON;
    }
    const filledCode = filledMap[`${FLUENT_NAME_PREFIX}${rest}${FLUENT_FILLED_SUFFIX}`];
    const regularCode = regularMap[`${FLUENT_NAME_PREFIX}${rest}${FLUENT_REGULAR_SUFFIX}`];
    const useFilled = filled && filledCode !== undefined;
    const code = useFilled ? filledCode : regularCode;
    if (code === undefined) {
        return EMPTY_ICON;
    }
    return { kind: IconSpecKind.Fluent, text: String.fromCodePoint(code), fontFamily: useFilled ? fluentFamilies.filled : fluentFamilies.regular, source: "" };
}
