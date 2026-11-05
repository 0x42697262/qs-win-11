import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

Interactive {
    id: root

    required property string appId
    property int appearIndex: -1

    signal menuRequested(string appId, real pointerX, real pointerY)

    implicitWidth: Theme.size.startTileWidth
    implicitHeight: Theme.size.startTileHeight
    acceptRightClick: true
    onActivated: {
        ShellState.close();
        Apps.launch(appId);
    }
    onRightClicked: (pointerX, pointerY) => menuRequested(appId, pointerX, pointerY)

    Appear {
        target: root
        index: root.appearIndex
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius.control
        color: root.pressed ? Theme.colors.subtleFillPressed : root.hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width - Theme.spacing.small * 2
        spacing: Theme.spacing.small

        Image {
            Layout.alignment: Qt.AlignHCenter
            source: Apps.iconSource(root.appId)
            sourceSize.width: Theme.iconSize.appTile
            sourceSize.height: Theme.iconSize.appTile
            Layout.preferredWidth: Theme.iconSize.appTile
            Layout.preferredHeight: Theme.iconSize.appTile
        }

        Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: Apps.displayName(root.appId)
            variant: UiEnums.TextVariant.Caption
            maximumLineCount: 2
            wrapMode: Text.Wrap
        }
    }
}
