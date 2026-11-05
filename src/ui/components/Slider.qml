import QtQuick
import qs.src.ui.theme
import "../../domain/numbers.mjs" as Numbers

Item {
    id: root

    required property real value
    property real step: 0
    property bool enabledState: true
    readonly property bool dragging: mouse.pressed
    readonly property real shownValue: dragging ? dragValue : value
    property real dragValue: 0

    signal moved(real value)

    implicitHeight: Theme.size.sliderThumb
    implicitWidth: Theme.size.flyoutWidth / 2
    activeFocusOnTab: enabledState

    function valueAt(pointerX: real): real {
        const raw = Numbers.clamp((pointerX - thumb.width / 2) / (width - thumb.width), 0, 1);
        return step > 0 ? Numbers.roundToStep(raw, step) : raw;
    }

    function nudge(direction: int): void {
        moved(Numbers.clamp(value + direction * (step > 0 ? step : Theme.size.stroke / width), 0, 1));
    }

    Keys.onLeftPressed: nudge(-1)
    Keys.onRightPressed: nudge(1)

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: thumb.width / 2
        width: parent.width - thumb.width
        height: Theme.size.sliderTrack
        radius: height / 2
        color: Theme.colors.controlStrongFill

        Rectangle {
            width: parent.width * root.shownValue
            height: parent.height
            radius: parent.radius
            color: root.enabledState ? Theme.colors.accent : Theme.colors.accentDisabled
        }
    }

    Rectangle {
        id: thumb
        width: Theme.size.sliderThumb
        height: width
        radius: width / 2
        x: (root.width - width) * root.shownValue
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.colors.controlFill
        border.width: Theme.size.stroke
        border.color: Theme.colors.controlStroke

        Rectangle {
            anchors.centerIn: parent
            readonly property real innerSize: mouse.pressed ? Theme.size.sliderThumbInnerPressed : mouse.containsMouse ? Theme.size.sliderThumbInnerHover : Theme.size.sliderThumbInner
            width: innerSize
            height: innerSize
            radius: innerSize / 2
            color: root.enabledState ? Theme.colors.accent : Theme.colors.accentDisabled

            Behavior on width {
                NumberAnimation { duration: Theme.motion.fast }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabledState
        hoverEnabled: true
        onPressed: (event) => {
            root.dragValue = root.valueAt(event.x);
            root.moved(root.dragValue);
        }
        onPositionChanged: (event) => {
            if (pressed) {
                root.dragValue = root.valueAt(event.x);
                root.moved(root.dragValue);
            }
        }
        onWheel: (event) => root.nudge(event.angleDelta.y > 0 ? 1 : -1)
    }

    FocusRing {
        target: root
        visible: root.activeFocus
    }
}
