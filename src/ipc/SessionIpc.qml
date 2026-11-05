import QtQuick
import Quickshell.Io
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/shell/surfaces.mjs" as Surfaces

IpcHandler {
    target: IpcCatalog.IpcTargetName.Session

    function lock(): void {
        Session.lock();
    }

    function menu(): void {
        ShellState.toggle(Surfaces.Surface.SessionMenu, "");
    }

    function suspend(): void {
        Session.suspend();
    }

    function hibernate(): void {
        Session.hibernate();
    }

    function signOut(): void {
        Session.signOut();
    }

    function restart(): void {
        Session.restart();
    }

    function powerOff(): void {
        Session.powerOff();
    }
}
