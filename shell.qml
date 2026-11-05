//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.src.config
import qs.src.services
import qs.src.ipc
import qs.src.ui.features.gallery
import qs.src.ui.features.shell
import qs.src.ui.features.taskbar
import qs.src.ui.features.start
import qs.src.ui.features.quickSettings
import qs.src.ui.features.notifications
import qs.src.ui.features.osd
import qs.src.ui.features.power
import qs.src.ui.features.taskView
import "src/domain/catalog/logEvents.mjs" as LogEvents
import "src/domain/shell/surfaces.mjs" as Surfaces

ShellRoot {
    id: root

    readonly property var surfaceComponents: {
        const components = {};
        components[Surfaces.Surface.ContextMenu] = contextMenuSurface;
        if (Features.enabled.startMenu) {
            components[Surfaces.Surface.StartMenu] = startMenuSurface;
        }
        if (Features.enabled.search) {
            components[Surfaces.Surface.Search] = searchSurface;
        }
        if (Features.enabled.quickLink) {
            components[Surfaces.Surface.QuickLink] = quickLinkSurface;
        }
        if (Features.enabled.quickSettings) {
            components[Surfaces.Surface.QuickSettings] = quickSettingsSurface;
        }
        components[Surfaces.Surface.NotificationCenter] = notificationCenterSurface;
        if (Features.enabled.taskView) {
            components[Surfaces.Surface.TaskView] = taskViewSurface;
        }
        if (Features.enabled.altTab) {
            components[Surfaces.Surface.AltTab] = altTabSurface;
        }
        if (Features.enabled.sessionMenu) {
            components[Surfaces.Surface.SessionMenu] = sessionMenuSurface;
        }
        if (Features.enabled.systemTray) {
            components[Surfaces.Surface.TrayOverflow] = trayOverflowSurface;
        }
        return components;
    }

    Component.onCompleted: Log.info(LogEvents.LogEvent.ShellStarted, { settingsFile: Paths.settingsFile })

    ShellIpc {}
    SettingsIpc {}
    StartIpc {}
    SearchIpc {}
    QuickLinkIpc {}
    SessionIpc {}
    QuickSettingsIpc {}
    NotificationsIpc {}
    AudioIpc {}
    TaskViewIpc {}
    AltTabIpc {}
    DesktopIpc {}
    BrightnessIpc {}

    LazyLoader {
        active: Features.enabled.batteryAlerts
        BatteryAlerts {}
    }

    LazyLoader {
        active: Features.enabled.idle
        IdleHandler {}
    }

    LazyLoader {
        active: Features.enabled.lockScreen
        LockScreen {}
    }

    LazyLoader {
        active: Features.enabled.osd
        OsdLayer {}
    }

    LazyLoader {
        active: Notifications.active
        ToastLayer {}
    }

    LazyLoader {
        active: Features.enabled.appThemeSync
        AppThemeSync {}
    }

    LazyLoader {
        active: Environment.galleryRequested
        ComponentGallery {}
    }

    Variants {
        model: Features.enabled.taskbar ? Quickshell.screens : []
        Taskbar {}
    }

    Variants {
        model: Quickshell.screens
        FlyoutHost {
            surfaceComponents: root.surfaceComponents
        }
    }

    Variants {
        model: Quickshell.screens
        ToolTipLayer {}
    }

    Component {
        id: contextMenuSurface
        ContextMenuSurface {
            payload: ShellState.payload
        }
    }

    Component {
        id: startMenuSurface
        StartMenuSurface {
            payload: ShellState.payload
        }
    }

    Component {
        id: searchSurface
        SearchSurface {}
    }

    Component {
        id: quickLinkSurface
        ContextMenuSurface {
            payload: ({ anchorX: ShellState.payload ? ShellState.payload.anchorX : -1, title: "", items: QuickLinks.items() })
        }
    }

    Component {
        id: quickSettingsSurface
        QuickSettingsSurface {}
    }

    Component {
        id: notificationCenterSurface
        NotificationCenterSurface {}
    }

    Component {
        id: sessionMenuSurface
        SessionMenuSurface {}
    }

    Component {
        id: taskViewSurface
        TaskViewSurface {}
    }

    Component {
        id: altTabSurface
        AltTabSurface {}
    }

    Component {
        id: trayOverflowSurface
        TrayOverflowSurface {
            anchorX: ShellState.payload ? ShellState.payload.anchorX : 0
        }
    }
}
