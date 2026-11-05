pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs.src.config
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/logEvents.mjs" as LogEvents

WlSessionLockSurface {
    id: root

    property bool promptVisible: false
    property string errorText: ""
    readonly property var text: Settings.values.text.lock
    readonly property var lockSettings: Settings.values.lockScreen
    readonly property bool showWallpaper: lockSettings.useWallpaper && Wallpaper.available
    readonly property bool blurred: promptVisible && showWallpaper && lockSettings.blurOnPrompt && (Appearance.mica || Appearance.acrylic)

    color: Theme.colors.micaBase

    function submit(): void {
        if (pam.active || cooldown.running) {
            return;
        }
        errorText = "";
        pam.start();
    }

    PamContext {
        id: pam
        onPamMessage: {
            if (responseRequired) {
                respond(password.text);
            }
        }
        onCompleted: (result) => {
            if (result === PamResult.Success) {
                password.text = "";
                root.promptVisible = false;
                LockState.unlock();
            } else {
                Log.warning(LogEvents.LogEvent.LockAuthFailed, { result });
                root.errorText = root.text.incorrect;
                password.text = "";
                cooldown.restart();
            }
        }
        onError: (error) => {
            Log.error(LogEvents.LogEvent.LockAuthFailed, { error });
            root.errorText = root.text.failed;
            cooldown.restart();
        }
    }

    Timer {
        id: cooldown
        interval: Settings.values.tuning.lockFailureCooldownMs
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.colors.accentPressed }
            GradientStop { position: 1; color: Theme.colors.micaBase }
        }
    }

    Image {
        id: wallpaper
        visible: root.showWallpaper && !root.blurred
        anchors.fill: parent
        source: root.showWallpaper ? Wallpaper.source : ""
        fillMode: Wallpaper.fillMode
        asynchronous: true
    }

    MultiEffect {
        visible: root.blurred
        anchors.fill: wallpaper
        source: wallpaper
        blurEnabled: true
        blur: 1
        blurMax: Settings.values.backdrop.micaBlurRadius
        autoPaddingEnabled: false
    }

    Rectangle {
        anchors.fill: parent
        color: Settings.values.colors.dim
        opacity: root.promptVisible ? Settings.values.effects.dimOpacity : 0

        Behavior on opacity {
            NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.promptVisible = true
    }

    FocusScope {
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event) => {
            if (!root.promptVisible) {
                root.promptVisible = true;
                event.accepted = true;
            }
        }

        ColumnLayout {
            visible: !root.promptVisible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / Settings.values.tuning.lockClockTopDivisor
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: Clock.timeText
                variant: UiEnums.TextVariant.Display
                font.weight: Theme.weightSemibold
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: Clock.longDateText
                variant: UiEnums.TextVariant.Subtitle
            }
        }

        ColumnLayout {
            visible: root.promptVisible
            anchors.centerIn: parent
            spacing: Theme.spacing.large

            Avatar {
                Layout.alignment: Qt.AlignHCenter
                size: Theme.size.avatarLarge
                source: UserAccount.avatarSource
                initial: UserAccount.initial
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: UserAccount.name
                variant: UiEnums.TextVariant.Title
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacing.small

                SearchBox {
                    id: password
                    Layout.preferredWidth: Theme.size.lockFieldWidth
                    focus: root.promptVisible
                    icon: Icons.Icon.lockClosed
                    secret: true
                    placeholder: root.text.password
                    onAccepted: root.submit()
                }

                IconButton {
                    icon: Icons.Icon.chevronRight
                    variant: UiEnums.ButtonVariant.Accent
                    enabledState: !pam.active && !cooldown.running
                    onActivated: root.submit()
                }
            }

            Label {
                visible: root.errorText !== ""
                Layout.alignment: Qt.AlignHCenter
                text: root.errorText
                tone: UiEnums.TextTone.Critical
            }
        }

        Label {
            visible: !root.promptVisible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.spacing.xxxLarge
            text: root.text.pressAnyKey
            tone: UiEnums.TextTone.Secondary
        }

        ColumnLayout {
            visible: !root.promptVisible
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: Theme.spacing.xxxLarge
            spacing: Theme.spacing.medium

            RowLayout {
                visible: root.lockSettings.showWeather && Weather.available
                spacing: Theme.spacing.small

                FluentIcon {
                    glyph: Weather.current ? Weather.current.icon : null
                    size: Theme.iconSize.large
                }

                ColumnLayout {
                    spacing: 0

                    Label {
                        text: Weather.temperatureText
                        variant: UiEnums.TextVariant.Subtitle
                    }

                    Label {
                        text: Weather.current ? Weather.current.text : ""
                        tone: UiEnums.TextTone.Secondary
                    }
                }
            }

            Card {
                visible: root.lockSettings.showMedia && Media.player !== null
                Layout.preferredWidth: Theme.size.lockFieldWidth
                implicitHeight: mediaRow.implicitHeight + Theme.spacing.medium * 2
                color: Theme.surfaceFill

                RowLayout {
                    id: mediaRow
                    anchors.fill: parent
                    anchors.margins: Theme.spacing.medium
                    spacing: Theme.spacing.small

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: Media.player ? (Media.player.trackTitle !== "" ? Media.player.trackTitle : Media.player.identity) : ""
                            variant: UiEnums.TextVariant.BodyStrong
                        }

                        Label {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: Media.player ? Media.player.trackArtist : ""
                            tone: UiEnums.TextTone.Secondary
                        }
                    }

                    IconButton {
                        icon: Media.player && Media.player.isPlaying ? Icons.Icon.pause : Icons.Icon.play
                        onActivated: Media.player.togglePlaying()
                    }
                }
            }
        }

        RowLayout {
            visible: !root.promptVisible && root.lockSettings.showStatus
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Theme.spacing.xxxLarge
            spacing: Theme.spacing.large

            RowLayout {
                visible: Features.enabled.notifications && Notifications.count > 0
                spacing: Theme.spacing.xSmall

                FluentIcon { glyph: Icons.Icon.alert }

                Label { text: String(Notifications.count) }
            }

            FluentIcon { glyph: NetworkControl.icon }

            RowLayout {
                visible: Power.hasBattery
                spacing: Theme.spacing.xSmall

                FluentIcon { glyph: Power.icon }

                Label { text: `${Power.percent}%` }
            }
        }
    }
}
