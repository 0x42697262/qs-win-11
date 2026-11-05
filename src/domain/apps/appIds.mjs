const DESKTOP_SUFFIX = ".desktop";

/**
 * @param {string} appId
 * @returns {string}
 */
export function normalizeAppId(appId) {
    const lower = appId.trim().toLowerCase();
    return lower.endsWith(DESKTOP_SUFFIX) ? lower.slice(0, -DESKTOP_SUFFIX.length) : lower;
}

/**
 * @param {readonly string[]} pinned
 * @param {string} appId
 * @returns {string[]}
 */
export function pinApp(pinned, appId) {
    const key = normalizeAppId(appId);
    return pinned.some((candidate) => normalizeAppId(candidate) === key) ? pinned.slice() : pinned.concat([appId]);
}

/**
 * @param {readonly string[]} pinned
 * @param {string} appId
 * @returns {string[]}
 */
export function unpinApp(pinned, appId) {
    const key = normalizeAppId(appId);
    return pinned.filter((candidate) => normalizeAppId(candidate) !== key);
}

/**
 * @param {readonly string[]} pinned
 * @param {string} appId
 * @returns {boolean}
 */
export function isPinned(pinned, appId) {
    const key = normalizeAppId(appId);
    return pinned.some((candidate) => normalizeAppId(candidate) === key);
}

/**
 * @param {readonly string[]} pinned
 * @param {string} appId
 * @param {number} targetIndex
 * @returns {string[]}
 */
export function movePinnedApp(pinned, appId, targetIndex) {
    const remaining = unpinApp(pinned, appId);
    const index = Math.max(0, Math.min(targetIndex, remaining.length));
    return remaining.slice(0, index).concat([appId], remaining.slice(index));
}
