export const SettingType = Object.freeze({
    Boolean: "boolean",
    Integer: "integer",
    Number: "number",
    Text: "text",
    Enum: "enum",
    Color: "color",
    TextList: "textList",
});

/** @typedef {typeof SettingType[keyof typeof SettingType]} SettingTypeName */
/** @typedef {boolean | number | string | readonly string[]} SettingValue */
/**
 * @typedef {object} SettingDefinition
 * @property {string} key
 * @property {string} section
 * @property {SettingTypeName} type
 * @property {SettingValue} defaultValue
 * @property {string} label
 * @property {string} description
 * @property {number} [minimum]
 * @property {number} [maximum]
 * @property {readonly string[]} [options]
 * @property {RegExp} [pattern]
 */
/** @typedef {{ key: string, section: string, label: string, description: string }} DefinitionText */

/**
 * @param {DefinitionText} text
 * @param {boolean} defaultValue
 * @returns {SettingDefinition}
 */
export function booleanSetting(text, defaultValue) {
    return Object.freeze(Object.assign({}, text, { type: SettingType.Boolean, defaultValue }));
}

/**
 * @param {DefinitionText} text
 * @param {number} defaultValue
 * @param {number} minimum
 * @param {number} maximum
 * @returns {SettingDefinition}
 */
export function integerSetting(text, defaultValue, minimum, maximum) {
    return Object.freeze(Object.assign({}, text, { type: SettingType.Integer, defaultValue, minimum, maximum }));
}

/**
 * @param {DefinitionText} text
 * @param {number} defaultValue
 * @param {number} minimum
 * @param {number} maximum
 * @returns {SettingDefinition}
 */
export function numberSetting(text, defaultValue, minimum, maximum) {
    return Object.freeze(Object.assign({}, text, { type: SettingType.Number, defaultValue, minimum, maximum }));
}

/**
 * @param {DefinitionText} text
 * @param {string} defaultValue
 * @param {RegExp} [pattern]
 * @returns {SettingDefinition}
 */
export function textSetting(text, defaultValue, pattern) {
    return Object.freeze(pattern ? Object.assign({}, text, { type: SettingType.Text, defaultValue, pattern }) : Object.assign({}, text, { type: SettingType.Text, defaultValue }));
}

/**
 * @param {DefinitionText} text
 * @param {Readonly<Record<string, string>>} enumeration
 * @param {string} defaultValue
 * @returns {SettingDefinition}
 */
export function enumSetting(text, enumeration, defaultValue) {
    return Object.freeze(Object.assign({}, text, { type: SettingType.Enum, defaultValue, options: Object.freeze(Object.values(enumeration)) }));
}

/**
 * @param {DefinitionText} text
 * @param {string} defaultValue
 * @returns {SettingDefinition}
 */
export function colorSetting(text, defaultValue) {
    return Object.freeze(Object.assign({}, text, { type: SettingType.Color, defaultValue }));
}

/**
 * @param {DefinitionText} text
 * @param {readonly string[]} defaultValue
 * @param {readonly string[]} [options]
 * @returns {SettingDefinition}
 */
export function textListSetting(text, defaultValue, options) {
    const frozenDefault = Object.freeze([...defaultValue]);
    return Object.freeze(options ? Object.assign({}, text, { type: SettingType.TextList, defaultValue: frozenDefault, options }) : Object.assign({}, text, { type: SettingType.TextList, defaultValue: frozenDefault }));
}
