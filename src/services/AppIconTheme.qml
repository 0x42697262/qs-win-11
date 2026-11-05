pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/apps/appIcons.mjs" as AppIconRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property string theme: Settings.values.appIcons.theme
    readonly property var overrides: AppIconRules.parseAppIconOverrides(Array.prototype.slice.call(Settings.values.appIcons.overrides))
    property var index: ({})

    onThemeChanged: rebuild()
    Component.onCompleted: rebuild()

    function rebuild(): void {
        index = {};
        if (theme === "") {
            return;
        }
        const directories = AppIconRules.iconThemeDirectories(Environment.dataHome, Environment.dataDirs, Environment.home, theme);
        scanner.running = false;
        scanner.command = [SystemCatalog.SystemBinary.Find].concat(directories, SystemCatalog.ICON_FIND_ARGUMENTS);
        scanner.running = true;
    }

    function lookup(name: string): string {
        return index[name] ?? "";
    }

    Process {
        id: scanner
        stdout: StdioCollector {
            onStreamFinished: {
                root.index = AppIconRules.buildIconIndex(text);
                Log.info(LogEvents.LogEvent.IconThemeIndexed, { theme: root.theme, icons: Object.keys(root.index).length });
            }
        }
    }
}
