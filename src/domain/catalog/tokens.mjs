/** @typedef {{ hex: string, alpha: number }} ColorToken */

/**
 * @param {string} hex
 * @param {number} alpha
 * @returns {ColorToken}
 */
function tone(hex, alpha = 1) {
    return Object.freeze({ hex, alpha });
}

export const WHITE = "#ffffff";
export const BLACK = "#000000";

export const DARK_BASE = Object.freeze({
    micaBase: tone("#202020"),
    taskbarBackground: tone("#1c1c1c", 0.86),
    flyoutBackground: tone("#2c2c2c", 0.93),
    cardBackground: tone(WHITE, 0.0512),
    cardBackgroundSecondary: tone(WHITE, 0.0326),
    smokeOverlay: tone(BLACK, 0.3),
    textPrimary: tone(WHITE),
    textSecondary: tone(WHITE, 0.786),
    textTertiary: tone(WHITE, 0.545),
    textDisabled: tone(WHITE, 0.363),
    subtleFillHover: tone(WHITE, 0.0605),
    subtleFillPressed: tone(WHITE, 0.0419),
    controlFill: tone(WHITE, 0.0605),
    controlFillHover: tone(WHITE, 0.0837),
    controlFillPressed: tone(WHITE, 0.0326),
    controlFillDisabled: tone(WHITE, 0.0419),
    controlStrongFill: tone(WHITE, 0.545),
    controlStroke: tone(WHITE, 0.0698),
    controlStrongStroke: tone(WHITE, 0.545),
    cardStroke: tone(BLACK, 0.1),
    surfaceStroke: tone("#757575", 0.4),
    divider: tone(WHITE, 0.0837),
    focusStroke: tone(WHITE),
    success: tone("#6ccb5f"),
    caution: tone("#fce100"),
    critical: tone("#ff99a4"),
    attention: tone("#ff9e5c"),
});

export const LIGHT_BASE = Object.freeze({
    micaBase: tone("#f3f3f3"),
    taskbarBackground: tone("#eeeeee", 0.86),
    flyoutBackground: tone("#fcfcfc", 0.93),
    cardBackground: tone(WHITE, 0.7),
    cardBackgroundSecondary: tone("#f6f6f6", 0.5),
    smokeOverlay: tone(BLACK, 0.3),
    textPrimary: tone(BLACK, 0.896),
    textSecondary: tone(BLACK, 0.606),
    textTertiary: tone(BLACK, 0.446),
    textDisabled: tone(BLACK, 0.361),
    subtleFillHover: tone(BLACK, 0.0373),
    subtleFillPressed: tone(BLACK, 0.0241),
    controlFill: tone(WHITE, 0.7),
    controlFillHover: tone("#f9f9f9", 0.5),
    controlFillPressed: tone("#f9f9f9", 0.3),
    controlFillDisabled: tone("#f9f9f9", 0.3),
    controlStrongFill: tone(BLACK, 0.446),
    controlStroke: tone(BLACK, 0.0578),
    controlStrongStroke: tone(BLACK, 0.446),
    cardStroke: tone(BLACK, 0.0578),
    surfaceStroke: tone("#757575", 0.4),
    divider: tone(BLACK, 0.0803),
    focusStroke: tone(BLACK, 0.896),
    success: tone("#0f7b0f"),
    caution: tone("#9d5d00"),
    critical: tone("#c42b1c"),
    attention: tone("#c35a00"),
});

export const TRANSLUCENT_SURFACE_KEYS = Object.freeze(["taskbarBackground", "flyoutBackground"]);

export const ACCENT_SHADES = Object.freeze({
    darkModeMixWithWhite: 0.45,
    lightModeMixWithBlack: 0.15,
    hoverAlpha: 0.9,
    pressedAlpha: 0.8,
    disabledAlpha: 0.3,
});

export const RADIUS = Object.freeze({ control: 4, overlay: 8, round: 999 });

export const SPACING = Object.freeze({ xxSmall: 2, xSmall: 4, small: 8, medium: 12, large: 16, xLarge: 24, xxLarge: 32, xxxLarge: 48 });

export const FONT_SIZE = Object.freeze({ caption: 12, body: 14, bodyLarge: 18, subtitle: 20, title: 28, titleLarge: 40, display: 96 });

export const FONT_WEIGHT = Object.freeze({ regular: 400, semibold: 600, bold: 700 });

export const ICON_SIZE = Object.freeze({ small: 12, medium: 16, large: 20, xLarge: 24, appTile: 32, hero: 48 });

export const CONTROL_SIZE = Object.freeze({
    taskbarHeight: 48,
    taskbarButton: 40,
    taskbarIcon: 24,
    activeIndicatorWidth: 16,
    openIndicatorWidth: 6,
    indicatorHeight: 3,
    buttonHeight: 32,
    toggleWidth: 40,
    toggleHeight: 20,
    toggleKnob: 12,
    toggleKnobPressed: 14,
    sliderTrack: 4,
    sliderThumb: 20,
    sliderThumbInner: 12,
    sliderThumbInnerPressed: 10,
    sliderThumbInnerHover: 14,
    quickTileWidth: 96,
    quickTileHeight: 48,
    focusStroke: 2,
    stroke: 1,
    flyoutWidth: 360,
    startMenuWidth: 640,
    startMenuHeight: 720,
    calendarCell: 40,
    toastWidth: 364,
    osdWidth: 220,
    osdHeight: 46,
    widgetsWidth: 760,
    sessionButton: 120,
    taskViewCard: 220,
    contextMenuWidth: 220,
    avatar: 32,
    avatarLarge: 96,
    startTileWidth: 96,
    startTileHeight: 84,
    startFooterHeight: 64,
    searchResultsWidth: 280,
    mediaArt: 64,
    clusterIconSpacing: 6,
    listMaxHeight: 320,
    notificationListHeight: 420,
    notificationImage: 48,
    toastStackSpacing: 8,
    showDesktopWidth: 8,
    clockWidth: 88,
    trayIcon: 16,
    trayCell: 32,
});

export const MOTION_MS = Object.freeze({ fast: 83, normal: 167, slow: 250, slower: 333, reduced: 1 });

export const EASING_CURVES = Object.freeze({
    decelerate: Object.freeze([0, 0, 0, 1, 1, 1]),
    pointToPoint: Object.freeze([0.55, 0.55, 0, 1, 1, 1]),
    accelerate: Object.freeze([1, 0, 1, 1, 1, 1]),
});

export const ELEVATION = Object.freeze({ flyoutShadowRadius: 32, flyoutShadowOffset: 8, flyoutShadowAlpha: 0.28 });

export const SLIDE_DISTANCE = Object.freeze({ flyout: 40 });
export const PRESS_SCALE = 0.88;
