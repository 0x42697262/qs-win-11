pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    readonly property var text: Settings.values.text.notifications

    ColumnLayout {
        anchors.right: parent.right
        anchors.rightMargin: Theme.spacing.medium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium
        width: Theme.size.flyoutWidth
        spacing: Theme.spacing.medium

        FlyoutPanel {
            visible: Notifications.active
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(notificationColumn.implicitHeight + Theme.spacing.large * 2, Theme.size.notificationListHeight)

            ColumnLayout {
                id: notificationColumn
                anchors.fill: parent
                anchors.margins: Theme.spacing.large
                spacing: Theme.spacing.medium

                RowLayout {
                    Layout.fillWidth: true

                    Label { Layout.fillWidth: true; text: root.text.title; variant: UiEnums.TextVariant.BodyStrong }

                    IconButton {
                        icon: Icons.Icon.alertSnooze
                        filled: DoNotDisturb.active
                        iconColor: DoNotDisturb.active ? Theme.colors.accent : Theme.colors.textPrimary
                        onActivated: DoNotDisturb.setActive(!DoNotDisturb.active)
                    }

                    Button {
                        visible: Notifications.count > 0
                        text: root.text.clearAll
                        onActivated: Notifications.clearAll()
                    }
                }

                Label {
                    visible: Notifications.count === 0
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.spacing.large
                    Layout.bottomMargin: Theme.spacing.large
                    horizontalAlignment: Text.AlignHCenter
                    text: root.text.empty
                    tone: UiEnums.TextTone.Secondary
                }

                Flickable {
                    visible: Notifications.count > 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredHeight: list.implicitHeight
                    contentHeight: list.implicitHeight
                    clip: true

                    ColumnLayout {
                        id: list
                        width: parent.width
                        spacing: Theme.spacing.small

                        Repeater {
                            model: Notifications.groups

                            ColumnLayout {
                                id: group

                                required property var modelData

                                Layout.fillWidth: true
                                spacing: Theme.spacing.xSmall

                                Repeater {
                                    model: group.modelData.notifications

                                    NotificationCard {
                                        required property Notification modelData
                                        Layout.fillWidth: true
                                        notification: modelData
                                        onCloseRequested: Notifications.dismiss(modelData.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        FlyoutPanel {
            Layout.fillWidth: true
            Layout.preferredHeight: calendarColumn.implicitHeight + Theme.spacing.large * 2

            ColumnLayout {
                id: calendarColumn
                anchors.fill: parent
                anchors.margins: Theme.spacing.large
                spacing: Theme.spacing.small

                Label {
                    text: Clock.longDateText
                    variant: UiEnums.TextVariant.BodyStrong
                }

                Divider { Layout.fillWidth: true }

                CalendarView { Layout.fillWidth: true }
            }
        }
    }
}
