pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/system/indicators.mjs" as Indicators
import "../../../domain/system/stats.mjs" as StatsRules
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

WidgetCard {
    id: root

    readonly property var text: Settings.values.text.widgets
    readonly property list<string> suffixes: text.byteSuffixes.split(" ")
    readonly property var rows: ({
        cpu: { available: true, label: text.cpu, value: `${Indicators.toPercent(SystemStats.cpu)}%`, history: SystemStats.cpuHistory, fraction: -1 },
        gpu: { available: SystemStats.gpu >= 0, label: text.gpu, value: `${Indicators.toPercent(Math.max(0, SystemStats.gpu))}%`, history: SystemStats.gpuHistory, fraction: -1 },
        memory: { available: true, label: text.memory, value: `${Indicators.toPercent(SystemStats.memory)}%`, history: SystemStats.memoryHistory, fraction: -1 },
        storage: {
            available: SystemStats.disk.total > 0,
            label: text.storage,
            value: text.usedOf.replace(Strings.Placeholder.used, StatsRules.formatBytes(SystemStats.disk.used, suffixes)).replace(Strings.Placeholder.total, StatsRules.formatBytes(SystemStats.disk.total, suffixes)),
            history: [],
            fraction: SystemStats.disk.total > 0 ? SystemStats.disk.used / SystemStats.disk.total : 0,
        },
        network: {
            available: true,
            label: text.network,
            value: text.networkRate.replace(Strings.Placeholder.down, StatsRules.formatBytes(SystemStats.netRate.rx, suffixes)).replace(Strings.Placeholder.up, StatsRules.formatBytes(SystemStats.netRate.tx, suffixes)),
            history: SystemStats.netHistory,
            fraction: -1,
        },
        battery: { available: Power.hasBattery, label: text.battery, value: `${Power.percent}%`, history: [], fraction: Power.fraction },
    })
    readonly property list<string> shown: Settings.values.widgets.performanceMetrics.filter(name => rows[name] && rows[name].available)

    title: text.performance

    Repeater {
        model: root.shown

        RowLayout {
            id: metric

            required property string modelData
            readonly property var row: root.rows[modelData]
            readonly property bool usesHistory: row.fraction < 0

            Layout.fillWidth: true
            spacing: Theme.spacing.medium

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Label {
                    text: metric.row.label
                    variant: UiEnums.TextVariant.Caption
                    tone: UiEnums.TextTone.Secondary
                }

                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: metric.row.value
                    variant: UiEnums.TextVariant.BodyStrong
                }
            }

            Sparkline {
                visible: metric.usesHistory
                values: metric.row.history
                maximum: metric.modelData === Enums.PerformanceMetric.Network ? 0 : 1
            }

            ProgressBar {
                visible: !metric.usesHistory
                Layout.preferredWidth: Theme.size.sparklineWidth
                value: Math.max(0, metric.row.fraction)
            }
        }
    }
}
