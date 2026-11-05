import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/enums.mjs" as Enums

IpcHandler {
    target: IpcCatalog.IpcTargetName.ColorPicker

    function open(): void {
        Capture.open(Enums.SnipKind.Color);
    }

    function at(globalX: int, globalY: int): void {
        Capture.pickAt(globalX, globalY);
    }
}
