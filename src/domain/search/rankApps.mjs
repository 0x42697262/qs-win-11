/** @typedef {{ id: string, name: string, genericName: string, keywords: readonly string[] }} SearchableApp */
/** @typedef {{ app: SearchableApp, score: number }} RankedApp */
import { MatchScore } from "../catalog/searchScores.mjs";

export { MatchScore };

const WORD_BOUNDARY = /[\s\-_.]+/;

/**
 * @param {SearchableApp} app
 * @param {string} query
 * @returns {number}
 */
export function scoreApp(app, query) {
    const needle = query.trim().toLowerCase();
    if (needle === "") {
        return MatchScore.None;
    }
    const name = app.name.toLowerCase();
    if (name === needle) {
        return MatchScore.ExactName;
    }
    if (name.startsWith(needle)) {
        return MatchScore.NamePrefix;
    }
    if (name.split(WORD_BOUNDARY).some((word) => word.startsWith(needle))) {
        return MatchScore.WordPrefix;
    }
    if (name.includes(needle)) {
        return MatchScore.NameContains;
    }
    if (app.genericName.toLowerCase().includes(needle)) {
        return MatchScore.GenericName;
    }
    if (app.keywords.some((keyword) => keyword.toLowerCase().startsWith(needle)) || app.id.toLowerCase().includes(needle)) {
        return MatchScore.Keyword;
    }
    return MatchScore.None;
}

/**
 * @param {readonly SearchableApp[]} apps
 * @param {string} query
 * @param {number} limit
 * @returns {RankedApp[]}
 */
export function rankApps(apps, query, limit) {
    return apps
        .map((app) => ({ app, score: scoreApp(app, query) }))
        .filter((ranked) => ranked.score > MatchScore.None)
        .sort((left, right) => right.score - left.score || left.app.name.localeCompare(right.app.name))
        .slice(0, limit);
}

const OTHER_GROUP = "#";

/**
 * @param {readonly { name: string }[]} apps
 * @returns {{ letter: string, startIndex: number }[]}
 */
export function alphabetGroups(apps) {
    /** @type {{ letter: string, startIndex: number }[]} */
    const groups = [];
    apps.forEach((app, index) => {
        const first = app.name.charAt(0).toUpperCase();
        const letter = /[A-Z]/.test(first) ? first : OTHER_GROUP;
        if (groups.length === 0 || groups[groups.length - 1]?.letter !== letter) {
            groups.push({ letter, startIndex: index });
        }
    });
    return groups;
}
