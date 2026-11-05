pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    property string lastPath: ""

    function exportTo(path: string): bool {
        if (path === "") {
            return false;
        }
        lastPath = path;
        exporter.path = path;
        exporter.setText(Settings.exportText());
        return true;
    }

    function importFrom(path: string): bool {
        if (path === "") {
            return false;
        }
        lastPath = path;
        importer.path = "";
        importer.path = path;
        importer.reload();
        return true;
    }

    FileView {
        id: exporter
        printErrors: false
        onSaved: Log.info(LogEvents.LogEvent.ProfileExported, { path: root.lastPath })
        onSaveFailed: (error) => Log.warning(LogEvents.LogEvent.ProfileFailed, { path: root.lastPath, error: FileViewError.toString(error) })
    }

    FileView {
        id: importer
        printErrors: false
        onLoaded: {
            const problems = Settings.replaceAll(text());
            Log.info(LogEvents.LogEvent.ProfileImported, { path: root.lastPath, skipped: problems.map(problem => problem.key) });
        }
        onLoadFailed: (error) => Log.warning(LogEvents.LogEvent.ProfileFailed, { path: root.lastPath, error: FileViewError.toString(error) })
    }
}
