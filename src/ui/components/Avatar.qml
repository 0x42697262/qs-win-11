import QtQuick
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Rectangle {
    id: root

    property string source: ""
    property string initial: ""
    property real size: Theme.size.avatar

    implicitWidth: size
    implicitHeight: size
    radius: size / 2
    color: Theme.colors.controlStrongFill
    clip: true

    Label {
        visible: image.status !== Image.Ready
        anchors.centerIn: parent
        text: root.initial
        variant: root.size > Theme.size.avatar ? UiEnums.TextVariant.Title : UiEnums.TextVariant.BodyStrong
        color: Theme.colors.textOnAccent
    }

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        sourceSize.width: root.size
        sourceSize.height: root.size
        fillMode: Image.PreserveAspectCrop
    }
}
