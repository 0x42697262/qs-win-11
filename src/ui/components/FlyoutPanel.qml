import QtQuick

AcrylicSurface {
    id: root

    default property alias panelContent: inner.data

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onWheel: (event) => event.accepted = true
    }

    Item {
        id: inner
        anchors.fill: parent
    }
}
