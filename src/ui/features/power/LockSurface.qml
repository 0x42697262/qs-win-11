import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/strings.mjs" as Strings
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/logEvents.mjs" as LogEvents
import "../../../domain/catalog/tuning.mjs" as Tuning

WlSessionLockSurface {
    id: root

    property bool promptVisible: false
    property string errorText: ""
    readonly property var text: Strings.Strings.lock

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
        interval: Tuning.LOCK_FAILURE_COOLDOWN_MS
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: Theme.colors.accentPressed }
            GradientStop { position: 1; color: Theme.colors.micaBase }
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
            anchors.topMargin: parent.height / Tuning.LOCK_CLOCK_TOP_DIVISOR
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
    }
}
