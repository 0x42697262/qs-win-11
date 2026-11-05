export const LogEvent = Object.freeze({
    ShellStarted: "shell.started",
    SettingsLoaded: "settings.loaded",
    SettingsInvalid: "settings.invalid",
    SettingsWriteRejected: "settings.writeRejected",
    SettingsWriteFailed: "settings.writeFailed",
    ShellDataInvalid: "shellData.invalid",
    FeatureDisabled: "feature.disabled",
    CapabilityProbed: "capability.probed",
    CompositorSelected: "compositor.selected",
    CompositorResync: "compositor.resync",
    CompositorUnsupported: "compositor.unsupported",
    WindowPlaced: "window.placed",
    ProcessFailed: "process.failed",
    ProcessTimedOut: "process.timedOut",
    HttpFailed: "http.failed",
    LocationResolved: "location.resolved",
    LocationFailed: "location.failed",
    WeatherUpdated: "weather.updated",
    ColorSchemePushed: "theme.colorSchemePushed",
    AppLaunched: "app.launched",
    AppNotFound: "app.notFound",
    SurfaceOpened: "surface.opened",
    SessionAction: "session.action",
    BatteryAlert: "power.batteryAlert",
    IdleStage: "idle.stage",
    LockStateChanged: "lock.state",
    ProfileExported: "profile.exported",
    ProfileLoaded: "profile.loaded",
    ProfileCreated: "profile.created",
    ProfileAbsorbed: "profile.absorbed",
    ProfileImported: "profile.imported",
    ProfileFailed: "profile.failed",
    LockAuthFailed: "lock.authFailed",
    NotificationReceived: "notification.received",
    NotificationsTrimmed: "notification.trimmed",
    CommandRun: "command.run",
});

export const LogLevel = Object.freeze({ Info: "info", Warning: "warning", Error: "error" });

/**
 * @param {string} event
 * @param {Readonly<Record<string, unknown>>} fields
 * @returns {string}
 */
export function formatLogLine(event, fields) {
    return JSON.stringify(Object.assign({ event }, fields));
}
