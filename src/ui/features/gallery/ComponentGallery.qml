import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/strings.mjs" as Strings

PanelWindow {
    id: root

    property bool toggleState: true
    property real sliderValue: 0.5

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: column.implicitHeight + Theme.spacing.xxLarge * 2
    color: Theme.colors.micaBase
    WlrLayershell.layer: WlrLayer.Bottom
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Theme.spacing.xxLarge
        spacing: Theme.spacing.large

        Label { text: Strings.Strings.gallery.componentGallery; variant: UiEnums.TextVariant.Title }

        RowLayout {
            spacing: Theme.spacing.medium
            Button { text: Strings.Strings.gallery.standard }
            Button { text: Strings.Strings.gallery.accent; variant: UiEnums.ButtonVariant.Accent }
            Button { text: Strings.Strings.gallery.subtle; variant: UiEnums.ButtonVariant.Subtle; icon: Icons.Icon.settings }
            Button { text: Strings.Strings.gallery.disabled; enabledState: false }
            IconButton { icon: Icons.Icon.power }
            IconButton { icon: Icons.Icon.edit; variant: UiEnums.ButtonVariant.Standard }
            ToggleSwitch { checked: root.toggleState; onToggled: (checked) => root.toggleState = checked }
            ToggleSwitch { checked: false }
            Slider { value: root.sliderValue; onMoved: (value) => root.sliderValue = value }
        }

        RowLayout {
            spacing: Theme.spacing.medium
            QuickTile { icon: Icons.Icon.wifi1; label: Strings.Strings.gallery.wifi; checked: true; hasDetails: true }
            QuickTile { icon: Icons.Icon.bluetooth; label: Strings.Strings.gallery.bluetooth; checked: false; hasDetails: true }
            QuickTile { icon: Icons.Icon.airplane; label: Strings.Strings.gallery.airplaneMode; checked: false }
            QuickTile { icon: Icons.Icon.leafOne; label: Strings.Strings.gallery.energySaver; checked: true; enabledState: false }
        }

        RowLayout {
            spacing: Theme.spacing.large

            AcrylicSurface {
                Layout.preferredWidth: Theme.size.flyoutWidth
                Layout.preferredHeight: surfaceColumn.implicitHeight + Theme.spacing.large * 2

                ColumnLayout {
                    id: surfaceColumn
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.large
                    spacing: Theme.spacing.small
                    SearchBox { Layout.fillWidth: true; placeholder: Strings.Strings.gallery.typeHereToSearch }
                    ListItem { Layout.fillWidth: true; icon: Icons.Icon.folder; title: Strings.Strings.gallery.documents; subtitle: Strings.Strings.gallery.folder }
                    ListItem { Layout.fillWidth: true; icon: Icons.Icon.document; title: Strings.Strings.gallery.selectedItem; selected: true }
                    Divider { Layout.fillWidth: true }
                    ProgressBar { Layout.fillWidth: true; value: 0.5 }
                }
            }

            ColumnLayout {
                spacing: Theme.spacing.small
                Layout.preferredWidth: Theme.size.flyoutWidth
                InfoBar { Layout.fillWidth: true; title: Strings.Strings.gallery.informational; message: Strings.Strings.gallery.someSettingsWereIgnored }
                InfoBar { Layout.fillWidth: true; severity: UiEnums.InfoSeverity.Warning; title: Strings.Strings.gallery.warning; message: Strings.Strings.gallery.batteryIsLow }
                InfoBar { Layout.fillWidth: true; severity: UiEnums.InfoSeverity.Error; title: Strings.Strings.gallery.error; message: Strings.Strings.gallery.couldNotConnect }
            }

            Card {
                Layout.preferredWidth: Theme.size.flyoutWidth / 2
                Layout.preferredHeight: Theme.size.flyoutWidth / 2
                ColumnLayout {
                    anchors.centerIn: parent
                    FluentIcon { glyph: Icons.Icon.weatherPartlyCloudyDay; size: Theme.iconSize.hero; Layout.alignment: Qt.AlignHCenter }
                    Label { text: Strings.Strings.gallery.captionText; variant: UiEnums.TextVariant.Caption; tone: UiEnums.TextTone.Secondary; Layout.alignment: Qt.AlignHCenter }
                    Label { text: Strings.Strings.gallery.accentText; tone: UiEnums.TextTone.Accent; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }
}
