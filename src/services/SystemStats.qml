pragma Singleton
import QtQuick
import qs.src.config
import Quickshell
import Quickshell.Io
import "../domain/system/stats.mjs" as StatsRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/units.mjs" as Units

Singleton {
    id: root

    property bool watching: false
    property var previousSample: null
    property var previousNet: null
    property real previousNetAt: 0
    property real cpu: 0
    property real memory: 0
    property real gpu: -1
    property var disk: ({ used: 0, total: 0 })
    property var netRate: ({ rx: 0, tx: 0 })
    property list<real> cpuHistory: []
    property list<real> memoryHistory: []
    property list<real> gpuHistory: []
    property list<real> netHistory: []
    readonly property int historyLength: Settings.values.tuning.statsHistoryLength

    function sample(): void {
        procStat.reload();
        meminfo.reload();
        netDev.reload();
        const next = StatsRules.parseCpuSample(procStat.text());
        if (previousSample) {
            cpu = StatsRules.cpuUsage(previousSample, next);
            cpuHistory = StatsRules.pushHistory(cpuHistory, cpu, historyLength);
        }
        previousSample = next;
        memory = StatsRules.memoryUsage(meminfo.text());
        memoryHistory = StatsRules.pushHistory(memoryHistory, memory, historyLength);
        const now = Date.now();
        const net = StatsRules.parseNetDev(netDev.text());
        if (previousNet) {
            netRate = StatsRules.netRate(previousNet, net, (now - previousNetAt) / Units.MILLISECONDS_PER_SECOND);
            netHistory = StatsRules.pushHistory(netHistory, netRate.rx + netRate.tx, historyLength);
        }
        previousNet = net;
        previousNetAt = now;
        gpuReader.running = true;
        diskReader.command = [SystemCatalog.SystemBinary.Df].concat(Array.prototype.slice.call(SystemCatalog.DF_ARGUMENTS), [Settings.values.widgets.storagePath]);
        diskReader.running = true;
    }

    FileView {
        id: procStat
        path: SystemCatalog.SystemPath.ProcStat
        blockLoading: true
    }

    FileView {
        id: meminfo
        path: SystemCatalog.SystemPath.ProcMeminfo
        blockLoading: true
    }

    FileView {
        id: netDev
        path: SystemCatalog.SystemPath.ProcNetDev
        blockLoading: true
    }

    Process {
        id: gpuReader
        command: Array.prototype.slice.call(SystemCatalog.GPU_USAGE_COMMAND)
        stdout: StdioCollector {
            onStreamFinished: {
                const usage = StatsRules.parseGpuUsage(text);
                root.gpu = usage === null ? -1 : usage;
                if (usage !== null) {
                    root.gpuHistory = StatsRules.pushHistory(root.gpuHistory, usage, root.historyLength);
                }
            }
        }
    }

    Process {
        id: diskReader
        stdout: StdioCollector {
            onStreamFinished: root.disk = StatsRules.parseDiskUsage(text)
        }
    }

    Timer {
        running: root.watching
        repeat: true
        triggeredOnStart: true
        interval: Appearance.interval(Settings.values.tuning.systemStatsRefreshMs)
        onTriggered: root.sample()
    }
}
