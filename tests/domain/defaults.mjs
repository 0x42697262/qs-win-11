import { resolveDocument } from "../../src/domain/settings/document.mjs";
import { SETTINGS_DOCUMENT_SCHEMA } from "../../src/domain/catalog/schemas.mjs";

/** @type {any} */
export const DEFAULTS = resolveDocument("", SETTINGS_DOCUMENT_SCHEMA).values;
export const TIME_TEXT = DEFAULTS.text.time;
