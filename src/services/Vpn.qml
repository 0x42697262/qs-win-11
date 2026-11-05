pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/system/connections.mjs" as ConnectionRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    property list<var> connections: []
    property bool watching: false
    readonly property bool available: Features.enabled.vpn && connections.length > 0
    readonly property list<var> activeConnections: connections.filter(connection => connection.active)
    readonly property bool connected: activeConnections.length > 0
    readonly property var preferred: connections.find(connection => connection.name === Settings.values.quickSettings.vpnConnection) ?? connections[0] ?? null
    readonly property string label: connected ? activeConnections[0].name : preferred ? preferred.name : ""

    function refresh(): void {
        if (!Features.enabled.vpn) {
            return;
        }
        lister.running = false;
        lister.running = true;
    }

    function toggle(): void {
        const targets = connected ? activeConnections : preferred ? [preferred] : [];
        const base = connected ? SystemCatalog.NmcliCommand.down : SystemCatalog.NmcliCommand.up;
        targets.forEach(connection => {
            Log.info(LogEvents.LogEvent.VpnToggled, { name: connection.name, active: !connected });
            Quickshell.execDetached(Array.prototype.slice.call(base).concat([connection.uuid]));
        });
        settle.restart();
    }

    Component.onCompleted: refresh()

    Connections {
        target: Features
        function onEnabledChanged(): void {
            root.refresh();
        }
    }

    Process {
        id: lister
        command: Array.prototype.slice.call(SystemCatalog.NmcliCommand.list)
        stdout: StdioCollector {
            onStreamFinished: root.connections = ConnectionRules.parseVpnConnections(text)
        }
    }

    Timer {
        id: settle
        interval: Settings.values.tuning.vpnSettleMs
        onTriggered: root.refresh()
    }

    Timer {
        running: root.watching && Features.enabled.vpn
        repeat: true
        interval: Settings.values.tuning.vpnRefreshMs
        onTriggered: root.refresh()
    }
}
