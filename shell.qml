//@ pragma UseQApplication
import QtQuick
import Quickshell
import qs.src.config
import qs.src.services
import qs.src.ipc
import qs.src.ui.features.gallery
import "src/domain/catalog/logEvents.mjs" as LogEvents

ShellRoot {
    id: root

    Component.onCompleted: Log.info(LogEvents.LogEvent.ShellStarted, { settingsFile: Paths.settingsFile })

    ShellIpc {}
    SettingsIpc {}

    LazyLoader {
        active: Environment.galleryRequested
        ComponentGallery {}
    }

    LazyLoader {
        active: Features.enabled.appThemeSync
        AppThemeSync {}
    }
}
