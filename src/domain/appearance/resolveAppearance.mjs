import { INHERIT, KNOBS, LEVEL_BUNDLES, LEVEL_NAMES, SAME_AS_AC, STYLE_VALUES } from "../catalog/appearance.mjs";

export const KnobSource = Object.freeze({ Level: "level", Style: "style", Custom: "custom", Limited: "limited" });

/** @typedef {{ value: string, source: string, requested: string }} ResolvedKnob */
/** @typedef {{ levelIndex: number, levelName: string, knobs: Readonly<Record<string, ResolvedKnob>> }} Appearance */
/**
 * @typedef {object} AppearanceSettings
 * @property {string} style
 * @property {number} level
 * @property {number} levelOnBattery
 * @property {Readonly<Record<string, string>>} override
 * @property {Readonly<Record<string, Readonly<Record<string, string>>>>} levels
 */

/**
 * @param {string} knob
 * @param {string} value
 * @returns {number}
 */
export function knobCost(knob, value) {
    const spec = KNOBS[knob];
    return spec ? spec.options.indexOf(value) : -1;
}

/**
 * @param {AppearanceSettings} settings
 * @param {boolean} onBattery
 * @returns {number}
 */
export function activeLevel(settings, onBattery) {
    const level = onBattery && settings.levelOnBattery !== SAME_AS_AC ? settings.levelOnBattery : settings.level;
    return Math.max(0, Math.min(LEVEL_NAMES.length - 1, level));
}

/**
 * @param {AppearanceSettings} settings
 * @param {boolean} onBattery
 * @returns {Appearance}
 */
export function resolveAppearance(settings, onBattery) {
    const levelIndex = activeLevel(settings, onBattery);
    const levelName = LEVEL_NAMES[levelIndex] ?? "";
    const bundle = (settings.levels && settings.levels[levelName]) || LEVEL_BUNDLES[levelName] || {};
    const style = STYLE_VALUES[settings.style] ?? {};
    /** @type {Record<string, ResolvedKnob>} */
    const knobs = {};
    Object.keys(KNOBS).forEach((knob) => {
        const budget = bundle[knob] ?? KNOBS[knob]?.options[0] ?? "";
        const override = settings.override ? settings.override[knob] : undefined;
        const custom = override !== undefined && override !== INHERIT ? override : undefined;
        const styled = style[knob];
        const requested = custom ?? styled ?? budget;
        const source = custom !== undefined ? KnobSource.Custom : styled !== undefined ? KnobSource.Style : KnobSource.Level;
        const withinBudget = knobCost(knob, requested) <= knobCost(knob, budget);
        knobs[knob] = withinBudget ? { value: requested, source, requested } : { value: budget, source: KnobSource.Limited, requested };
    });
    return { levelIndex, levelName, knobs: Object.freeze(knobs) };
}
