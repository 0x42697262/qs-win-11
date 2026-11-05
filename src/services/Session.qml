pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    signal lockRequested

    function runCommandLine(commandLine: string): void {
        if (commandLine.trim() === "") {
            return;
        }
        Log.info(LogEvents.LogEvent.CommandRun, { commandLine });
        Quickshell.execDetached([SystemCatalog.SystemBinary.Shell, "-c", commandLine]);
    }

    function openUri(uri: string): void {
        Quickshell.execDetached([SystemCatalog.SystemBinary.XdgOpen, uri]);
    }

    function run(action: string, command: list<string>): void {
        Log.info(LogEvents.LogEvent.SessionAction, { action });
        Quickshell.execDetached(command);
    }

    function lock(): void {
        Log.info(LogEvents.LogEvent.SessionAction, { action: SystemCatalog.SessionAction.Lock });
        if (Features.enabled.lockScreen) {
            LockState.lock();
            lockRequested();
        } else {
            runCommandLine(Settings.values.commands.lock);
        }
    }

    function suspend(): void {
        run(SystemCatalog.SessionAction.Suspend, SystemCatalog.SessionCommand.suspend);
    }

    function hibernate(): void {
        run(SystemCatalog.SessionAction.Hibernate, SystemCatalog.SessionCommand.hibernate);
    }

    function restart(): void {
        run(SystemCatalog.SessionAction.Restart, SystemCatalog.SessionCommand.reboot);
    }

    function powerOff(): void {
        run(SystemCatalog.SessionAction.PowerOff, SystemCatalog.SessionCommand.powerOff);
    }

    function signOut(): void {
        const custom = Settings.values.commands.signOut;
        if (custom !== "") {
            runCommandLine(custom);
        } else {
            run(SystemCatalog.SessionAction.SignOut, SystemCatalog.SessionCommand.terminateSession.concat([Environment.sessionId]));
        }
    }
}
