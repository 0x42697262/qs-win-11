pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.ui.theme

AcrylicSurface {
    id: root

    property list<var> items: []

    signal chosen

    width: Theme.size.contextMenuWidth
    height: column.implicitHeight + Theme.spacing.xSmall * 2
    z: 1

    MouseArea {
        anchors.fill: parent
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Theme.spacing.xSmall
        spacing: 0

        Repeater {
            model: root.items

            ListItem {
                required property var modelData

                Layout.fillWidth: true
                icon: modelData.icon ?? null
                title: modelData.text
                onActivated: {
                    root.chosen();
                    modelData.action();
                }
            }
        }
    }
}
