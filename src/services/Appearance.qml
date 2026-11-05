pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/appearance/resolveAppearance.mjs" as AppearanceRules
import "../domain/catalog/appearance.mjs" as AppearanceCatalog

Singleton {
    id: root

    readonly property var settings: Settings.values.appearance
    readonly property bool onBattery: Power.hasBattery && Power.onBattery
    readonly property var resolved: AppearanceRules.resolveAppearance(settings, onBattery)
    readonly property var knobs: resolved.knobs
    readonly property string backdrop: knobs.backdrop.value
    readonly property bool grain: knobs.grain.value === AppearanceCatalog.Toggle.On
    readonly property bool edgeHighlight: knobs.edgeHighlight.value === AppearanceCatalog.Toggle.On
    readonly property string shadows: knobs.shadows.value
    readonly property string corners: knobs.corners.value
    readonly property string animations: knobs.animations.value
    readonly property bool translucentOverlays: knobs.translucentOverlays.value === AppearanceCatalog.Toggle.On
    readonly property bool liveThumbnails: knobs.liveThumbnails.value === AppearanceCatalog.Toggle.On
    readonly property bool clockSeconds: knobs.clockSeconds.value === AppearanceCatalog.Toggle.On
    readonly property real pollingFactor: knobs.backgroundWork.value === AppearanceCatalog.BackgroundWork.Saver ? settings.saverPollingFactor : 1
    readonly property bool animated: animations !== AppearanceCatalog.Animations.None
    readonly property bool slides: animations === AppearanceCatalog.Animations.Full || animations === AppearanceCatalog.Animations.Rich
    readonly property bool richMotion: animations === AppearanceCatalog.Animations.Rich
    readonly property bool layeredShadows: shadows === AppearanceCatalog.Shadows.Layered
    readonly property bool anyShadows: shadows !== AppearanceCatalog.Shadows.None
    readonly property bool continuousCorners: corners === AppearanceCatalog.Corners.Continuous
    readonly property bool solid: backdrop === AppearanceCatalog.Backdrop.Solid

    function interval(baseMs: real): int {
        return Math.round(baseMs * pollingFactor);
    }
}
