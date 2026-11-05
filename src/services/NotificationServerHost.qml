import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../adapters/quickshell/objects.mjs" as QuickshellObjects

Scope {
    id: root

    readonly property list<Notification> tracked: QuickshellObjects.valuesOf(server.trackedNotifications)

    signal received(Notification notification)

    NotificationServer {
        id: server
        keepOnReload: true
        persistenceSupported: true
        bodySupported: true
        bodyMarkupSupported: false
        actionsSupported: true
        imageSupported: true
        onNotification: (notification) => {
            notification.tracked = true;
            root.received(notification);
        }
    }
}
