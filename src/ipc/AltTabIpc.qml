import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.AltTab

    function next(): void {
        WindowSwitcher.step(1);
    }

    function previous(): void {
        WindowSwitcher.step(-1);
    }

    function commit(): void {
        WindowSwitcher.commit();
    }

    function cancel(): void {
        WindowSwitcher.cancel();
    }
}
