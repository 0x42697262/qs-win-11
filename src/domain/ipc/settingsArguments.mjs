import { flattenValues } from "../settings/document.mjs";
import { SettingType } from "../settings/definitions.mjs";

const LIST_SEPARATOR = ",";

/**
 * @param {string} text
 * @returns {unknown}
 */
export function parseValueArgument(text) {
    try {
        return JSON.parse(text);
    } catch (parseError) {
        return text;
    }
}

/**
 * @param {Readonly<Record<string, unknown>>} values
 * @param {string} key
 * @returns {string}
 */
export function formatValueAt(values, key) {
    const flat = flattenValues(Object.assign({}, values));
    return key in flat ? JSON.stringify(flat[key]) : "";
}

/**
 * @param {readonly { key: string, defaultValue: unknown }[]} definitions
 * @param {string} key
 * @returns {unknown}
 */
export function defaultValueFor(definitions, key) {
    const definition = definitions.find((candidate) => candidate.key === key);
    return definition ? definition.defaultValue : undefined;
}

/**
 * @param {readonly { key: string, type: string }[]} definitions
 * @param {string} key
 * @param {string} text
 * @returns {unknown}
 */
export function parseValueForKey(definitions, key, text) {
    const parsed = parseValueArgument(text);
    const definition = definitions.find((candidate) => candidate.key === key);
    if (definition && definition.type === SettingType.TextList && typeof parsed === "string") {
        return parsed.split(LIST_SEPARATOR).map((item) => item.trim()).filter((item) => item !== "");
    }
    return parsed;
}
