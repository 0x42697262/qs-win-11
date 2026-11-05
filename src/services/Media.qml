pragma Singleton
import QtQuick
import Quickshell
import "../adapters/quickshell/objects.mjs" as QuickshellObjects
import Quickshell.Services.Mpris

Singleton {
    readonly property list<MprisPlayer> players: QuickshellObjects.valuesOf(Mpris.players)
    readonly property MprisPlayer player: players.find(candidate => candidate.isPlaying) ?? (players.length > 0 ? players[0] : null)
}
