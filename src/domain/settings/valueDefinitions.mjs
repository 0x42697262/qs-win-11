import { booleanSetting, colorSetting, integerSetting, numberSetting, textListSetting, textSetting } from "./definitions.mjs";
import { humanize } from "./presentation.mjs";
import { TUNING } from "../catalog/tuning.mjs";
import { ICON_DEFAULTS } from "../catalog/icons.mjs";
import { Strings } from "../catalog/strings.mjs";
import {
    ACCENT_SHADES, BLACK, CONTROL_SIZE, FONT_TRACKING, DARK_BASE, DIM_OPACITY, EASING_CURVES, ELEVATION, FONT_SIZE, FONT_WEIGHT, ICON_SIZE,
    LIGHT_BASE, MOTION_MS, PRESS_SCALE, RADIUS, SLIDE_DISTANCE, SPACING, WHITE,
} from "../catalog/tokens.mjs";
import { toQtColor } from "../theme/color.mjs";

export const ValueSection = Object.freeze({
    Sizes: "sizes",
    Motion: "motion",
    Effects: "effects",
    Colors: "colors",
    Tuning: "tuning",
    Text: "text",
    Icons: "icons",
});

export const UNBOUNDED_VALUES_KEY = "experimental.unboundedValues";

const SIZE_MAXIMUM = 4096;
const WEIGHT_MINIMUM = 1;
const WEIGHT_MAXIMUM = 1000;
const DURATION_MAXIMUM = 60000;
const CURVE_MINIMUM = -2;
const CURVE_MAXIMUM = 3;
const SCALE_MAXIMUM = 4;
const TRACKING_MINIMUM = -10;
const TRACKING_MAXIMUM = 10;
export const EASING_POINT_NAMES = Object.freeze(["x1", "y1", "x2", "y2"]);

/** @typedef {import("./definitions.mjs").SettingDefinition} SettingDefinition */

/**
 * @param {string} section
 * @param {string} path
 * @param {string} description
 */
function text(section, path, description) {
    return { key: `${section}.${path}`, section, label: humanize(path.split(".").join(" ")), description };
}

/**
 * @param {string} section
 * @param {string} path
 * @param {number} value
 * @param {number} minimum
 * @param {number} maximum
 * @param {string} description
 * @returns {SettingDefinition}
 */
function numeric(section, path, value, minimum, maximum, description) {
    const definitionText = text(section, path, description);
    return Number.isInteger(value) && Number.isInteger(minimum) && Number.isInteger(maximum)
        ? integerSetting(definitionText, value, minimum, maximum)
        : numberSetting(definitionText, value, minimum, maximum);
}

/**
 * @param {string} group
 * @param {Readonly<Record<string, number>>} values
 * @param {string} description
 * @returns {SettingDefinition[]}
 */
function sizeGroup(group, values, description) {
    return Object.entries(values).map(([name, value]) => numeric(ValueSection.Sizes, `${group}.${name}`, value, 0, SIZE_MAXIMUM, description));
}

/** @returns {SettingDefinition[]} */
function tuningDefinitions() {
    return Object.entries(TUNING).map(([name, valueSpec]) => numeric(ValueSection.Tuning, name, valueSpec.defaultValue, valueSpec.minimum, valueSpec.maximum, `${valueSpec.description} (${valueSpec.unit})`));
}

/** @returns {SettingDefinition[]} */
function sizeDefinitions() {
    return [
        ...sizeGroup("spacing", SPACING, "Spacing step in pixels, before scale."),
        ...sizeGroup("radius", RADIUS, "Corner radius in pixels, before scale."),
        ...sizeGroup("font", FONT_SIZE, "Font size in pixels, before scale."),
        ...sizeGroup("icon", ICON_SIZE, "Icon size in pixels, before scale."),
        ...sizeGroup("control", CONTROL_SIZE, "Control or surface size in pixels, before scale."),
        ...Object.entries(FONT_TRACKING).map(([name, value]) => numeric(ValueSection.Sizes, `tracking.${name}`, value, TRACKING_MINIMUM, TRACKING_MAXIMUM, "Letter spacing in pixels for this text style; negative tightens.")),
        ...Object.entries(FONT_WEIGHT).map(([name, value]) => numeric(ValueSection.Sizes, `fontWeight.${name}`, value, WEIGHT_MINIMUM, WEIGHT_MAXIMUM, "Font weight (100 thin to 900 black).")),
    ];
}

/** @returns {SettingDefinition[]} */
function motionDefinitions() {
    const durations = Object.entries(MOTION_MS).map(([name, value]) => numeric(ValueSection.Motion, `durations.${name}`, value, 0, DURATION_MAXIMUM, "Animation duration in milliseconds."));
    /** @type {SettingDefinition[]} */
    const curves = [];
    Object.entries(EASING_CURVES).forEach(([name, points]) => EASING_POINT_NAMES.forEach((pointName, index) =>
        curves.push(numeric(ValueSection.Motion, `easing.${name}.${pointName}`, points[index] ?? 0, CURVE_MINIMUM, CURVE_MAXIMUM, "Cubic bezier control point of the easing curve."))));
    const slides = Object.entries(SLIDE_DISTANCE).map(([name, value]) => numeric(ValueSection.Motion, `slideDistance.${name}`, value, 0, SIZE_MAXIMUM, "Distance a surface slides in from, in pixels."));
    return [...durations, ...curves, ...slides];
}

/** @returns {SettingDefinition[]} */
function effectDefinitions() {
    return [
        numeric(ValueSection.Effects, "pressScale", PRESS_SCALE, 0, SCALE_MAXIMUM, "Icon scale while pressed."),
        numeric(ValueSection.Effects, "dimOpacity", DIM_OPACITY, 0, 1, "Opacity of the idle dim layer."),
        ...Object.entries(ELEVATION).map(([name, value]) => numeric(ValueSection.Effects, `elevation.${name}`, value, 0, SIZE_MAXIMUM, "Flyout shadow parameter.")),
        ...Object.entries(ACCENT_SHADES).map(([name, value]) => numeric(ValueSection.Effects, `accentShades.${name}`, value, 0, 1, "How accent variants are derived from the accent color.")),
        booleanSetting(text("experimental", "unboundedValues", "Ignore minimum and maximum limits on every value. Values outside the safe range can break the shell; that is on you."), false),
    ];
}

/** @returns {SettingDefinition[]} */
function colorDefinitions() {
    /** @param {string} mode @param {Readonly<Record<string, import("../catalog/tokens.mjs").ColorToken>>} base */
    const forMode = (mode, base) => Object.entries(base).map(([name, token]) => colorSetting(text(ValueSection.Colors, `${mode}.${name}`, `${humanize(mode)} theme color as #RRGGBB or #AARRGGBB.`), toQtColor(token)));
    return [
        ...forMode("dark", DARK_BASE),
        ...forMode("light", LIGHT_BASE),
        colorSetting(text(ValueSection.Colors, "accentMixLight", "Color the accent is mixed with in dark mode."), WHITE),
        colorSetting(text(ValueSection.Colors, "accentMixDark", "Color the accent is mixed with in light mode."), BLACK),
        colorSetting(text(ValueSection.Colors, "dim", "Color of the idle dim layer."), BLACK),
    ];
}

/**
 * @param {Readonly<Record<string, unknown>>} node
 * @param {string} prefix
 * @returns {SettingDefinition[]}
 */
function textDefinitions(node, prefix) {
    /** @type {SettingDefinition[]} */
    const definitions = [];
    Object.entries(node).forEach(([name, value]) => {
        const path = prefix ? `${prefix}.${name}` : name;
        if (typeof value === "string") {
            definitions.push(textSetting(text(ValueSection.Text, path, "Text shown in the shell."), value));
        } else if (Array.isArray(value)) {
            definitions.push(textListSetting(text(ValueSection.Text, path, "List of texts shown in the shell."), value));
        } else {
            definitions.push(...textDefinitions(/** @type {Readonly<Record<string, unknown>>} */ (value), path));
        }
    });
    return definitions;
}

/** @returns {SettingDefinition[]} */
function iconDefinitions() {
    return Object.entries(ICON_DEFAULTS).map(([name, iconSpec]) => textSetting(text(ValueSection.Icons, name, "Icon as fluent:<name>, font:<family>:<hex codepoint> or image:<path or URL>."), iconSpec));
}

export const VALUE_DEFINITIONS = Object.freeze([
    ...sizeDefinitions(),
    ...motionDefinitions(),
    ...effectDefinitions(),
    ...colorDefinitions(),
    ...tuningDefinitions(),
    ...textDefinitions(Strings, ""),
    ...iconDefinitions(),
]);
