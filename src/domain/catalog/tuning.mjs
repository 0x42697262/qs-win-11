import { spec, Unit } from "./valueSpec.mjs";

const MS = Unit.Milliseconds;
const COUNT = Unit.Count;

export const TUNING = Object.freeze({
    capabilityProbeTimeoutMs: spec(3000, 100, 60000, MS, "How long the startup capability probe may run."),
    compositorResyncIntervalMs: spec(30000, 1000, 3600000, MS, "How often the window list is fully resynced with the compositor."),
    osdVisibleMs: spec(1500, 100, 60000, MS, "How long the volume/brightness pill stays on screen."),
    osdStartupQuietMs: spec(2000, 0, 60000, MS, "No on-screen display during this time after start."),
    volumeStep: spec(0.05, 0.01, 1, Unit.Fraction, "Volume change per step (scroll, IPC, media keys)."),
    brightnessStepPercent: spec(5, 1, 100, Unit.Percent, "Brightness change per step."),
    searchResultLimit: spec(8, 1, 100, COUNT, "Search results shown."),
    startPinnedColumns: spec(6, 1, 20, COUNT, "Columns in the Start pinned grid."),
    startPinnedRows: spec(3, 1, 20, COUNT, "Rows in the Start pinned grid."),
    startRecommendedLimit: spec(6, 0, 50, COUNT, "Recommended files shown in Start."),
    startRecommendedColumns: spec(2, 1, 6, COUNT, "Columns in Start's Recommended list."),
    trayOverflowColumns: spec(4, 1, 20, COUNT, "Columns in the tray overflow flyout."),
    quickSettingsColumns: spec(3, 1, 10, COUNT, "Columns of Quick Settings tiles."),
    networkListLimit: spec(12, 1, 100, COUNT, "Wi-Fi networks listed."),
    altTabColumns: spec(6, 1, 20, COUNT, "Columns in the Alt+Tab switcher."),
    taskViewColumns: spec(4, 1, 20, COUNT, "Columns in Task View."),
    weatherRefreshMs: spec(1800000, 60000, 86400000, MS, "How often weather is refreshed."),
    weatherRequestTimeoutMs: spec(8000, 500, 120000, MS, "Timeout for weather and location requests."),
    weatherDebounceMs: spec(500, 0, 10000, MS, "Wait after a location change before fetching weather."),
    locationCacheMs: spec(21600000, 0, 604800000, MS, "How long an automatic location is reused."),
    geoclueTimeoutSeconds: spec(10, 1, 120, Unit.Seconds, "How long GeoClue may take to find a location."),
    systemStatsRefreshMs: spec(2000, 100, 60000, MS, "CPU and memory sampling interval while widgets are open."),
    brightnessPollMs: spec(1000, 100, 60000, MS, "Backlight polling interval."),
    batteryAlertHysteresisPercent: spec(2, 0, 50, Unit.Percent, "Battery must rise this much above the low level before alerting again."),
    lockFailureCooldownMs: spec(2000, 0, 60000, MS, "Pause after a wrong password."),
    lockClockTopDivisor: spec(6, 1, 20, Unit.Factor, "Lock clock sits at screen height divided by this."),
    autoHideRevealPixels: spec(2, 1, 50, Unit.Pixels, "Height of the edge strip that reveals an auto-hidden taskbar."),
    autoHideDelayMs: spec(400, 0, 10000, MS, "Delay before an auto-hidden taskbar hides."),
    tooltipDelayMs: spec(600, 0, 10000, MS, "Hover time before a tooltip appears."),
    toastStackLimit: spec(3, 1, 20, COUNT, "Notification banners shown at once."),
    notificationBodyLines: spec(3, 1, 50, COUNT, "Lines of body text before a notification is cut off."),
    settingsNumberStep: spec(0.05, 0.001, 1, Unit.Fraction, "Step for decimal sliders in the Settings app."),
    snapGapPixels: spec(8, 0, 200, Unit.Pixels, "Gap around snapped windows."),
    scoreExactName: spec(100, 0, 1000, Unit.Score, "Search score when the query equals an app name."),
    scoreNamePrefix: spec(80, 0, 1000, Unit.Score, "Search score when an app name starts with the query."),
    scoreWordPrefix: spec(60, 0, 1000, Unit.Score, "Search score when a word in the name starts with the query."),
    scoreNameContains: spec(40, 0, 1000, Unit.Score, "Search score when the name contains the query."),
    scoreGenericName: spec(25, 0, 1000, Unit.Score, "Search score when the generic name contains the query."),
    scoreKeyword: spec(20, 0, 1000, Unit.Score, "Search score when a keyword or id matches."),
});

/** @typedef {keyof typeof TUNING} TuningName */
