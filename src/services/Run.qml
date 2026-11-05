pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/search/runHistory.mjs" as RunHistory
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema

Singleton {
    readonly property list<string> history: ShellData.values.runHistory

    function run(commandLine: string): void {
        if (commandLine.trim() === "") {
            return;
        }
        ShellData.update(ShellDataSchema.ShellDataKey.RunHistory, RunHistory.rememberCommand(history, commandLine, Settings.values.tuning.runHistoryLimit));
        ShellState.close();
        Session.runCommandLine(commandLine.trim());
    }
}
