import QtQuick
import Quickshell
import Quickshell.Io
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Shell

    function reload(): void {
        Quickshell.reload(true);
    }
}
