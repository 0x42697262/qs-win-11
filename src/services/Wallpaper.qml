pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/enums.mjs" as Enums

Singleton {
    readonly property var wallpaperSettings: Settings.values.wallpaper
    readonly property string path: wallpaperSettings.path
    readonly property bool available: path !== ""
    readonly property string source: available ? (path.indexOf(SystemCatalog.URL_SCHEME_SEPARATOR) >= 0 ? path : `${SystemCatalog.FILE_URL_PREFIX}${path}`) : ""
    readonly property bool drawnByShell: available && wallpaperSettings.mode === Enums.WallpaperMode.Shell
    readonly property int fillMode: {
        switch (wallpaperSettings.fillMode) {
        case Enums.WallpaperFill.Fit:
            return Image.PreserveAspectFit;
        case Enums.WallpaperFill.Stretch:
            return Image.Stretch;
        case Enums.WallpaperFill.Center:
            return Image.Pad;
        case Enums.WallpaperFill.Tile:
            return Image.Tile;
        default:
            return Image.PreserveAspectCrop;
        }
    }
}
