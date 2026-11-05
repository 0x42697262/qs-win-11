pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/system/indicators.mjs" as Indicators
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/tuning.mjs" as Tuning
import "../domain/catalog/features.mjs" as FeatureCatalog
import "../domain/numbers.mjs" as Numbers

Singleton {
    id: root

    readonly property string device: Capabilities.backlights.length > 0 ? Capabilities.backlights[0] : ""
    readonly property bool available: device !== "" && Capabilities.has(FeatureCatalog.Capability.Backlight)
    readonly property real maximum: Number(maximumFile.text().trim()) || 1
    readonly property real fraction: available ? Numbers.clamp(Number(currentFile.text().trim()) / maximum, 0, 1) : 0
    readonly property bool watching: available

    function setFraction(value: real): void {
        if (!available) {
            return;
        }
        const percent = Indicators.toPercent(value);
        Session.runCommandLine(Indicators.fillCommandTemplate(Settings.values.commands.brightness, SystemCatalog.BRIGHTNESS_PERCENT_PLACEHOLDER, percent));
    }

    function step(direction: int): void {
        setFraction(fraction + direction * Tuning.BRIGHTNESS_STEP_PERCENT / Tuning.PERCENT);
    }

    FileView {
        id: currentFile
        path: root.device !== "" ? `${root.device}/${SystemCatalog.BacklightFile.current}` : ""
        blockLoading: true
        printErrors: false
    }

    FileView {
        id: maximumFile
        path: root.device !== "" ? `${root.device}/${SystemCatalog.BacklightFile.maximum}` : ""
        blockLoading: true
        printErrors: false
    }

    Timer {
        running: root.watching
        repeat: true
        interval: Tuning.BRIGHTNESS_POLL_MS
        onTriggered: currentFile.reload()
    }
}
