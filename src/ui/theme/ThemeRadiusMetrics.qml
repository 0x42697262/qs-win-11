import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property real scale

    readonly property real control: Tokens.RADIUS.control * scale
    readonly property real overlay: Tokens.RADIUS.overlay * scale
    readonly property real round: Tokens.RADIUS.round * scale
}
