pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/settingsSchema.mjs" as Schema

Singleton {
    property bool open: false
    property string section: Schema.SettingsSection.Theme

    function show(targetSection: string): void {
        if (targetSection !== "") {
            section = targetSection;
        }
        open = true;
        ShellState.close();
    }
}
