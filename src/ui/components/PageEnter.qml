import QtQuick
import qs.src.ui.theme

QtObject {
    id: root

    required property Item target
    property real direction: 1
    property bool vertical: false
    property real distance: Theme.elevation.pageSlide * Theme.scale

    property Translate shift: Translate {}

    property ParallelAnimation entrance: ParallelAnimation {
        NumberAnimation { target: root.target; property: "opacity"; from: 0; to: 1; duration: Theme.motion.page; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        NumberAnimation { target: root.shift; property: root.vertical ? "y" : "x"; from: root.direction * root.distance; to: 0; duration: Theme.motion.page; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
    }

    function play(): void {
        if (Theme.motion.page <= 0) {
            return;
        }
        entrance.restart();
    }

    property Connections watcher: Connections {
        target: root.target
        function onVisibleChanged(): void {
            if (root.target.visible) {
                root.play();
            }
        }
    }

    Component.onCompleted: target.transform = [shift]
}
