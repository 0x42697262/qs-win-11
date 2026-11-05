pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/media/visualizer.mjs" as VisualizerRules
import "../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    id: root

    property bool watching: false
    property list<real> bars: []
    readonly property var tuning: Settings.values.tuning
    readonly property bool running: Features.enabled.visualizer && watching && Media.player !== null && Media.player.isPlaying
    readonly property string configPath: `${Environment.runtimeDirectory}/${SystemCatalog.CAVA_CONFIG_FILE}`

    onRunningChanged: if (!running) bars = []

    Process {
        running: root.running
        command: [SystemCatalog.SystemBinary.Shell, "-c", `printf '%s' "$1" > "$2" && exec ${SystemCatalog.SystemBinary.Cava} -p "$2"`, SystemCatalog.SystemBinary.Shell, VisualizerRules.cavaConfig(root.tuning.visualizerBars, root.tuning.visualizerFramerate, root.tuning.visualizerRange), root.configPath]
        stdout: SplitParser {
            onRead: (line) => root.bars = VisualizerRules.parseCavaFrame(line, root.tuning.visualizerRange)
        }
    }
}
