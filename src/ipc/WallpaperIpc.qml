import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Wallpaper

    function set(path: string): void {
        WallpaperGallery.set(path);
    }

    function next(): void {
        WallpaperGallery.step(1);
    }

    function previous(): void {
        WallpaperGallery.step(-1);
    }
}
