import QtQuick
import QtQuick.Shapes
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import "../../domain/shape/corners.mjs" as CornerRules

Item {
    id: root

    property real radius: Theme.radius.control
    property color color: Theme.colors.transparent
    property real borderWidth: 0
    property color borderColor: Theme.colors.transparent
    property real smoothingOverride: -1
    property bool animateColor: true
    readonly property var corners: Settings.values.corners
    readonly property real smoothing: smoothingOverride >= 0 ? smoothingOverride : corners.smoothing
    readonly property string path: CornerRules.cornerPath(corners.model, width, height, radius, { smoothing, exponent: corners.exponent, segments: corners.segments })

    Behavior on color {
        enabled: root.animateColor
        ColorAnimation { duration: Theme.motion.hover; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
    }

    Rectangle {
        visible: !Appearance.continuousCorners
        anchors.fill: parent
        radius: root.radius
        color: root.color
        border.width: root.borderWidth
        border.color: root.borderColor
    }

    Shape {
        visible: Appearance.continuousCorners && root.width > 0 && root.height > 0
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.color
            strokeColor: root.borderWidth > 0 ? root.borderColor : Theme.colors.transparent
            strokeWidth: root.borderWidth

            PathSvg {
                path: root.path
            }
        }
    }
}
