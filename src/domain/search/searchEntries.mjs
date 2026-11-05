/** @typedef {import("./calculator.mjs").Calculation} Calculation */
/** @typedef {{ key: string, label: string, description: string, section: string }} SettingDefinition */
/** @typedef {{ kind: string, id: string, title: string, subtitle: string, calculation: Calculation | null }} SearchEntry */

export const SearchEntryKind = Object.freeze({
    Calculation: "calculation",
    App: "app",
    Setting: "setting",
});

const MATCH_RANK = Object.freeze({ LabelStart: 0, WordStart: 1, Label: 2, Elsewhere: 3, None: -1 });

/**
 * @param {SettingDefinition} definition
 * @param {string} needle
 * @returns {number}
 */
function settingRank(definition, needle) {
    const label = definition.label.toLowerCase();
    if (label.indexOf(needle) === 0) {
        return MATCH_RANK.LabelStart;
    }
    if (label.split(/[\s.:/-]+/).some(word => word.indexOf(needle) === 0)) {
        return MATCH_RANK.WordStart;
    }
    if (label.indexOf(needle) >= 0) {
        return MATCH_RANK.Label;
    }
    const haystack = `${label} ${definition.description} ${definition.key} ${definition.section}`.toLowerCase();
    return needle.split(/\s+/).every(word => haystack.indexOf(word) >= 0) ? MATCH_RANK.Elsewhere : MATCH_RANK.None;
}

/**
 * @param {readonly SettingDefinition[]} definitions
 * @param {string} query
 * @param {number} limit
 * @param {number} minimumLength
 * @returns {SettingDefinition[]}
 */
export function rankSettings(definitions, query, limit, minimumLength) {
    const needle = query.trim().toLowerCase();
    if (needle.length < minimumLength || limit <= 0) {
        return [];
    }
    return definitions
        .map((definition, order) => ({ definition, order, rank: settingRank(definition, needle) }))
        .filter(scored => scored.rank !== MATCH_RANK.None)
        .sort((left, right) => left.rank - right.rank || left.definition.label.length - right.definition.label.length || left.order - right.order)
        .slice(0, limit)
        .map(scored => scored.definition);
}

/**
 * @param {Calculation | null} calculation
 * @param {readonly { id: string, name: string }[]} apps
 * @param {readonly SettingDefinition[]} settings
 * @returns {SearchEntry[]}
 */
export function buildSearchEntries(calculation, apps, settings) {
    /** @type {SearchEntry[]} */
    const entries = [];
    if (calculation) {
        entries.push({ kind: SearchEntryKind.Calculation, id: calculation.expression, title: calculation.display, subtitle: calculation.expression, calculation });
    }
    apps.forEach(app => entries.push({ kind: SearchEntryKind.App, id: app.id, title: app.name, subtitle: "", calculation: null }));
    settings.forEach(setting => entries.push({ kind: SearchEntryKind.Setting, id: setting.key, title: setting.label, subtitle: setting.section, calculation: null }));
    return entries;
}
