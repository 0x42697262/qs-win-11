import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/catalog/profiles.mjs" as ProfileCatalog

Scope {
    id: root

    required property string modelData
    readonly property string name: modelData
    readonly property string folder: `${Paths.profilesDirectory}/${name}`
    property string text: ""

    signal changed

    FileView {
        path: `${root.folder}/${ProfileCatalog.PROFILE_FILE}`
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            root.text = text();
            root.changed();
        }
        onLoadFailed: {
            root.text = "";
            root.changed();
        }
    }
}
