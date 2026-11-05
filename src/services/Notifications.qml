pragma ComponentBehavior: Bound
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.src.config
import "../domain/notifications/notifications.mjs" as NotificationRules
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property bool active: host.item !== null
    readonly property list<Notification> tracked: (host.item as NotificationServerHost)?.tracked ?? []
    property var receivedAt: ({})
    property list<int> toastIds: []
    readonly property list<var> entries: tracked.map(notification => ({ id: notification.id, appName: notification.appName, receivedAtMs: receivedAt[notification.id] ?? 0 }))
    readonly property list<var> groups: NotificationRules.groupByApp(entries).map(group => ({ appName: group.appName, notifications: group.ids.map(notificationId => byId(notificationId)).filter(notification => notification !== null) }))
    readonly property list<Notification> toasts: toastIds.map(notificationId => byId(notificationId)).filter(notification => notification !== null)
    readonly property int count: tracked.length

    function byId(notificationId: int): Notification {
        return tracked.find(notification => notification.id === notificationId) ?? null;
    }

    function dismiss(notificationId: int): void {
        byId(notificationId)?.dismiss();
        hideToast(notificationId);
    }

    function dismissGroup(appName: string): void {
        tracked.filter(notification => notification.appName === appName).forEach(notification => notification.dismiss());
    }

    function clearAll(): void {
        tracked.slice().forEach(notification => notification.dismiss());
        toastIds = [];
    }

    function hideToast(notificationId: int): void {
        toastIds = toastIds.filter(candidate => candidate !== notificationId);
    }

    function handleReceived(notification: Notification): void {
        const times = Object.assign({}, receivedAt);
        times[notification.id] = Date.now();
        receivedAt = times;
        Log.info(LogEvents.LogEvent.NotificationReceived, { appName: notification.appName, urgency: notification.urgency });
        const critical = notification.urgency === NotificationUrgency.Critical;
        if (!DoNotDisturb.active || critical) {
            toastIds = [notification.id].concat(toastIds.filter(candidate => candidate !== notification.id));
        }
        trimHistory();
    }

    function trimHistory(): void {
        const overflow = NotificationRules.idsBeyondLimit(entries, Settings.values.notifications.historyLimit);
        if (overflow.length > 0) {
            Log.info(LogEvents.LogEvent.NotificationsTrimmed, { count: overflow.length });
            overflow.forEach(notificationId => byId(notificationId)?.dismiss());
        }
    }

    onTrackedChanged: {
        const alive = new Set(tracked.map(notification => notification.id));
        toastIds = toastIds.filter(notificationId => alive.has(notificationId));
    }

    LazyLoader {
        id: host
        active: Features.enabled.notifications

        NotificationServerHost {
            onReceived: (notification) => root.handleReceived(notification)
        }
    }
}
