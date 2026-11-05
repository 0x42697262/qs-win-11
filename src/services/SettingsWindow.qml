pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/settingsSchema.mjs" as Schema

Singleton {
    property bool open: false
    property string section: Schema.SettingsSection.Theme
    property string query: ""

    function show(targetSection: string): void {
        if (targetSection !== "") {
            section = targetSection;
        }
        query = "";
        open = true;
        ShellState.close();
    }

    function showSetting(key: string): void {
        const definition = Schema.SETTING_DEFINITIONS.find(candidate => candidate.key === key);
        if (definition) {
            section = definition.section;
        }
        query = key;
        open = true;
        ShellState.close();
    }
}
