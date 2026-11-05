import QtQuick
import qs.src.ui.theme

QtObject {
    id: root

    required property Item target
    property int index: 0

    readonly property bool animated: index >= 0 && index < Theme.elevation.staggerLimit && Theme.motion.stagger > 0

    property Translate rise: Translate {}

    property SequentialAnimation sequence: SequentialAnimation {
        PauseAnimation { duration: Math.max(0, root.index) * Theme.motion.stagger }
        ParallelAnimation {
            NumberAnimation { target: root.target; property: "opacity"; to: 1; duration: Theme.motion.staggerItem; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
            NumberAnimation { target: root.rise; property: "y"; to: 0; duration: Theme.motion.staggerItem; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.emphasized }
        }
    }

    Component.onCompleted: {
        if (!animated) {
            return;
        }
        target.transform = [rise];
        target.opacity = 0;
        rise.y = Theme.elevation.staggerRise * Theme.scale;
        sequence.start();
    }

    Component.onDestruction: sequence.stop()
}
