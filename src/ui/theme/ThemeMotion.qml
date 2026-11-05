import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property bool reduced

    readonly property int fast: reduced ? Tokens.MOTION_MS.reduced : Tokens.MOTION_MS.fast
    readonly property int normal: reduced ? Tokens.MOTION_MS.reduced : Tokens.MOTION_MS.normal
    readonly property int slow: reduced ? Tokens.MOTION_MS.reduced : Tokens.MOTION_MS.slow
    readonly property int slower: reduced ? Tokens.MOTION_MS.reduced : Tokens.MOTION_MS.slower
    readonly property list<real> decelerate: Tokens.EASING_CURVES.decelerate
    readonly property list<real> pointToPoint: Tokens.EASING_CURVES.pointToPoint
    readonly property list<real> accelerate: Tokens.EASING_CURVES.accelerate
}
