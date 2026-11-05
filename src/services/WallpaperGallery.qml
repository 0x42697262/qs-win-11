pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/wallpaper/gallery.mjs" as GalleryRules
import "../domain/system/paths.mjs" as PathRules
import "../domain/catalog/settingsSchema.mjs" as Schema

Singleton {
    id: root

    property list<var> files: []
    property bool loaded: false
    readonly property string directory: PathRules.expandHome(Settings.values.wallpaper.directory, Environment.home)
    readonly property int currentIndex: files.findIndex(file => file.path === Settings.values.wallpaper.path)

    function refresh(): void {
        lister.running = false;
        lister.command = GalleryRules.wallpaperFindCommand(directory, Settings.values.tuning.wallpaperSearchDepth);
        lister.running = true;
    }

    function set(path: string): void {
        Settings.update(Schema.SettingKey.WallpaperPath, path);
    }

    function step(delta: int): void {
        if (!loaded) {
            pendingStep = delta;
            refresh();
            return;
        }
        if (files.length === 0) {
            return;
        }
        const start = currentIndex < 0 ? (delta > 0 ? -1 : 0) : currentIndex;
        set(files[(start + delta + files.length) % files.length].path);
    }

    property int pendingStep: 0

    onDirectoryChanged: {
        loaded = false;
        if (files.length > 0) {
            refresh();
        }
    }

    Process {
        id: lister
        stdout: StdioCollector {
            onStreamFinished: {
                root.files = GalleryRules.parseWallpaperList(text, Settings.values.tuning.wallpaperListLimit);
                root.loaded = true;
                if (root.pendingStep !== 0) {
                    const delta = root.pendingStep;
                    root.pendingStep = 0;
                    root.step(delta);
                }
            }
        }
    }
}
