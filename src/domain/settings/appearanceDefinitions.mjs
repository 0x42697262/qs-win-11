import { enumSetting, integerSetting, numberSetting } from "./definitions.mjs";
import { humanize } from "./presentation.mjs";
import { APPEARANCE_SECTION_NAME, AppearanceStyle, DEFAULT_LEVEL, INHERIT, KNOBS, LEVEL_BUNDLES, LEVEL_NAMES, SAME_AS_AC, SAVER_POLLING_FACTOR } from "../catalog/appearance.mjs";

export const APPEARANCE_SECTION = APPEARANCE_SECTION_NAME;
const MAXIMUM_POLLING_FACTOR = 100;

/** @typedef {import("./definitions.mjs").SettingDefinition} SettingDefinition */

/**
 * @param {string} path
 * @param {string} label
 * @param {string} description
 */
function text(path, label, description) {
    return { key: `${APPEARANCE_SECTION}.${path}`, section: APPEARANCE_SECTION, label, description };
}

/**
 * @param {readonly string[]} options
 * @returns {Readonly<Record<string, string>>}
 */
function enumeration(options) {
    /** @type {Record<string, string>} */
    const result = {};
    options.forEach((option) => { result[option] = option; });
    return result;
}

/** @returns {SettingDefinition[]} */
function knobOverrides() {
    return Object.entries(KNOBS).map(([knob, spec]) => enumSetting(
        text(`override.${knob}`, `${humanize(knob)}`, `${spec.description} "inherit" follows the level and style. Cost: ${spec.cost}.`),
        enumeration([INHERIT].concat(spec.options)),
        INHERIT,
    ));
}

/** @returns {SettingDefinition[]} */
function levelBundles() {
    /** @type {SettingDefinition[]} */
    const definitions = [];
    LEVEL_NAMES.forEach((levelName) => {
        const bundle = LEVEL_BUNDLES[levelName] ?? {};
        Object.entries(KNOBS).forEach(([knob, spec]) => definitions.push(enumSetting(
            text(`levels.${levelName}.${knob}`, `${humanize(levelName)}: ${humanize(knob)}`, `What the ${humanize(levelName)} level allows for ${humanize(knob)}.`),
            enumeration(spec.options),
            bundle[knob] ?? spec.options[0] ?? "",
        )));
    });
    return definitions;
}

export const APPEARANCE_DEFINITIONS = Object.freeze([
    enumSetting(text("style", "Style", "Fluent depth and materials, or the flat look."), AppearanceStyle, AppearanceStyle.Fluent),
    integerSetting(text("level", "Effects level", "0 battery saver, 1 light, 2 balanced, 3 rich, 4 maximum. Caps what every effect may cost."), DEFAULT_LEVEL, 0, LEVEL_NAMES.length - 1),
    integerSetting(text("levelOnBattery", "Effects level on battery", "Level used while on battery. -1 keeps the normal level."), SAME_AS_AC, SAME_AS_AC, LEVEL_NAMES.length - 1),
    numberSetting(text("saverPollingFactor", "Saver polling factor", "Polling intervals are multiplied by this when background work is in saver mode."), SAVER_POLLING_FACTOR, 1, MAXIMUM_POLLING_FACTOR),
    ...knobOverrides(),
    ...levelBundles(),
]);
