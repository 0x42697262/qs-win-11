import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/shell/surfaces.mjs" as Surfaces

IpcHandler {
    target: IpcCatalog.IpcTargetName.Widgets

    function toggle(): void {
        ShellState.toggle(Surfaces.Surface.Widgets, "");
    }
}
