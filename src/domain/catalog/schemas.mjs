import { SETTINGS_SCHEMA_VERSION, SETTING_DEFINITIONS } from "./settingsSchema.mjs";
import { SHELL_DATA_SCHEMA_VERSION, SHELL_DATA_DEFINITIONS } from "./shellDataSchema.mjs";

/** @typedef {import("../settings/document.mjs").DocumentSchema} DocumentSchema */

/** @type {DocumentSchema} */
export const SETTINGS_DOCUMENT_SCHEMA = Object.freeze({
    schemaVersion: SETTINGS_SCHEMA_VERSION,
    definitions: SETTING_DEFINITIONS,
    migrations: Object.freeze([]),
});

/** @type {DocumentSchema} */
export const SHELL_DATA_DOCUMENT_SCHEMA = Object.freeze({
    schemaVersion: SHELL_DATA_SCHEMA_VERSION,
    definitions: SHELL_DATA_DEFINITIONS,
    migrations: Object.freeze([]),
});
