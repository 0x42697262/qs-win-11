pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/features.mjs" as FeatureCatalog

Singleton {
    readonly property bool active: ShellData.values.gameMode && Features.enabled.gameMode
    readonly property bool silencing: active && Settings.values.quickSettings.gameModeSilencesNotifications

    function setActive(value: bool): void {
        ShellData.update(ShellDataSchema.ShellDataKey.GameMode, value);
        Log.info(LogEvents.LogEvent.ModeChanged, { mode: FeatureCatalog.FeatureName.GameMode, active: value });
    }
}
