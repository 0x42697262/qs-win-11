pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/shellDataSchema.mjs" as ShellDataSchema

Singleton {
    readonly property bool active: ShellData.values.doNotDisturb

    function setActive(value: bool): void {
        ShellData.update(ShellDataSchema.ShellDataKey.DoNotDisturb, value);
    }
}
