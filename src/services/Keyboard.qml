pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import qs.src.adapters.compositor
import "../domain/system/keyboard.mjs" as KeyboardRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/enums.mjs" as Enums
import "../domain/catalog/icons.mjs" as Icons

Singleton {
    id: root

    readonly property string layoutName: Compositor.adapter ? Compositor.adapter.keyboardLayout : ""
    readonly property int layoutCount: Compositor.adapter ? Compositor.adapter.keyboardLayoutCount : 0
    readonly property var abbreviation: KeyboardRules.abbreviateLayout(layoutName)
    readonly property string mode: Settings.values.taskbar.inputIndicator
    readonly property bool indicatorShown: Features.enabled.inputIndicator && layoutName !== "" && (mode === Enums.InputIndicatorMode.Always || (mode === Enums.InputIndicatorMode.Auto && layoutCount > 1))
    property var lockState: ({ capsLock: null, numLock: null })

    function nextLayout(): void {
        if (Compositor.adapter) {
            Compositor.adapter.nextKeyboardLayout();
        }
    }

    function showLockKeys(): void {
        if (!Features.enabled.lockKeys) {
            return;
        }
        reader.running = false;
        delay.restart();
    }

    function announce(next: var): void {
        const changed = KeyboardRules.changedLockKey(lockState, next);
        lockState = next;
        const strings = Settings.values.text.osd;
        if (changed === "numLock") {
            Osd.showMessage(Icons.Icon.numberSymbol, next.numLock ? strings.numLockOn : strings.numLockOff);
        } else if (next.capsLock !== null) {
            Osd.showMessage(Icons.Icon.keyboardShiftUppercase, next.capsLock ? strings.capsLockOn : strings.capsLockOff);
        }
    }

    Timer {
        id: delay
        interval: Settings.values.tuning.lockKeyReadDelayMs
        onTriggered: reader.running = true
    }

    Process {
        id: reader
        command: Array.prototype.slice.call(SystemCatalog.LOCK_KEY_LED_COMMAND)
        stdout: StdioCollector {
            onStreamFinished: root.announce(KeyboardRules.parseLockLeds(text))
        }
    }
}
