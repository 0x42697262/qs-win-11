pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    property bool locked: false

    function lock(): void {
        if (!locked) {
            locked = true;
            Log.info(LogEvents.LogEvent.LockStateChanged, { locked: true });
        }
    }

    function unlock(): void {
        locked = false;
        Log.info(LogEvents.LogEvent.LockStateChanged, { locked: false });
    }

    Connections {
        target: Session
        function onLockRequested(): void {
            root.lock();
        }
    }
}
