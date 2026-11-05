pragma Singleton
import QtQuick
import Quickshell
import "../adapters/quickshell/objects.mjs" as QuickshellObjects
import Quickshell.Bluetooth

Singleton {
    readonly property var adapter: QuickshellObjects.defaultAdapterOf(Bluetooth)
    readonly property bool available: adapter !== null
    readonly property bool enabled: available && adapter.enabled
    readonly property list<var> devices: available ? QuickshellObjects.valuesOf(adapter.devices).filter(device => device.paired || device.connected).sort((left, right) => Number(right.connected) - Number(left.connected) || left.name.localeCompare(right.name)) : []
    readonly property int connectedCount: devices.filter(device => device.connected).length

    function setEnabled(value: bool): void {
        if (available) {
            adapter.enabled = value;
        }
    }

    function toggleConnection(device: var): void {
        if (device.connected) {
            device.disconnect();
        } else {
            device.connect();
        }
    }
}
