import { flattenValues } from "../settings/document.mjs";

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
