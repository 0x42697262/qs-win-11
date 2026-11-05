/**
 * @typedef {object} WindowInfo
 * @property {string} id
 * @property {string} appId
 * @property {string} title
 * @property {boolean} active
 * @property {boolean} urgent
 * @property {boolean} minimized
 * @property {number} workspaceId
 * @property {string} monitorName
 */
/** @typedef {{ id: number, name: string, active: boolean, focused: boolean, urgent: boolean, monitorName: string, windowCount: number }} WorkspaceInfo */

export const NO_WORKSPACE = -1;

/**
 * @param {Partial<WindowInfo> & { id: string }} fields
 * @returns {WindowInfo}
 */
export function makeWindowInfo(fields) {
    return Object.freeze({
        id: fields.id,
        appId: fields.appId ?? "",
        title: fields.title ?? "",
        active: fields.active ?? false,
        urgent: fields.urgent ?? false,
        minimized: fields.minimized ?? false,
        workspaceId: fields.workspaceId ?? NO_WORKSPACE,
        monitorName: fields.monitorName ?? "",
    });
}

/**
 * @param {readonly string[]} order
 * @param {string} activeId
 * @param {readonly string[]} existingIds
 * @returns {string[]}
 */
export function updateMostRecentlyUsed(order, activeId, existingIds) {
    const existing = new Set(existingIds);
    const kept = order.filter((id) => existing.has(id) && id !== activeId);
    const unseen = existingIds.filter((id) => id !== activeId && !kept.includes(id));
    const front = activeId && existing.has(activeId) ? [activeId] : [];
    return front.concat(kept, unseen);
}

/**
 * @param {readonly WindowInfo[]} windows
 * @param {readonly string[]} mostRecentlyUsed
 * @returns {WindowInfo[]}
 */
export function sortByMostRecentlyUsed(windows, mostRecentlyUsed) {
    const rank = new Map(mostRecentlyUsed.map((id, index) => [id, index]));
    const unranked = mostRecentlyUsed.length;
    return windows.slice().sort((left, right) => (rank.get(left.id) ?? unranked) - (rank.get(right.id) ?? unranked));
}

/**
 * @param {readonly WindowInfo[]} windows
 * @param {string} monitorName
 * @param {boolean} allMonitors
 * @returns {WindowInfo[]}
 */
export function windowsForMonitor(windows, monitorName, allMonitors) {
    return allMonitors ? windows.slice() : windows.filter((window) => window.monitorName === "" || window.monitorName === monitorName);
}
