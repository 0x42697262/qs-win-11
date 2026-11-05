pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Networking
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/system/indicators.mjs" as Indicators
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/settingsSchema.mjs" as Schema
import "../../../domain/catalog/tuning.mjs" as Tuning

FocusScope {
    id: root

    property string page: UiEnums.QuickSettingsPage.Main
    property bool editing: false
    property string pskNetworkName: ""
    readonly property var text: Strings.Strings.quickSettings
    readonly property list<string> visibleTiles: Settings.values.quickSettings.tiles
    readonly property var tiles: ({
        wifi: {
            available: NetworkControl.wifiAvailable,
            icon: NetworkControl.wifiEnabled ? Icons.Icon.wifi1 : Icons.Icon.wifiOff,
            label: NetworkControl.activeNetwork ? NetworkControl.activeNetwork.name : text.wifi,
            checked: NetworkControl.wifiEnabled,
            toggle: () => NetworkControl.setWifiEnabled(!NetworkControl.wifiEnabled),
            page: UiEnums.QuickSettingsPage.Wifi,
        },
        bluetooth: {
            available: BluetoothControl.available,
            icon: BluetoothControl.enabled ? Icons.Icon.bluetooth : Icons.Icon.bluetoothDisabled,
            label: text.bluetooth,
            checked: BluetoothControl.enabled,
            toggle: () => BluetoothControl.setEnabled(!BluetoothControl.enabled),
            page: UiEnums.QuickSettingsPage.Bluetooth,
        },
        airplane: {
            available: NetworkControl.wifiAvailable || BluetoothControl.available,
            icon: Icons.Icon.airplane,
            label: text.airplane,
            checked: Indicators.airplaneModeActive(NetworkControl.wifiEnabled, BluetoothControl.enabled),
            toggle: () => {
                const turnOn = !Indicators.airplaneModeActive(NetworkControl.wifiEnabled, BluetoothControl.enabled);
                NetworkControl.setWifiEnabled(!turnOn);
                BluetoothControl.setEnabled(!turnOn);
            },
            page: "",
        },
        energySaver: {
            available: Power.powerProfilesAvailable,
            icon: Icons.Icon.leafOne,
            label: text.energySaver,
            checked: Power.energySaver,
            toggle: () => Power.setEnergySaver(!Power.energySaver),
            page: "",
        },
        nightLight: {
            available: NightLight.available,
            icon: Icons.Icon.weatherMoon,
            label: text.nightLight,
            checked: NightLight.active,
            toggle: () => NightLight.setActive(!NightLight.active),
            page: "",
        },
        darkMode: {
            available: true,
            icon: Icons.Icon.darkTheme,
            label: text.darkMode,
            checked: Theme.dark,
            toggle: () => Settings.update(Schema.SettingKey.ThemeMode, Theme.dark ? Enums.ThemeMode.Light : Enums.ThemeMode.Dark),
            page: "",
        },
        doNotDisturb: {
            available: Features.enabled.notifications,
            icon: Icons.Icon.alertSnooze,
            label: text.doNotDisturb,
            checked: DoNotDisturb.active,
            toggle: () => DoNotDisturb.setActive(!DoNotDisturb.active),
            page: "",
        },
    })
    readonly property list<string> shownTiles: (editing ? Object.keys(tiles) : visibleTiles).filter(name => tiles[name] && tiles[name].available)

    onPageChanged: NetworkControl.setScanning(page === UiEnums.QuickSettingsPage.Wifi)
    Component.onDestruction: NetworkControl.setScanning(false)

    FlyoutPanel {
        width: Theme.size.flyoutWidth
        height: content.implicitHeight + Theme.spacing.large * 2 + footer.height
        anchors.right: parent.right
        anchors.rightMargin: Theme.spacing.medium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium

        ColumnLayout {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Theme.spacing.large
            spacing: Theme.spacing.large

            Loader {
                active: Media.player !== null && root.page === UiEnums.QuickSettingsPage.Main
                visible: active
                Layout.fillWidth: true
                sourceComponent: MediaCard {
                    player: Media.player
                }
            }

            ColumnLayout {
                visible: root.page === UiEnums.QuickSettingsPage.Main
                Layout.fillWidth: true
                spacing: Theme.spacing.large

                GridLayout {
                    Layout.alignment: Qt.AlignHCenter
                    columns: Tuning.QUICK_SETTINGS_COLUMNS
                    columnSpacing: Theme.spacing.medium
                    rowSpacing: Theme.spacing.medium

                    Repeater {
                        model: root.shownTiles

                        QuickTile {
                            id: tile

                            required property string modelData
                            readonly property var definition: root.tiles[modelData]
                            readonly property bool included: root.visibleTiles.includes(modelData)

                            icon: root.editing ? (included ? Icons.Icon.checkmark : definition.icon) : definition.icon
                            label: definition.label
                            checked: root.editing ? included : definition.checked
                            hasDetails: !root.editing && definition.page !== ""
                            onToggled: root.editing ? Settings.update(Schema.SettingKey.QuickSettingsTiles, Indicators.toggleTileVisibility(root.visibleTiles, modelData)) : definition.toggle()
                            onDetailsRequested: root.page = definition.page
                        }
                    }
                }

                RowLayout {
                    visible: Brightness.available
                    Layout.fillWidth: true
                    spacing: Theme.spacing.small

                    FluentIcon { glyph: Icons.Icon.brightnessHigh }

                    Slider {
                        Layout.fillWidth: true
                        value: Brightness.fraction
                        step: Tuning.BRIGHTNESS_STEP_PERCENT / Tuning.PERCENT
                        onMoved: (value) => Brightness.setFraction(value)
                    }
                }

                RowLayout {
                    visible: Audio.available
                    Layout.fillWidth: true
                    spacing: Theme.spacing.small

                    IconButton {
                        icon: Indicators.volumeIcon(Audio.volume, Audio.muted)
                        onActivated: Audio.toggleMute()
                    }

                    Slider {
                        Layout.fillWidth: true
                        value: Audio.muted ? 0 : Audio.volume
                        step: Tuning.VOLUME_STEP
                        onMoved: (value) => Audio.setVolume(value)
                    }

                    IconButton {
                        icon: Icons.Icon.chevronRight
                        iconSize: Theme.iconSize.small
                        onActivated: root.page = UiEnums.QuickSettingsPage.Sound
                    }
                }
            }

            DetailPage {
                visible: root.page === UiEnums.QuickSettingsPage.Wifi
                Layout.fillWidth: true
                title: root.text.wifi
                toggleChecked: NetworkControl.wifiEnabled
                settingsLabel: root.text.moreWifiSettings
                settingsCommand: Settings.values.commands.networkSettings
                onBackRequested: root.page = UiEnums.QuickSettingsPage.Main
                onToggled: (checked) => NetworkControl.setWifiEnabled(checked)

                Label {
                    visible: NetworkControl.networks.length === 0
                    text: root.text.noNetworks
                    tone: UiEnums.TextTone.Secondary
                }

                Repeater {
                    model: NetworkControl.networks

                    ColumnLayout {
                        id: networkRow

                        required property var modelData
                        readonly property bool askingPassword: root.pskNetworkName === modelData.name

                        Layout.fillWidth: true
                        spacing: Theme.spacing.xSmall

                        ListItem {
                            Layout.fillWidth: true
                            icon: Indicators.networkIcon(true, false, networkRow.modelData.signalStrength, true)
                            title: networkRow.modelData.name
                            subtitle: networkRow.modelData.connected ? root.text.connected : networkRow.modelData.security === WifiSecurityType.Open ? root.text.open : root.text.secured
                            selected: networkRow.modelData.connected
                            onActivated: {
                                const needsPassword = !networkRow.modelData.known && !networkRow.modelData.connected && networkRow.modelData.security !== WifiSecurityType.Open;
                                if (needsPassword) {
                                    root.pskNetworkName = networkRow.modelData.name;
                                } else {
                                    NetworkControl.toggleConnection(networkRow.modelData);
                                }
                            }
                        }

                        RowLayout {
                            visible: networkRow.askingPassword
                            Layout.fillWidth: true
                            Layout.leftMargin: Theme.spacing.large

                            SearchBox {
                                id: password
                                Layout.fillWidth: true
                                icon: Icons.Icon.lockClosed
                                secret: true
                                onAccepted: connectButton.activated()
                            }

                            Button {
                                id: connectButton
                                text: root.text.connect
                                variant: UiEnums.ButtonVariant.Accent
                                onActivated: {
                                    networkRow.modelData.connectWithPsk(password.text);
                                    root.pskNetworkName = "";
                                }
                            }
                        }
                    }
                }
            }

            DetailPage {
                visible: root.page === UiEnums.QuickSettingsPage.Bluetooth
                Layout.fillWidth: true
                title: root.text.bluetooth
                toggleChecked: BluetoothControl.enabled
                settingsLabel: root.text.moreBluetoothSettings
                settingsCommand: Settings.values.commands.bluetoothSettings
                onBackRequested: root.page = UiEnums.QuickSettingsPage.Main
                onToggled: (checked) => BluetoothControl.setEnabled(checked)

                Label {
                    visible: BluetoothControl.devices.length === 0
                    text: root.text.noDevices
                    tone: UiEnums.TextTone.Secondary
                }

                Repeater {
                    model: BluetoothControl.devices

                    ListItem {
                        required property var modelData
                        Layout.fillWidth: true
                        icon: modelData.connected ? Icons.Icon.bluetoothConnected : Icons.Icon.bluetooth
                        title: modelData.name
                        subtitle: modelData.connected ? root.text.connected : root.text.paired
                        selected: modelData.connected
                        onActivated: BluetoothControl.toggleConnection(modelData)
                    }
                }
            }

            DetailPage {
                visible: root.page === UiEnums.QuickSettingsPage.Sound
                Layout.fillWidth: true
                title: root.text.soundOutput
                showToggle: false
                settingsLabel: root.text.moreSoundSettings
                settingsCommand: Settings.values.commands.soundSettings
                onBackRequested: root.page = UiEnums.QuickSettingsPage.Main

                Repeater {
                    model: Audio.sinks

                    ListItem {
                        required property PwNode modelData
                        Layout.fillWidth: true
                        icon: Icons.Icon.speaker2
                        title: modelData.description !== "" ? modelData.description : modelData.name
                        selected: Audio.sink === modelData
                        onActivated: Audio.setDefaultSink(modelData)
                    }
                }
            }
        }

        Rectangle {
            id: footer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.size.startFooterHeight
            color: Theme.colors.cardBackgroundSecondary
            bottomLeftRadius: Theme.radius.overlay
            bottomRightRadius: Theme.radius.overlay

            Divider { anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacing.large
                anchors.rightMargin: Theme.spacing.large
                spacing: Theme.spacing.small

                FluentIcon {
                    visible: Power.hasBattery
                    glyph: Power.icon
                }

                Label {
                    visible: Power.hasBattery
                    Layout.fillWidth: true
                    text: Power.statusText
                }

                Item {
                    visible: !Power.hasBattery
                    Layout.fillWidth: true
                }

                Button {
                    visible: root.editing
                    text: root.text.done
                    variant: UiEnums.ButtonVariant.Accent
                    onActivated: root.editing = false
                }

                IconButton {
                    visible: !root.editing && root.page === UiEnums.QuickSettingsPage.Main
                    icon: Icons.Icon.edit
                    onActivated: root.editing = true
                }

                IconButton {
                    visible: !root.editing && Features.enabled.settingsApp
                    icon: Icons.Icon.settings
                    onActivated: SettingsWindow.show("")
                }
            }
        }
    }
}
