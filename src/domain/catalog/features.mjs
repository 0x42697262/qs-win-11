export const FeatureName = Object.freeze({
    Taskbar: "taskbar",
    StartMenu: "startMenu",
    Search: "search",
    QuickLink: "quickLink",
    QuickSettings: "quickSettings",
    Notifications: "notifications",
    SystemTray: "systemTray",
    Osd: "osd",
    TaskView: "taskView",
    AltTab: "altTab",
    Widgets: "widgets",
    Weather: "weather",
    LockScreen: "lockScreen",
    Idle: "idle",
    NightLight: "nightLight",
    SnapLayouts: "snapLayouts",
    SettingsApp: "settingsApp",
    AppThemeSync: "appThemeSync",
    BatteryAlerts: "batteryAlerts",
    SessionMenu: "sessionMenu",
    Run: "run",
    StayAwake: "stayAwake",
    GameMode: "gameMode",
    Vpn: "vpn",
    ExternalBrightness: "externalBrightness",
    InputIndicator: "inputIndicator",
    LockKeys: "lockKeys",
});

export const ExperimentalFeatureName = Object.freeze({
    HoverThumbnails: "hoverThumbnails",
});

export const Capability = Object.freeze({
    WindowList: "windowList",
    Workspaces: "workspaces",
    WindowPlacement: "windowPlacement",
    Minimize: "minimize",
    Battery: "battery",
    Backlight: "backlight",
    NotifySend: "notifySend",
    NightLightCommand: "nightLightCommand",
    ColorSchemeSync: "colorSchemeSync",
    Screencopy: "screencopy",
    PowerProfiles: "powerProfiles",
    NetworkManagerCli: "networkManagerCli",
    DisplayControl: "displayControl",
    KeyboardLayouts: "keyboardLayouts",
    ImageSampling: "imageSampling",
});

export const BusName = Object.freeze({
    Notifications: "org.freedesktop.Notifications",
    StatusNotifierWatcher: "org.kde.StatusNotifierWatcher",
});

/** @typedef {typeof FeatureName[keyof typeof FeatureName]} Feature */
/** @typedef {typeof Capability[keyof typeof Capability]} CapabilityName */
/** @typedef {typeof BusName[keyof typeof BusName]} BusNameValue */
/** @typedef {{ capabilities: readonly CapabilityName[], busName?: BusNameValue, dependsOn: readonly Feature[] }} FeatureRequirement */

/** @type {Readonly<Record<Feature, boolean>>} */
export const FEATURE_DEFAULTS = Object.freeze({
    taskbar: true,
    startMenu: true,
    search: true,
    quickLink: true,
    quickSettings: true,
    notifications: true,
    systemTray: true,
    osd: true,
    taskView: true,
    altTab: true,
    widgets: true,
    weather: true,
    lockScreen: false,
    idle: false,
    nightLight: true,
    snapLayouts: true,
    settingsApp: true,
    appThemeSync: true,
    batteryAlerts: true,
    sessionMenu: true,
    run: true,
    stayAwake: true,
    gameMode: true,
    vpn: true,
    externalBrightness: true,
    inputIndicator: true,
    lockKeys: true,
});

/** @type {Readonly<Record<Feature, FeatureRequirement>>} */
export const FEATURE_REQUIREMENTS = Object.freeze({
    taskbar: { capabilities: [], dependsOn: [] },
    startMenu: { capabilities: [], dependsOn: [] },
    search: { capabilities: [], dependsOn: [FeatureName.StartMenu] },
    quickLink: { capabilities: [], dependsOn: [FeatureName.Taskbar] },
    quickSettings: { capabilities: [], dependsOn: [] },
    notifications: { capabilities: [], busName: BusName.Notifications, dependsOn: [] },
    systemTray: { capabilities: [], busName: BusName.StatusNotifierWatcher, dependsOn: [FeatureName.Taskbar] },
    osd: { capabilities: [], dependsOn: [] },
    taskView: { capabilities: [Capability.WindowList], dependsOn: [] },
    altTab: { capabilities: [Capability.WindowList], dependsOn: [] },
    widgets: { capabilities: [], dependsOn: [] },
    weather: { capabilities: [], dependsOn: [FeatureName.Widgets] },
    lockScreen: { capabilities: [], dependsOn: [] },
    idle: { capabilities: [], dependsOn: [] },
    nightLight: { capabilities: [Capability.NightLightCommand], dependsOn: [] },
    snapLayouts: { capabilities: [Capability.WindowPlacement], dependsOn: [] },
    settingsApp: { capabilities: [], dependsOn: [] },
    appThemeSync: { capabilities: [Capability.ColorSchemeSync], dependsOn: [] },
    batteryAlerts: { capabilities: [Capability.Battery, Capability.NotifySend], dependsOn: [] },
    sessionMenu: { capabilities: [], dependsOn: [] },
    run: { capabilities: [], dependsOn: [] },
    stayAwake: { capabilities: [], dependsOn: [] },
    gameMode: { capabilities: [], dependsOn: [] },
    vpn: { capabilities: [Capability.NetworkManagerCli], dependsOn: [FeatureName.QuickSettings] },
    externalBrightness: { capabilities: [Capability.DisplayControl], dependsOn: [FeatureName.QuickSettings] },
    inputIndicator: { capabilities: [Capability.KeyboardLayouts], dependsOn: [FeatureName.Taskbar] },
    lockKeys: { capabilities: [], dependsOn: [FeatureName.Osd] },
});
