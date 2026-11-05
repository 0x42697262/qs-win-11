import QtQuick

Item {
    id: root

    property bool enabledState: true
    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed
    property bool acceptRightClick: false
    property bool acceptMiddleClick: false

    signal activated
    signal rightClicked(real pointerX, real pointerY)
    signal middleClicked

    activeFocusOnTab: enabledState
    Keys.onReturnPressed: if (enabledState) activated()
    Keys.onEnterPressed: if (enabledState) activated()
    Keys.onSpacePressed: if (enabledState) activated()

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabledState
        acceptedButtons: Qt.LeftButton | (root.acceptRightClick ? Qt.RightButton : Qt.NoButton) | (root.acceptMiddleClick ? Qt.MiddleButton : Qt.NoButton)
        cursorShape: Qt.PointingHandCursor
        onClicked: (event) => {
            if (event.button === Qt.RightButton) {
                root.rightClicked(event.x, event.y);
            } else if (event.button === Qt.MiddleButton) {
                root.middleClicked();
            } else {
                root.activated();
            }
        }
    }

    FocusRing {
        target: root
        visible: root.activeFocus
    }
}
