pragma Singleton
import QtQuick
import qs.src.config
import Quickshell
import Quickshell.Io
import "../domain/system/stats.mjs" as StatsRules
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    id: root

    property bool watching: false
    property var previousSample: null
    property real cpu: 0
    property real memory: 0

    function sample(): void {
        procStat.reload();
        meminfo.reload();
        const next = StatsRules.parseCpuSample(procStat.text());
        if (previousSample) {
            cpu = StatsRules.cpuUsage(previousSample, next);
        }
        previousSample = next;
        memory = StatsRules.memoryUsage(meminfo.text());
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

    Timer {
        running: root.watching
        repeat: true
        triggeredOnStart: true
        interval: Appearance.interval(Settings.values.tuning.systemStatsRefreshMs)
        onTriggered: root.sample()
    }
}
