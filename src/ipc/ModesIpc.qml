import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Modes

    function toggleStayAwake(): void {
        StayAwake.setActive(!StayAwake.requested);
    }

    function toggleGameMode(): void {
        GameMode.setActive(!GameMode.active);
    }
}
