pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/logEvents.mjs" as LogEvents
import "../domain/catalog/features.mjs" as FeatureCatalog

Singleton {
    property bool requested: false
    readonly property bool active: requested && Features.enabled.stayAwake

    function setActive(value: bool): void {
        requested = value;
        Log.info(LogEvents.LogEvent.ModeChanged, { mode: FeatureCatalog.FeatureName.StayAwake, active: value });
    }
}
