export const IconFontFile = Object.freeze({
    Regular: "assets/fonts/FluentSystemIcons-Regular.ttf",
    Filled: "assets/fonts/FluentSystemIcons-Filled.ttf",
});

/** @typedef {{ regular: string, filled: string }} Glyph */

/**
 * @param {number} regularCodePoint
 * @param {number} filledCodePoint
 * @returns {Glyph}
 */
function glyph(regularCodePoint, filledCodePoint) {
    return Object.freeze({ regular: String.fromCodePoint(regularCodePoint), filled: String.fromCodePoint(filledCodePoint) });
}

export const Icon = Object.freeze({
    grid: glyph(0xf463, 0xf467),
    search: glyph(0xf690, 0xf69a),
    squareMultiple: glyph(0xf78c, 0xf7a4),
    weatherSunny: glyph(0xf8a2, 0xf8ba),
    weatherPartlyCloudyDay: glyph(0xf881, 0xf899),
    weatherCloudy: glyph(0xf86f, 0xf887),
    weatherRain: glyph(0xf887, 0xf89f),
    weatherSnow: glyph(0xf893, 0xf8ab),
    weatherThunderstorm: glyph(0xf8a5, 0xf8bd),
    weatherFog: glyph(0xf875, 0xf88d),
    weatherMoon: glyph(0xf87e, 0xf896),
    chevronUp: glyph(0xf2b7, 0xf2b7),
    chevronDown: glyph(0xf2a4, 0xf2a4),
    chevronLeft: glyph(0xf2ab, 0xf2ab),
    chevronRight: glyph(0xf2b1, 0xf2b1),
    wifi1: glyph(0xf8ad, 0xf8c5),
    wifi2: glyph(0xf8af, 0xf8c7),
    wifi3: glyph(0xf8b1, 0xf8c9),
    wifi4: glyph(0xf8b3, 0xf8cb),
    wifiOff: glyph(0xee5a, 0xee5a),
    wifiWarning: glyph(0xf7fd, 0xf816),
    bluetooth: glyph(0xf1df, 0xf1df),
    bluetoothDisabled: glyph(0xf1e1, 0xf1e1),
    bluetoothConnected: glyph(0xf1e0, 0xf1e0),
    airplane: glyph(0xf110, 0xf110),
    leafOne: glyph(0xe75b, 0xe769),
    darkTheme: glyph(0xf33c, 0xf33c),
    alert: glyph(0xf115, 0xf115),
    alertSnooze: glyph(0xf11d, 0xf11d),
    speaker0: glyph(0xf6f9, 0xf702),
    speaker1: glyph(0xf6fb, 0xf704),
    speaker2: glyph(0xeb43, 0xeb4c),
    speakerMute: glyph(0xeb4b, 0xeb54),
    micOff: glyph(0xf541, 0xf54b),
    brightnessHigh: glyph(0xe1f8, 0xe20c),
    battery0: glyph(0xf1bc, 0xf1bc),
    battery1: glyph(0xf1be, 0xf1be),
    battery2: glyph(0xf1c0, 0xf1c0),
    battery3: glyph(0xf1c2, 0xf1c2),
    battery4: glyph(0xf1c4, 0xf1c4),
    battery5: glyph(0xf1c6, 0xf1c6),
    battery6: glyph(0xf1c8, 0xf1c8),
    battery7: glyph(0xf1ca, 0xf1ca),
    battery8: glyph(0xf1cc, 0xf1cc),
    battery9: glyph(0xf1ce, 0xf1ce),
    battery10: glyph(0xe144, 0xe14f),
    batteryCharge: glyph(0xf1d0, 0xf1d0),
    settings: glyph(0xf6aa, 0xf6b3),
    power: glyph(0xf60f, 0xf619),
    lockClosed: glyph(0xe790, 0xe79e),
    signOut: glyph(0xf6da, 0xf6e3),
    arrowClockwise: glyph(0xf13e, 0xf13e),
    edit: glyph(0xf3de, 0xf3dd),
    dismiss: glyph(0xf36a, 0xf36a),
    calendarLtr: glyph(0xe24f, 0xe263),
    play: glyph(0xf606, 0xf610),
    pause: glyph(0xf5a2, 0xf5ac),
    previous: glyph(0xf629, 0xf633),
    next: glyph(0xf56a, 0xf574),
    person: glyph(0xf5be, 0xf5c8),
    apps: glyph(0xf134, 0xf134),
    document: glyph(0xf379, 0xf379),
    folder: glyph(0xf419, 0xf41d),
    window: glyph(0xee5e, 0xee5e),
    desktop: glyph(0xf35a, 0xf35a),
    checkmark: glyph(0xf295, 0xf295),
    plugConnected: glyph(0xe99a, 0xe9ac),
    keyboard: glyph(0xf4b9, 0xf4c3),
    keyboardShiftUppercase: glyph(0xf4c0, 0xf4ca),
    pin: glyph(0xf602, 0xf60c),
    pinOff: glyph(0xf604, 0xf60e),
    open: glyph(0xf583, 0xf58d),
    delete: glyph(0xf34d, 0xf34d),
    moreHorizontal: glyph(0xe825, 0xe833),
    globe: glyph(0xf45b, 0xf45f),
    info: glyph(0xf4a4, 0xf4ab),
    warning: glyph(0xf86a, 0xf882),
    errorCircle: glyph(0xf3f2, 0xf3f1),
    arrowLeft: glyph(0xf15c, 0xf15c),
    layoutColumnTwo: glyph(0xf049a, 0xf04ce),
    layoutCellFour: glyph(0xf0488, 0xf049b),
    temperature: glyph(0xf790, 0xf7a8),
    drop: glyph(0xe591, 0xe59d),
    board: glyph(0xf1e3, 0xf1e3),
});

export const BATTERY_LEVEL_ICONS = Object.freeze([
    Icon.battery0, Icon.battery1, Icon.battery2, Icon.battery3, Icon.battery4, Icon.battery5,
    Icon.battery6, Icon.battery7, Icon.battery8, Icon.battery9, Icon.battery10,
]);

export const WIFI_STRENGTH_ICONS = Object.freeze([Icon.wifi4, Icon.wifi3, Icon.wifi2, Icon.wifi1]);

export const VOLUME_LEVEL_ICONS = Object.freeze([Icon.speaker0, Icon.speaker1, Icon.speaker2]);
