pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/profiles.mjs" as ProfileCatalog

Singleton {
    readonly property string configDirectory: `${Environment.configHome}/${IpcCatalog.SHELL_CONFIG_NAME}`
    readonly property string stateDirectory: `${Environment.stateHome}/${IpcCatalog.SHELL_CONFIG_NAME}`
    readonly property string settingsFile: `${configDirectory}/settings.json`
    readonly property string profilesDirectory: `${configDirectory}/${ProfileCatalog.PROFILES_DIRECTORY}`
    readonly property string shellDataFile: `${stateDirectory}/state.json`
    readonly property string recentFilesFile: `${Environment.home}/.local/share/recently-used.xbel`

    function shellAsset(relativePath: string): string {
        return Quickshell.shellPath(relativePath);
    }
}
