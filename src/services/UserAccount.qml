pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    readonly property string name: Environment.userName
    readonly property string initial: name.charAt(0).toUpperCase()
    readonly property string avatarSource: homeFace.loaded ? `file://${homeFace.path}` : accountsServiceIcon.loaded ? `file://${accountsServiceIcon.path}` : ""

    FileView {
        id: homeFace

        path: `${Environment.home}/${SystemCatalog.AvatarPaths.homeFace}`
        printErrors: false
    }

    FileView {
        id: accountsServiceIcon

        path: `${SystemCatalog.AvatarPaths.accountsServiceDirectory}/${Environment.userName}`
        printErrors: false
    }
}
