import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/enums.mjs" as Enums

IpcHandler {
    target: IpcCatalog.IpcTargetName.Snip

    function open(): void {
        Capture.open(Enums.SnipKind.Screenshot);
    }

    function screen(): void {
        Capture.captureOutput(Windows.focusedMonitorName);
    }

    function area(geometry: string): void {
        Capture.captureArea(geometry);
    }

    function record(): void {
        Capture.open(Enums.SnipKind.Recording);
    }

    function stop(): void {
        Capture.stopRecording();
    }
}
