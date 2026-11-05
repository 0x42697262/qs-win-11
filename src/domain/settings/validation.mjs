import { SettingType } from "./definitions.mjs";

const HEX_COLOR_PATTERN = /^#[0-9a-fA-F]{6}$/;

export const ValidationProblem = Object.freeze({
    WrongType: "wrongType",
    OutOfRange: "outOfRange",
    NotAnOption: "notAnOption",
    PatternMismatch: "patternMismatch",
    UnknownKey: "unknownKey",
    UnreadableDocument: "unreadableDocument",
    NewerSchemaVersion: "newerSchemaVersion",
});

/** @typedef {import("./definitions.mjs").SettingDefinition} SettingDefinition */
/** @typedef {import("./definitions.mjs").SettingValue} SettingValue */
/** @typedef {typeof ValidationProblem[keyof typeof ValidationProblem]} ValidationProblemName */
/** @typedef {{ valid: true, value: SettingValue } | { valid: false, problem: ValidationProblemName }} ValidationResult */

/**
 * @param {SettingDefinition} definition
 * @param {number} value
 * @returns {ValidationResult}
 */
function validateRange(definition, value) {
    const belowMinimum = definition.minimum !== undefined && value < definition.minimum;
    const aboveMaximum = definition.maximum !== undefined && value > definition.maximum;
    return belowMinimum || aboveMaximum ? { valid: false, problem: ValidationProblem.OutOfRange } : { valid: true, value };
}

/**
 * @param {SettingDefinition} definition
 * @param {unknown} value
 * @returns {ValidationResult}
 */
export function validateSettingValue(definition, value) {
    const wrongType = /** @type {ValidationResult} */ ({ valid: false, problem: ValidationProblem.WrongType });
    switch (definition.type) {
    case SettingType.Boolean:
        return typeof value === "boolean" ? { valid: true, value } : wrongType;
    case SettingType.Integer:
        return typeof value === "number" && Number.isInteger(value) ? validateRange(definition, value) : wrongType;
    case SettingType.Number:
        return typeof value === "number" && Number.isFinite(value) ? validateRange(definition, value) : wrongType;
    case SettingType.Text:
        if (typeof value !== "string") {
            return wrongType;
        }
        return definition.pattern && !definition.pattern.test(value) ? { valid: false, problem: ValidationProblem.PatternMismatch } : { valid: true, value };
    case SettingType.Enum:
        if (typeof value !== "string") {
            return wrongType;
        }
        return definition.options?.includes(value) ? { valid: true, value } : { valid: false, problem: ValidationProblem.NotAnOption };
    case SettingType.Color:
        if (typeof value !== "string") {
            return wrongType;
        }
        return HEX_COLOR_PATTERN.test(value) ? { valid: true, value: value.toLowerCase() } : { valid: false, problem: ValidationProblem.PatternMismatch };
    case SettingType.TextList: {
        if (!Array.isArray(value) || !value.every((item) => typeof item === "string")) {
            return wrongType;
        }
        const options = definition.options;
        if (options && !value.every((item) => options.includes(item))) {
            return { valid: false, problem: ValidationProblem.NotAnOption };
        }
        return { valid: true, value: Object.freeze([...value]) };
    }
    default:
        return wrongType;
    }
}

/**
 * @param {SettingValue} left
 * @param {SettingValue} right
 * @returns {boolean}
 */
export function settingValuesEqual(left, right) {
    if (Array.isArray(left) && Array.isArray(right)) {
        return left.length === right.length && left.every((item, index) => item === right[index]);
    }
    return left === right;
}
