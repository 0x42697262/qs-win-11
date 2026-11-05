export const Surface = Object.freeze({
    None: "none",
    StartMenu: "startMenu",
    Search: "search",
    QuickLink: "quickLink",
    QuickSettings: "quickSettings",
    NotificationCenter: "notificationCenter",
    Widgets: "widgets",
    TrayOverflow: "trayOverflow",
    ContextMenu: "contextMenu",
    TaskView: "taskView",
    AltTab: "altTab",
    SessionMenu: "sessionMenu",
    SnapLayouts: "snapLayouts",
    Run: "run",
});

/** @typedef {{ surface: string, screenName: string, payload: unknown }} OpenSurfaceState */

/** @type {OpenSurfaceState} */
export const CLOSED = Object.freeze({ surface: Surface.None, screenName: "", payload: null });

/**
 * @param {OpenSurfaceState} current
 * @param {string} surface
 * @param {string} screenName
 * @param {unknown} payload
 * @returns {OpenSurfaceState}
 */
export function toggleSurface(current, surface, screenName, payload) {
    if (current.surface === surface && current.screenName === screenName && surface !== Surface.ContextMenu) {
        return CLOSED;
    }
    return Object.freeze({ surface, screenName, payload });
}

/**
 * @param {string} surface
 * @param {string} screenName
 * @param {unknown} payload
 * @returns {OpenSurfaceState}
 */
export function openSurface(surface, screenName, payload) {
    return Object.freeze({ surface, screenName, payload });
}
