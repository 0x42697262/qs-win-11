import QtQuick
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

ColumnLayout {
    id: root

    required property string title
    property bool showToggle: true
    property bool toggleChecked: false
    property string settingsLabel: ""
    property string settingsCommand: ""
    default property alias pageContent: body.data

    signal backRequested
    signal toggled(bool checked)

    spacing: Theme.spacing.medium

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing.small

        IconButton {
            icon: Icons.Icon.chevronLeft
            onActivated: root.backRequested()
        }

        Label {
            Layout.fillWidth: true
            text: root.title
            variant: UiEnums.TextVariant.Subtitle
        }

        ToggleSwitch {
            visible: root.showToggle
            checked: root.toggleChecked
            onToggled: (checked) => root.toggled(checked)
        }
    }

    Flickable {
        Layout.fillWidth: true
        Layout.preferredHeight: Math.min(body.implicitHeight, Theme.size.listMaxHeight)
        contentHeight: body.implicitHeight
        clip: true

        ColumnLayout {
            id: body
            width: parent.width
            spacing: Theme.spacing.xxSmall
        }
    }

    Divider {
        visible: root.settingsCommand !== ""
        Layout.fillWidth: true
    }

    Button {
        visible: root.settingsCommand !== ""
        text: root.settingsLabel
        variant: UiEnums.ButtonVariant.Subtle
        onActivated: {
            ShellState.close();
            Session.runCommandLine(root.settingsCommand);
        }
    }
}
