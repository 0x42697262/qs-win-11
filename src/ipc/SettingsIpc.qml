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

    function reset(key: string): bool {
        return Settings.update(key, SettingsArguments.defaultValueFor(Schema.SETTING_DEFINITIONS, key));
    }
}
