pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/apps/recentFiles.mjs" as RecentRules
import "../domain/catalog/tuning.mjs" as Tuning

Singleton {
    readonly property list<var> files: RecentRules.parseRecentFiles(file.loadedText, Tuning.START_RECOMMENDED_LIMIT)

    FileView {
        id: file

        property string loadedText: ""

        path: Paths.recentFilesFile
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: loadedText = text()
        onLoadFailed: loadedText = ""
    }
}
