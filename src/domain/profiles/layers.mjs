import { COMMAND_KEY_PREFIX, IMAGE_SPEC_PREFIX, PROFILE_KEY_PREFIX, ProfileProblem, ProfileSourceKind, RELATIVE_PATH_PREFIX, TIME_RANGE_SEPARATOR } from "../catalog/profiles.mjs";
import { minutesOfDay } from "../theme/themeMode.mjs";

/** @typedef {{ onBattery?: boolean, theme?: string, between?: string }} ProfileConditions */
/** @typedef {{ description: string, activateWhen: ProfileConditions | null }} ProfileMeta */
/** @typedef {{ name: string, overrides: Readonly<Record<string, unknown>> }} ProfileLayer */
/** @typedef {{ onBattery: boolean, theme: string, minutesNow: number }} ConditionContext */

/**
 * @param {string} text
 * @returns {ProfileMeta}
 */
export function parseProfileMeta(text) {
    try {
        const parsed = JSON.parse(text);
        const conditions = parsed && typeof parsed.activateWhen === "object" && parsed.activateWhen !== null ? parsed.activateWhen : null;
        return { description: parsed && typeof parsed.description === "string" ? parsed.description : "", activateWhen: conditions };
    } catch (parseError) {
        return { description: "", activateWhen: null };
    }
}

/**
 * @param {string} range
 * @param {number} minutesNow
 * @returns {boolean}
 */
export function withinTimeRange(range, minutesNow) {
    const [start, end] = range.split(TIME_RANGE_SEPARATOR).map((part) => minutesOfDay(part.trim()));
    if (start === undefined || end === undefined || Number.isNaN(start) || Number.isNaN(end)) {
        return false;
    }
    return start <= end ? minutesNow >= start && minutesNow < end : minutesNow >= start || minutesNow < end;
}

/**
 * @param {ProfileConditions | null} conditions
 * @param {ConditionContext} context
 * @returns {boolean}
 */
export function conditionsMatch(conditions, context) {
    if (!conditions) {
        return true;
    }
    if (typeof conditions.onBattery === "boolean" && conditions.onBattery !== context.onBattery) {
        return false;
    }
    if (typeof conditions.theme === "string" && conditions.theme !== context.theme) {
        return false;
    }
    return typeof conditions.between === "string" ? withinTimeRange(conditions.between, context.minutesNow) : true;
}

/**
 * @param {Readonly<Record<string, unknown>>} overrides
 * @param {boolean} commandsTrusted
 * @returns {{ overrides: Readonly<Record<string, unknown>>, problems: { key: string, problem: string }[] }}
 */
export function filterProfileOverrides(overrides, commandsTrusted) {
    /** @type {Record<string, unknown>} */
    const kept = {};
    /** @type {{ key: string, problem: string }[]} */
    const problems = [];
    Object.keys(overrides).forEach((key) => {
        if (key.indexOf(PROFILE_KEY_PREFIX) === 0) {
            problems.push({ key, problem: ProfileProblem.NotAllowed });
        } else if (key.indexOf(COMMAND_KEY_PREFIX) === 0 && !commandsTrusted) {
            problems.push({ key, problem: ProfileProblem.CommandsNotTrusted });
        } else {
            kept[key] = overrides[key];
        }
    });
    return { overrides: Object.freeze(kept), problems };
}

/**
 * @param {Readonly<Record<string, unknown>>} overrides
 * @param {string} folder
 * @returns {Readonly<Record<string, unknown>>}
 */
export function resolveProfilePaths(overrides, folder) {
    /** @type {Record<string, unknown>} */
    const resolved = {};
    Object.keys(overrides).forEach((key) => {
        const value = overrides[key];
        if (typeof value === "string" && value.indexOf(RELATIVE_PATH_PREFIX) === 0) {
            resolved[key] = `${folder}/${value.slice(RELATIVE_PATH_PREFIX.length)}`;
        } else if (typeof value === "string" && value.indexOf(`${IMAGE_SPEC_PREFIX}${RELATIVE_PATH_PREFIX}`) === 0) {
            resolved[key] = `${IMAGE_SPEC_PREFIX}${folder}/${value.slice(IMAGE_SPEC_PREFIX.length + RELATIVE_PATH_PREFIX.length)}`;
        } else {
            resolved[key] = value;
        }
    });
    return Object.freeze(resolved);
}

/**
 * @param {readonly ProfileLayer[]} layers
 * @param {Readonly<Record<string, unknown>>} userOverrides
 * @returns {{ merged: Readonly<Record<string, unknown>>, sources: Readonly<Record<string, { kind: string, name: string }>> }}
 */
export function mergeLayers(layers, userOverrides) {
    /** @type {Record<string, unknown>} */
    const merged = {};
    /** @type {Record<string, { kind: string, name: string }>} */
    const sources = {};
    layers.forEach((layer) => Object.keys(layer.overrides).forEach((key) => {
        merged[key] = layer.overrides[key];
        sources[key] = { kind: ProfileSourceKind.Profile, name: layer.name };
    }));
    Object.keys(userOverrides).forEach((key) => {
        merged[key] = userOverrides[key];
        sources[key] = { kind: ProfileSourceKind.User, name: "" };
    });
    return { merged: Object.freeze(merged), sources: Object.freeze(sources) };
}

/**
 * @param {Readonly<Record<string, unknown>>} overrides
 * @param {readonly string[]} sections
 * @returns {Readonly<Record<string, unknown>>}
 */
export function overridesForSections(overrides, sections) {
    /** @type {Record<string, unknown>} */
    const picked = {};
    Object.keys(overrides).forEach((key) => {
        if (key.indexOf(PROFILE_KEY_PREFIX) !== 0 && sections.some((section) => key.indexOf(`${section}.`) === 0)) {
            picked[key] = overrides[key];
        }
    });
    return Object.freeze(picked);
}
