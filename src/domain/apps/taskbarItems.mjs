import { normalizeAppId } from "./appIds.mjs";

/** @typedef {import("../compositor/windows.mjs").WindowInfo} WindowInfo */
/** @typedef {{ appId: string, key: string, pinned: boolean, windowIds: readonly string[], active: boolean, urgent: boolean, title: string }} TaskbarItem */

/**
 * @param {readonly string[]} pinnedAppIds
 * @param {readonly WindowInfo[]} windows
 * @param {(appId: string) => string} canonicalAppId
 * @returns {TaskbarItem[]}
 */
export function buildTaskbarItems(pinnedAppIds, windows, canonicalAppId) {
    /** @type {Map<string, { appId: string, pinned: boolean, windows: WindowInfo[] }>} */
    const groups = new Map();
    for (const appId of pinnedAppIds) {
        const key = normalizeAppId(canonicalAppId(appId));
        if (!groups.has(key)) {
            groups.set(key, { appId, pinned: true, windows: [] });
        }
    }
    for (const window of windows) {
        const appId = canonicalAppId(window.appId);
        const key = normalizeAppId(appId);
        const group = groups.get(key);
        if (group) {
            group.windows.push(window);
        } else {
            groups.set(key, { appId, pinned: false, windows: [window] });
        }
    }
    return Array.from(groups.entries()).map(([key, group]) => Object.freeze({
        appId: group.appId,
        key,
        pinned: group.pinned,
        windowIds: Object.freeze(group.windows.map((window) => window.id)),
        active: group.windows.some((window) => window.active),
        urgent: group.windows.some((window) => window.urgent),
        title: group.windows.length > 0 ? (group.windows[0]?.title ?? "") : "",
    }));
}

export const TaskbarClickAction = Object.freeze({ Launch: "launch", Focus: "focus", Minimize: "minimize", CycleNext: "cycleNext" });

/**
 * @param {TaskbarItem} item
 * @param {string} activeWindowId
 * @param {boolean} canMinimize
 * @returns {{ action: string, windowId: string }}
 */
export function taskbarClick(item, activeWindowId, canMinimize) {
    if (item.windowIds.length === 0) {
        return { action: TaskbarClickAction.Launch, windowId: "" };
    }
    const activeIndex = item.windowIds.indexOf(activeWindowId);
    if (activeIndex < 0) {
        return { action: TaskbarClickAction.Focus, windowId: item.windowIds[0] ?? "" };
    }
    if (item.windowIds.length > 1) {
        return { action: TaskbarClickAction.CycleNext, windowId: item.windowIds[(activeIndex + 1) % item.windowIds.length] ?? "" };
    }
    return canMinimize ? { action: TaskbarClickAction.Minimize, windowId: activeWindowId } : { action: TaskbarClickAction.Focus, windowId: activeWindowId };
}
