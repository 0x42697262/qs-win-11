pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import qs.src.services
import "../../../adapters/quickshell/objects.mjs" as QuickshellObjects
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/notifications/notifications.mjs" as NotificationRules
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/units.mjs" as Units

Card {
    id: root

    required property Notification notification
    property bool showTime: true
    readonly property bool hovered: hover.hovered
    readonly property list<NotificationAction> actions: QuickshellObjects.toArray(notification.actions)
    readonly property list<NotificationAction> buttonActions: actions.filter(action => action.identifier !== Units.DEFAULT_NOTIFICATION_ACTION)
    readonly property string appIcon: notification.appIcon !== "" ? Quickshell.iconPath(notification.appIcon, true) : Apps.iconSource(notification.desktopEntry !== "" ? notification.desktopEntry : notification.appName)

    signal closeRequested

    implicitHeight: column.implicitHeight + Theme.spacing.medium * 2
    color: Theme.colors.flyoutBackground
    border.color: notification.urgency === NotificationUrgency.Critical ? Theme.colors.critical : Theme.colors.cardStroke

    HoverHandler {
        id: hover
    }

    TapHandler {
        onTapped: {
            const defaultAction = root.actions.find(action => action.identifier === Units.DEFAULT_NOTIFICATION_ACTION);
            if (defaultAction) {
                defaultAction.invoke();
            }
        }
    }

    ColumnLayout {
        id: column
        anchors.fill: parent
        anchors.margins: Theme.spacing.medium
        spacing: Theme.spacing.small

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.small

            Image {
                visible: root.appIcon !== ""
                source: root.appIcon
                sourceSize.width: Theme.iconSize.medium
                sourceSize.height: Theme.iconSize.medium
                Layout.preferredWidth: Theme.iconSize.medium
                Layout.preferredHeight: Theme.iconSize.medium
            }

            Label {
                Layout.fillWidth: true
                text: root.notification.appName
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Secondary
            }

            Label {
                visible: root.showTime
                text: NotificationRules.relativeTime(Clock.nowMs, Notifications.receivedAt[root.notification.id] ?? Clock.nowMs, Settings.values.text.time)
                variant: UiEnums.TextVariant.Caption
                tone: UiEnums.TextTone.Tertiary
            }

            IconButton {
                icon: Icons.Icon.dismiss
                iconSize: Theme.iconSize.small
                buttonSize: Theme.iconSize.xLarge
                onActivated: root.closeRequested()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing.medium

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing.xxSmall

                Label {
                    Layout.fillWidth: true
                    text: root.notification.summary
                    variant: UiEnums.TextVariant.BodyStrong
                }

                Label {
                    Layout.fillWidth: true
                    visible: text !== ""
                    text: root.notification.body
                    wrapMode: Text.Wrap
                    maximumLineCount: Settings.values.tuning.notificationBodyLines
                    tone: UiEnums.TextTone.Secondary
                }
            }

            Image {
                visible: root.notification.image !== ""
                source: root.notification.image
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: Theme.size.notificationImage
                sourceSize.height: Theme.size.notificationImage
                Layout.preferredWidth: Theme.size.notificationImage
                Layout.preferredHeight: Theme.size.notificationImage
            }
        }

        RowLayout {
            visible: root.buttonActions.length > 0
            Layout.fillWidth: true
            spacing: Theme.spacing.small

            Repeater {
                model: root.buttonActions

                Button {
                    required property NotificationAction modelData
                    Layout.fillWidth: true
                    text: modelData.text
                    onActivated: modelData.invoke()
                }
            }
        }
    }
}
