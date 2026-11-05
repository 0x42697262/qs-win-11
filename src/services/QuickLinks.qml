pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/shell/surfaces.mjs" as Surfaces
import "../domain/catalog/strings.mjs" as Strings
import "../domain/catalog/icons.mjs" as Icons

Singleton {
    readonly property var commands: Settings.values.commands

    function items(): list<var> {
        const entries = [];
        const addCommand = (text, icon, commandLine) => {
            if (commandLine !== "") {
                entries.push({ text, icon, action: () => Session.runCommandLine(commandLine) });
            }
        };
        if (Features.enabled.settingsApp) {
            entries.push({ text: Strings.Strings.quickLink.settings, icon: Icons.Icon.settings, action: () => SettingsWindow.show("") });
        }
        addCommand(Strings.Strings.quickLink.networkConnections, Icons.Icon.globe, commands.networkSettings);
        addCommand(Strings.Strings.quickLink.terminal, Icons.Icon.window, commands.terminal);
        addCommand(Strings.Strings.quickLink.taskManager, Icons.Icon.apps, commands.taskManager);
        addCommand(Strings.Strings.quickLink.fileExplorer, Icons.Icon.folder, commands.fileManager);
        entries.push({ text: Strings.Strings.quickLink.search, icon: Icons.Icon.search, action: () => ShellState.open(Surfaces.Surface.Search, "", null) });
        entries.push({ text: Strings.Strings.session.lock, icon: Icons.Icon.lockClosed, action: () => Session.lock() });
        entries.push({ text: Strings.Strings.session.signOut, icon: Icons.Icon.signOut, action: () => Session.signOut() });
        entries.push({ text: Strings.Strings.session.sleep, icon: Icons.Icon.weatherMoon, action: () => Session.suspend() });
        entries.push({ text: Strings.Strings.session.restart, icon: Icons.Icon.arrowClockwise, action: () => Session.restart() });
        entries.push({ text: Strings.Strings.session.shutDown, icon: Icons.Icon.power, action: () => Session.powerOff() });
        return entries;
    }
}
