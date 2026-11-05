import QtQuick
import qs.src.config
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

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

        Label { text: Settings.values.text.gallery.componentGallery; variant: UiEnums.TextVariant.Title }

        RowLayout {
            spacing: Theme.spacing.medium
            Button { text: Settings.values.text.gallery.standard }
            Button { text: Settings.values.text.gallery.accent; variant: UiEnums.ButtonVariant.Accent }
            Button { text: Settings.values.text.gallery.subtle; variant: UiEnums.ButtonVariant.Subtle; icon: Icons.Icon.settings }
            Button { text: Settings.values.text.gallery.disabled; enabledState: false }
            IconButton { icon: Icons.Icon.power }
            IconButton { icon: Icons.Icon.edit; variant: UiEnums.ButtonVariant.Standard }
            ToggleSwitch { checked: root.toggleState; onToggled: (checked) => root.toggleState = checked }
            ToggleSwitch { checked: false }
            Slider { value: root.sliderValue; onMoved: (value) => root.sliderValue = value }
        }

        RowLayout {
            spacing: Theme.spacing.medium
            QuickTile { icon: Icons.Icon.wifi1; label: Settings.values.text.gallery.wifi; checked: true; hasDetails: true }
            QuickTile { icon: Icons.Icon.bluetooth; label: Settings.values.text.gallery.bluetooth; checked: false; hasDetails: true }
            QuickTile { icon: Icons.Icon.airplane; label: Settings.values.text.gallery.airplaneMode; checked: false }
            QuickTile { icon: Icons.Icon.leafOne; label: Settings.values.text.gallery.energySaver; checked: true; enabledState: false }
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
                    SearchBox { Layout.fillWidth: true; placeholder: Settings.values.text.gallery.typeHereToSearch }
                    ListItem { Layout.fillWidth: true; icon: Icons.Icon.folder; title: Settings.values.text.gallery.documents; subtitle: Settings.values.text.gallery.folder }
                    ListItem { Layout.fillWidth: true; icon: Icons.Icon.document; title: Settings.values.text.gallery.selectedItem; selected: true }
                    Divider { Layout.fillWidth: true }
                    ProgressBar { Layout.fillWidth: true; value: 0.5 }
                }
            }

            ColumnLayout {
                spacing: Theme.spacing.small
                Layout.preferredWidth: Theme.size.flyoutWidth
                InfoBar { Layout.fillWidth: true; title: Settings.values.text.gallery.informational; message: Settings.values.text.gallery.someSettingsWereIgnored }
                InfoBar { Layout.fillWidth: true; severity: UiEnums.InfoSeverity.Warning; title: Settings.values.text.gallery.warning; message: Settings.values.text.gallery.batteryIsLow }
                InfoBar { Layout.fillWidth: true; severity: UiEnums.InfoSeverity.Error; title: Settings.values.text.gallery.error; message: Settings.values.text.gallery.couldNotConnect }
            }

            Card {
                Layout.preferredWidth: Theme.size.flyoutWidth / 2
                Layout.preferredHeight: Theme.size.flyoutWidth / 2
                ColumnLayout {
                    anchors.centerIn: parent
                    FluentIcon { glyph: Icons.Icon.weatherPartlyCloudyDay; size: Theme.iconSize.hero; Layout.alignment: Qt.AlignHCenter }
                    Label { text: Settings.values.text.gallery.captionText; variant: UiEnums.TextVariant.Caption; tone: UiEnums.TextTone.Secondary; Layout.alignment: Qt.AlignHCenter }
                    Label { text: Settings.values.text.gallery.accentText; tone: UiEnums.TextTone.Accent; Layout.alignment: Qt.AlignHCenter }
                }
            }
        }
    }
}
