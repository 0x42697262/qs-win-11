pragma Singleton
import QtQuick
import qs.src.config
import Quickshell
import "../adapters/quickshell/objects.mjs" as QuickshellObjects
import Quickshell.Networking
import "../domain/system/indicators.mjs" as Indicators

Singleton {
    id: root

    readonly property list<QtObject> devices: QuickshellObjects.valuesOf(Networking.devices)
    readonly property var wifiDevice: devices.find(device => device.type === DeviceType.Wifi) ?? null
    readonly property bool wiredConnected: devices.some(device => device.type === DeviceType.Wired && device.connected)
    readonly property bool wifiAvailable: wifiDevice !== null && Networking.wifiHardwareEnabled
    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property list<QtObject> networks: wifiDevice ? Indicators.sortNetworks(QuickshellObjects.valuesOf(wifiDevice.networks), Settings.values.tuning.networkListLimit) : []
    readonly property var activeNetwork: wifiDevice ? (QuickshellObjects.valuesOf(wifiDevice.networks).find(network => network.connected) ?? null) : null
    readonly property bool connected: wiredConnected || activeNetwork !== null
    readonly property var icon: Indicators.networkIcon(wifiEnabled, wiredConnected, activeNetwork ? activeNetwork.signalStrength : 0, activeNetwork !== null)

    function setWifiEnabled(enabled: bool): void {
        Networking.wifiEnabled = enabled;
    }

    function setScanning(scanning: bool): void {
        if (wifiDevice) {
            wifiDevice.scannerEnabled = scanning;
        }
    }

    function toggleConnection(network: var): void {
        if (network.connected) {
            network.disconnect();
        } else {
            network.connect();
        }
    }
}
