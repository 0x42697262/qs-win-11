pragma Singleton
import QtQuick
import qs.src.config
import Quickshell
import "../adapters/quickshell/objects.mjs" as QuickshellObjects
import Quickshell.Services.Pipewire
import "../domain/numbers.mjs" as Numbers

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property bool available: sink !== null && sink.audio !== null
    readonly property real volume: available ? sink.audio.volume : 0
    readonly property bool muted: available ? sink.audio.muted : true
    readonly property bool microphoneMuted: source !== null && source.audio !== null ? source.audio.muted : false
    readonly property list<PwNode> sinks: QuickshellObjects.valuesOf(Pipewire.nodes).filter(node => node.isSink && !node.isStream && node.audio !== null)
    readonly property string sinkName: sink ? (sink.description !== "" ? sink.description : sink.name) : ""

    function setVolume(value: real): void {
        if (available) {
            sink.audio.muted = false;
            sink.audio.volume = Numbers.clamp(value, 0, 1);
        }
    }

    function stepVolume(direction: int): void {
        setVolume(volume + direction * Settings.values.tuning.volumeStep);
    }

    function toggleMute(): void {
        if (available) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    function toggleMicrophoneMute(): void {
        if (source !== null && source.audio !== null) {
            source.audio.muted = !source.audio.muted;
        }
    }

    function setDefaultSink(node: PwNode): void {
        Pipewire.preferredDefaultAudioSink = node;
    }

    PwObjectTracker {
        objects: root.sinks.concat(root.source ? [root.source] : [])
    }
}
