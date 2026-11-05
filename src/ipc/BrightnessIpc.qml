import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Brightness

    function up(): void {
        Brightness.step(1);
    }

    function down(): void {
        Brightness.step(-1);
    }
}
