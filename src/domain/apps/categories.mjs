import { AppCategory, CATEGORY_ORDER, FREEDESKTOP_CATEGORY_MAP } from "../catalog/appCategories.mjs";

/** @typedef {{ id: string, name: string, categories: readonly string[] }} CategorizableApp */
/** @typedef {{ category: string, apps: CategorizableApp[] }} CategoryGroup */

/**
 * @param {readonly string[]} freedesktopCategories
 * @returns {string}
 */
export function categoryOf(freedesktopCategories) {
    /** @type {Readonly<Record<string, string>>} */
    const map = FREEDESKTOP_CATEGORY_MAP;
    /** @type {readonly string[]} */
    const order = CATEGORY_ORDER;
    const ranked = freedesktopCategories
        .map((category) => map[category])
        .filter((category) => category !== undefined)
        .sort((left, right) => order.indexOf(left ?? "") - order.indexOf(right ?? ""));
    return ranked[0] ?? AppCategory.Other;
}

/**
 * @param {readonly CategorizableApp[]} apps
 * @returns {CategoryGroup[]}
 */
export function groupByCategory(apps) {
    /** @type {Map<string, CategorizableApp[]>} */
    const groups = new Map();
    apps.forEach((app) => {
        const category = categoryOf(app.categories);
        const list = groups.get(category) ?? [];
        list.push(app);
        groups.set(category, list);
    });
    return CATEGORY_ORDER
        .filter((category) => groups.has(category))
        .map((category) => ({ category, apps: (groups.get(category) ?? []).slice().sort((left, right) => left.name.localeCompare(right.name)) }));
}
