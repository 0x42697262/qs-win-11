import QtQuick
import Quickshell.Io
import qs.src.config
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/settingsSchema.mjs" as Schema
import "../domain/ipc/settingsArguments.mjs" as SettingsArguments

IpcHandler {
    target: IpcCatalog.IpcTargetName.Settings

    function get(key: string): string {
        return SettingsArguments.formatValueAt(Settings.values, key);
    }

    function set(key: string, value: string): bool {
        return Settings.update(key, SettingsArguments.parseValueForKey(Schema.SETTING_DEFINITIONS, key, value));
    }

    function open(): void {
        SettingsWindow.show("");
    }

    function exportProfile(path: string): bool {
        return Profiles.exportTo(path, "");
    }

    function importProfile(path: string): bool {
        return Profiles.importFrom(path);
    }

    function reset(key: string): bool {
        return Settings.reset(key);
    }
}
