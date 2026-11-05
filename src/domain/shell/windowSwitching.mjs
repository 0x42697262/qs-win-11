/**
 * @param {number} current
 * @param {number} count
 * @param {number} direction
 * @returns {number}
 */
export function cycleIndex(current, count, direction) {
    if (count <= 0) {
        return 0;
    }
    return ((current + direction) % count + count) % count;
}

/**
 * @param {readonly string[]} hiddenByUs
 * @param {readonly { id: string, minimized: boolean }[]} windows
 * @returns {{ minimize: string[], restore: string[] }}
 */
export function showDesktopPlan(hiddenByUs, windows) {
    const stillHidden = hiddenByUs.filter((windowId) => windows.some((window) => window.id === windowId && window.minimized));
    if (stillHidden.length > 0) {
        return { minimize: [], restore: stillHidden };
    }
    return { minimize: windows.filter((window) => !window.minimized).map((window) => window.id), restore: [] };
}
