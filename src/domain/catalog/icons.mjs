export const IconFontFile = Object.freeze({
    Regular: "assets/fonts/FluentSystemIcons-Regular.ttf",
    Filled: "assets/fonts/FluentSystemIcons-Filled.ttf",
    RegularMap: "assets/fonts/FluentSystemIcons-Regular.json",
    FilledMap: "assets/fonts/FluentSystemIcons-Filled.json",
});

export const IconSpecKind = Object.freeze({ Fluent: "fluent", Font: "font", Image: "image" });
export const FLUENT_NAME_PREFIX = "ic_fluent_";
export const FLUENT_REGULAR_SUFFIX = "_regular";
export const FLUENT_FILLED_SUFFIX = "_filled";
export const ICON_SPEC_SEPARATOR = ":";

export const ICON_DEFAULTS = Object.freeze({
    grid: "fluent:grid_24",
    search: "fluent:search_24",
    squareMultiple: "fluent:square_multiple_24",
    weatherSunny: "fluent:weather_sunny_24",
    weatherPartlyCloudyDay: "fluent:weather_partly_cloudy_day_24",
    weatherCloudy: "fluent:weather_cloudy_24",
    weatherRain: "fluent:weather_rain_24",
    weatherSnow: "fluent:weather_snow_24",
    weatherThunderstorm: "fluent:weather_thunderstorm_24",
    weatherFog: "fluent:weather_fog_24",
    weatherMoon: "fluent:weather_moon_24",
    chevronUp: "fluent:chevron_up_24",
    chevronDown: "fluent:chevron_down_24",
    chevronLeft: "fluent:chevron_left_24",
    chevronRight: "fluent:chevron_right_24",
    wifi1: "fluent:wifi_1_24",
    wifi2: "fluent:wifi_2_24",
    wifi3: "fluent:wifi_3_24",
    wifi4: "fluent:wifi_4_24",
    wifiOff: "fluent:wifi_off_24",
    wifiWarning: "fluent:wifi_warning_24",
    bluetooth: "fluent:bluetooth_24",
    bluetoothDisabled: "fluent:bluetooth_disabled_24",
    bluetoothConnected: "fluent:bluetooth_connected_24",
    airplane: "fluent:airplane_24",
    leafOne: "fluent:leaf_one_24",
    darkTheme: "fluent:dark_theme_24",
    alert: "fluent:alert_24",
    alertSnooze: "fluent:alert_snooze_24",
    speaker0: "fluent:speaker_0_24",
    speaker1: "fluent:speaker_1_24",
    speaker2: "fluent:speaker_2_24",
    speakerMute: "fluent:speaker_mute_24",
    micOff: "fluent:mic_off_24",
    brightnessHigh: "fluent:brightness_high_24",
    battery0: "fluent:battery_0_24",
    battery1: "fluent:battery_1_24",
    battery2: "fluent:battery_2_24",
    battery3: "fluent:battery_3_24",
    battery4: "fluent:battery_4_24",
    battery5: "fluent:battery_5_24",
    battery6: "fluent:battery_6_24",
    battery7: "fluent:battery_7_24",
    battery8: "fluent:battery_8_24",
    battery9: "fluent:battery_9_24",
    battery10: "fluent:battery_10_24",
    batteryCharge: "fluent:battery_charge_24",
    settings: "fluent:settings_24",
    power: "fluent:power_24",
    lockClosed: "fluent:lock_closed_24",
    signOut: "fluent:sign_out_24",
    arrowClockwise: "fluent:arrow_clockwise_24",
    edit: "fluent:edit_24",
    dismiss: "fluent:dismiss_24",
    calendarLtr: "fluent:calendar_ltr_24",
    play: "fluent:play_24",
    pause: "fluent:pause_24",
    previous: "fluent:previous_24",
    next: "fluent:next_24",
    person: "fluent:person_24",
    apps: "fluent:apps_24",
    document: "fluent:document_24",
    folder: "fluent:folder_24",
    window: "fluent:window_24",
    desktop: "fluent:desktop_24",
    checkmark: "fluent:checkmark_24",
    plugConnected: "fluent:plug_connected_24",
    keyboard: "fluent:keyboard_24",
    keyboardShiftUppercase: "fluent:keyboard_shift_uppercase_24",
    pin: "fluent:pin_24",
    pinOff: "fluent:pin_off_24",
    open: "fluent:open_24",
    delete: "fluent:delete_24",
    moreHorizontal: "fluent:more_horizontal_24",
    globe: "fluent:globe_24",
    info: "fluent:info_24",
    warning: "fluent:warning_24",
    errorCircle: "fluent:error_circle_24",
    arrowLeft: "fluent:arrow_left_24",
    layoutColumnTwo: "fluent:layout_column_two_24",
    layoutCellFour: "fluent:layout_cell_four_24",
    temperature: "fluent:temperature_24",
    drop: "fluent:drop_24",
    board: "fluent:board_24",
});

/** @typedef {keyof typeof ICON_DEFAULTS} IconKey */

export const Icon = /** @type {Readonly<{ [Key in IconKey]: Key }>} */ (Object.freeze(Object.keys(ICON_DEFAULTS).reduce((keys, key) => Object.assign(keys, { [key]: key }), {})));

export const BATTERY_LEVEL_ICONS = Object.freeze([
    Icon.battery0, Icon.battery1, Icon.battery2, Icon.battery3, Icon.battery4, Icon.battery5,
    Icon.battery6, Icon.battery7, Icon.battery8, Icon.battery9, Icon.battery10,
]);

export const WIFI_STRENGTH_ICONS = Object.freeze([Icon.wifi4, Icon.wifi3, Icon.wifi2, Icon.wifi1]);

export const VOLUME_LEVEL_ICONS = Object.freeze([Icon.speaker0, Icon.speaker1, Icon.speaker2]);
