import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/enums.mjs" as Enums
import "../domain/shell/surfaces.mjs" as Surfaces

IpcHandler {
    target: IpcCatalog.IpcTargetName.Panel

    function clipboard(): void {
        ClipboardHistory.tab = Enums.PanelTab.Clipboard;
        ShellState.open(Surfaces.Surface.Panel, "", null);
    }

    function emoji(): void {
        ClipboardHistory.tab = Enums.PanelTab.Emoji;
        ShellState.open(Surfaces.Surface.Panel, "", null);
    }

    function toggle(): void {
        ShellState.toggle(Surfaces.Surface.Panel, "");
    }
}
