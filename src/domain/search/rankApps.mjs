/** @typedef {{ id: string, name: string, genericName: string, keywords: readonly string[] }} SearchableApp */
/** @typedef {{ app: SearchableApp, score: number }} RankedApp */
/** @typedef {{ scoreExactName: number, scoreNamePrefix: number, scoreWordPrefix: number, scoreNameContains: number, scoreGenericName: number, scoreKeyword: number }} MatchScores */

const NO_MATCH = 0;

const WORD_BOUNDARY = /[\s\-_.]+/;

/**
 * @param {SearchableApp} app
 * @param {string} query
 * @param {MatchScores} scores
 * @returns {number}
 */
export function scoreApp(app, query, scores) {
    const needle = query.trim().toLowerCase();
    if (needle === "") {
        return NO_MATCH;
    }
    const name = app.name.toLowerCase();
    if (name === needle) {
        return scores.scoreExactName;
    }
    if (name.startsWith(needle)) {
        return scores.scoreNamePrefix;
    }
    if (name.split(WORD_BOUNDARY).some((word) => word.startsWith(needle))) {
        return scores.scoreWordPrefix;
    }
    if (name.includes(needle)) {
        return scores.scoreNameContains;
    }
    if (app.genericName.toLowerCase().includes(needle)) {
        return scores.scoreGenericName;
    }
    if (app.keywords.some((keyword) => keyword.toLowerCase().startsWith(needle)) || app.id.toLowerCase().includes(needle)) {
        return scores.scoreKeyword;
    }
    return NO_MATCH;
}

/**
 * @param {readonly SearchableApp[]} apps
 * @param {string} query
 * @param {number} limit
 * @param {MatchScores} scores
 * @returns {RankedApp[]}
 */
export function rankApps(apps, query, limit, scores) {
    return apps
        .map((app) => ({ app, score: scoreApp(app, query, scores) }))
        .filter((ranked) => ranked.score > NO_MATCH)
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
