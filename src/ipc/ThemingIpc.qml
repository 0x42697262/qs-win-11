import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Theming

    function render(): void {
        AppTheming.render();
    }
}
