import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.ui.theme
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Scope {
    id: root

    readonly property string scheme: Theme.dark ? SystemCatalog.ColorSchemeCommand.dark : SystemCatalog.ColorSchemeCommand.light

    onSchemeChanged: push()
    Component.onCompleted: push()

    function push(): void {
        if (pusher.running) {
            pusher.pushAgain = true;
            return;
        }
        pusher.command = [SystemCatalog.SystemBinary.Gsettings, "set", SystemCatalog.ColorSchemeCommand.schema, SystemCatalog.ColorSchemeCommand.key, scheme];
        pusher.running = true;
    }

    Process {
        id: pusher

        property bool pushAgain: false

        onExited: (exitCode) => {
            if (pushAgain) {
                pushAgain = false;
                root.push();
            }
            if (exitCode === 0) {
                Log.info(LogEvents.LogEvent.ColorSchemePushed, { scheme: root.scheme });
            } else {
                Log.warning(LogEvents.LogEvent.ProcessFailed, { command: SystemCatalog.SystemBinary.Gsettings, exitCode });
            }
        }
    }
}
