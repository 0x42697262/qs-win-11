import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog

IpcHandler {
    target: IpcCatalog.IpcTargetName.Audio

    function volumeUp(): void {
        Audio.stepVolume(1);
    }

    function volumeDown(): void {
        Audio.stepVolume(-1);
    }

    function toggleMute(): void {
        Audio.toggleMute();
    }

    function toggleMicrophoneMute(): void {
        Audio.toggleMicrophoneMute();
    }
}
