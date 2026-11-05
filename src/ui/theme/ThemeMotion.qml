import QtQuick

QtObject {
    required property bool reduced
    required property var values

    readonly property var durations: values.durations
    readonly property int fast: reduced ? durations.reduced : durations.fast
    readonly property int normal: reduced ? durations.reduced : durations.normal
    readonly property int slow: reduced ? durations.reduced : durations.slow
    readonly property int slower: reduced ? durations.reduced : durations.slower
    readonly property list<real> decelerate: curve(values.easing.decelerate)
    readonly property list<real> pointToPoint: curve(values.easing.pointToPoint)
    readonly property list<real> accelerate: curve(values.easing.accelerate)

    function curve(points: var): list<real> {
        return [points.x1, points.y1, points.x2, points.y2, 1, 1];
    }
}
