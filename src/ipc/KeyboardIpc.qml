import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Keyboard

    function nextLayout(): void {
        Keyboard.nextLayout();
    }

    function lockKeys(): void {
        Keyboard.showLockKeys();
    }
}
