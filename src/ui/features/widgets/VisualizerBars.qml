pragma ComponentBehavior: Bound
import QtQuick
import qs.src.services
import qs.src.ui.theme

Item {
    id: root

    readonly property int count: Math.max(1, Visualizer.bars.length)
    readonly property real barWidth: (width - Theme.size.visualizerBarGap * (count - 1)) / count

    implicitHeight: Theme.size.visualizerHeight

    Repeater {
        model: Visualizer.bars

        Rectangle {
            required property real modelData
            required property int index

            x: index * (root.barWidth + Theme.size.visualizerBarGap)
            width: root.barWidth
            height: Math.max(Theme.size.stroke, modelData * root.height)
            anchors.bottom: parent.bottom
            radius: Math.min(width / 2, Theme.radius.control)
            color: Theme.colors.accent

            Behavior on height {
                NumberAnimation { duration: Theme.motion.fast; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
            }
        }
    }
}
