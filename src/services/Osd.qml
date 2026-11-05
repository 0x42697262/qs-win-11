pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/uiEnums.mjs" as UiEnums
import "../domain/catalog/tuning.mjs" as Tuning

Singleton {
    id: root

    property string kind: UiEnums.OsdKind.None
    readonly property bool shown: kind !== UiEnums.OsdKind.None && hideTimer.running
    property bool ready: false

    function show(newKind: string): void {
        if (!ready || !Features.enabled.osd) {
            return;
        }
        kind = newKind;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: Tuning.OSD_VISIBLE_MS
        onTriggered: root.kind = UiEnums.OsdKind.None
    }

    Timer {
        running: true
        interval: Tuning.OSD_STARTUP_QUIET_MS
        onTriggered: root.ready = true
    }

    Connections {
        target: Audio
        function onVolumeChanged(): void {
            root.show(UiEnums.OsdKind.Volume);
        }
        function onMutedChanged(): void {
            root.show(UiEnums.OsdKind.Volume);
        }
        function onMicrophoneMutedChanged(): void {
            root.show(UiEnums.OsdKind.Microphone);
        }
    }

    Connections {
        target: Brightness
        function onFractionChanged(): void {
            root.show(UiEnums.OsdKind.Brightness);
        }
    }
}
