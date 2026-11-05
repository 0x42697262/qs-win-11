pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    readonly property bool available: Features.enabled.nightLight
    readonly property bool active: process.running

    function setActive(value: bool): void {
        if (!available) {
            return;
        }
        process.command = [SystemCatalog.SystemBinary.Shell, "-c", `exec ${Settings.values.commands.nightLight}`];
        process.running = value;
    }

    Process {
        id: process
    }
}
