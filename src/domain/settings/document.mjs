import { ValidationProblem, settingValuesEqual, validateSettingValue } from "./validation.mjs";

/** @typedef {import("./definitions.mjs").SettingDefinition} SettingDefinition */
/** @typedef {import("./definitions.mjs").SettingValue} SettingValue */
/** @typedef {import("./validation.mjs").ValidationProblemName} ValidationProblemName */
/** @typedef {{ key: string, problem: ValidationProblemName, value: string }} DocumentProblem */
/** @typedef {{ fromVersion: number, migrate: (values: Record<string, unknown>) => Record<string, unknown> }} Migration */
/** @typedef {{ schemaVersion: number, definitions: readonly SettingDefinition[], migrations: readonly Migration[] }} DocumentSchema */
/** @typedef {{ values: Readonly<Record<string, unknown>>, overrides: Readonly<Record<string, unknown>>, problems: readonly DocumentProblem[], migratedFrom: number }} ResolvedDocument */

const VALUES_FIELD = "values";
const VERSION_FIELD = "schemaVersion";
const KEY_SEPARATOR = ".";
const DOCUMENT_INDENT = 4;
const ROOT_KEY = "";
const UNBOUNDED_KEY = "experimental.unboundedValues";

/**
 * @param {unknown} candidate
 * @returns {candidate is Record<string, unknown>}
 */
function isPlainObject(candidate) {
    return typeof candidate === "object" && candidate !== null && !Array.isArray(candidate);
}

/**
 * @param {Record<string, unknown>} nested
 * @param {string} prefix
 * @returns {Record<string, unknown>}
 */
export function flattenValues(nested, prefix = "") {
    /** @type {Record<string, unknown>} */
    const flat = {};
    for (const [name, value] of Object.entries(nested)) {
        const key = prefix ? `${prefix}${KEY_SEPARATOR}${name}` : name;
        if (isPlainObject(value)) {
            Object.assign(flat, flattenValues(value, key));
        } else {
            flat[key] = value;
        }
    }
    return flat;
}

/**
 * @param {Readonly<Record<string, unknown>>} flat
 * @returns {Record<string, unknown>}
 */
export function nestValues(flat) {
    /** @type {Record<string, unknown>} */
    const nested = {};
    for (const [key, value] of Object.entries(flat)) {
        const path = key.split(KEY_SEPARATOR);
        const leaf = path.pop() ?? key;
        let cursor = nested;
        for (const segment of path) {
            const next = cursor[segment];
            if (!isPlainObject(next)) {
                cursor[segment] = {};
            }
            cursor = /** @type {Record<string, unknown>} */ (cursor[segment]);
        }
        cursor[leaf] = value;
    }
    return nested;
}

/**
 * @param {unknown} value
 * @returns {unknown}
 */
function deepFreeze(value) {
    if (isPlainObject(value) || Array.isArray(value)) {
        Object.values(value).forEach(deepFreeze);
        Object.freeze(value);
    }
    return value;
}

/**
 * @param {string} text
 * @returns {{ parsed: Record<string, unknown>, readable: boolean }}
 */
function parseDocument(text) {
    if (text.trim() === "") {
        return { parsed: {}, readable: true };
    }
    try {
        const parsed = JSON.parse(text);
        return isPlainObject(parsed) ? { parsed, readable: true } : { parsed: {}, readable: false };
    } catch (parseError) {
        return { parsed: {}, readable: false };
    }
}

/**
 * @param {Record<string, unknown>} flat
 * @param {number} fromVersion
 * @param {DocumentSchema} schema
 * @returns {Record<string, unknown>}
 */
function migrate(flat, fromVersion, schema) {
    return schema.migrations
        .filter((migration) => migration.fromVersion >= fromVersion && migration.fromVersion < schema.schemaVersion)
        .sort((left, right) => left.fromVersion - right.fromVersion)
        .reduce((values, migration) => migration.migrate(values), flat);
}

/**
 * @param {string} text
 * @param {DocumentSchema} schema
 * @returns {ResolvedDocument}
 */
export function resolveDocument(text, schema) {
    const { parsed, readable } = parseDocument(text);
    /** @type {DocumentProblem[]} */
    const problems = readable ? [] : [{ key: ROOT_KEY, problem: ValidationProblem.UnreadableDocument, value: "" }];
    const storedVersion = typeof parsed[VERSION_FIELD] === "number" ? parsed[VERSION_FIELD] : schema.schemaVersion;
    if (storedVersion > schema.schemaVersion) {
        problems.push({ key: VERSION_FIELD, problem: ValidationProblem.NewerSchemaVersion, value: String(storedVersion) });
    }
    const storedValues = isPlainObject(parsed[VALUES_FIELD]) ? flattenValues(parsed[VALUES_FIELD]) : {};
    const overrides = migrate(storedValues, storedVersion, schema);
    const definitionsByKey = new Map(schema.definitions.map((definition) => [definition.key, definition]));
    const unbounded = overrides[UNBOUNDED_KEY] === true;
    /** @type {Record<string, unknown>} */
    const values = {};
    /** @type {Record<string, unknown>} */
    const validOverrides = {};
    for (const definition of schema.definitions) {
        values[definition.key] = definition.defaultValue;
    }
    for (const [key, value] of Object.entries(overrides)) {
        const definition = definitionsByKey.get(key);
        if (!definition) {
            problems.push({ key, problem: ValidationProblem.UnknownKey, value: JSON.stringify(value) });
            continue;
        }
        const result = validateSettingValue(definition, value, unbounded);
        if (result.valid) {
            values[key] = result.value;
            validOverrides[key] = result.value;
        } else {
            problems.push({ key, problem: result.problem, value: JSON.stringify(value) });
        }
    }
    return {
        values: /** @type {Readonly<Record<string, unknown>>} */ (deepFreeze(nestValues(values))),
        overrides: Object.freeze(validOverrides),
        problems: Object.freeze(problems),
        migratedFrom: storedVersion < schema.schemaVersion ? storedVersion : schema.schemaVersion,
    };
}

/**
 * @param {Readonly<Record<string, unknown>>} overrides
 * @param {string} key
 * @param {unknown} value
 * @param {DocumentSchema} schema
 * @returns {{ accepted: true, overrides: Readonly<Record<string, unknown>> } | { accepted: false, problem: ValidationProblemName }}
 */
export function applyOverride(overrides, key, value, schema) {
    const definition = schema.definitions.find((candidate) => candidate.key === key);
    if (!definition) {
        return { accepted: false, problem: ValidationProblem.UnknownKey };
    }
    const result = validateSettingValue(definition, value, overrides[UNBOUNDED_KEY] === true);
    if (!result.valid) {
        return { accepted: false, problem: result.problem };
    }
    /** @type {Record<string, unknown>} */
    const next = Object.assign({}, overrides);
    if (settingValuesEqual(result.value, definition.defaultValue)) {
        delete next[key];
    } else {
        next[key] = result.value;
    }
    return { accepted: true, overrides: Object.freeze(next) };
}

/**
 * @param {Readonly<Record<string, unknown>>} overrides
 * @param {DocumentSchema} schema
 * @returns {string}
 */
export function serializeDocument(overrides, schema) {
    return `${JSON.stringify({ [VERSION_FIELD]: schema.schemaVersion, [VALUES_FIELD]: nestValues(overrides) }, null, DOCUMENT_INDENT)}\n`;
}
