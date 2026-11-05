pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/shell/surfaces.mjs" as Surfaces
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    id: root

    required property ShellScreen modelData
    readonly property string screenName: modelData.name
    readonly property var taskbarSettings: Settings.values.taskbar
    readonly property bool centered: taskbarSettings.alignment === Enums.TaskbarAlignment.Center
    readonly property bool surfaceOpenHere: ShellState.openScreenName === screenName && ShellState.openSurface !== Surfaces.Surface.None
    readonly property bool revealed: !taskbarSettings.autoHide || hover.hovered || surfaceOpenHere || hideDelay.running
    readonly property list<var> items: Apps.taskbarItems(Windows.windowsForMonitor(screenName, taskbarSettings.windowsOnAllMonitors))

    function surfaceButtonChecked(surface: string): bool {
        return ShellState.isOpen(surface, screenName);
    }

    function anchorXOf(item: Item): real {
        return item.mapToItem(null, item.width / 2, 0).x;
    }

    screen: modelData
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    implicitHeight: revealed ? Theme.size.taskbarHeight : Settings.values.tuning.autoHideRevealPixels
    exclusiveZone: taskbarSettings.autoHide ? 0 : Theme.size.taskbarHeight
    color: Theme.colors.transparent
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Taskbar

    onRevealedChanged: if (!revealed) hideDelay.stop()

    Timer {
        id: hideDelay
        interval: Settings.values.tuning.autoHideDelayMs
        running: root.taskbarSettings.autoHide && !hover.hovered
    }

    Item {
        anchors.fill: parent

        HoverHandler {
            id: hover
        }

        Rectangle {
            anchors.fill: parent
            color: Theme.taskbarFill

            Divider {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colors.surfaceStroke
            }
        }

        WidgetsButton {
            id: widgetsButton
            visible: root.centered && root.taskbarSettings.showWidgets && Features.enabled.widgets
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacing.small
            anchors.verticalCenter: parent.verticalCenter
            checked: root.surfaceButtonChecked(Surfaces.Surface.Widgets)
            onActivated: ShellState.toggle(Surfaces.Surface.Widgets, root.screenName)
        }

        RowLayout {
            id: centerRow
            anchors.verticalCenter: parent.verticalCenter
            x: root.centered ? (parent.width - width) / 2 : Theme.spacing.small
            spacing: Theme.spacing.xxSmall

            Behavior on x {
                NumberAnimation { duration: Theme.motion.normal; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.motion.decelerate }
            }

            TaskbarButton {
                icon: Icons.Icon.grid
                iconFilled: true
                iconColor: Theme.colors.accent
                toolTip: Settings.values.text.taskbar.start
                checked: root.surfaceButtonChecked(Surfaces.Surface.StartMenu)
                acceptRightClick: Features.enabled.quickLink
                onActivated: ShellState.toggle(Surfaces.Surface.StartMenu, root.screenName)
                onRightClicked: ShellState.toggleWith(Surfaces.Surface.QuickLink, root.screenName, { anchorX: root.anchorXOf(this) })
            }

            TaskbarButton {
                visible: root.taskbarSettings.showSearch && Features.enabled.search
                icon: Icons.Icon.search
                toolTip: Settings.values.text.taskbar.search
                checked: root.surfaceButtonChecked(Surfaces.Surface.Search)
                onActivated: ShellState.toggle(Surfaces.Surface.Search, root.screenName)
            }

            TaskbarButton {
                visible: root.taskbarSettings.showTaskView && Features.enabled.taskView
                icon: Icons.Icon.squareMultiple
                toolTip: Settings.values.text.taskbar.taskView
                checked: root.surfaceButtonChecked(Surfaces.Surface.TaskView)
                onActivated: ShellState.toggle(Surfaces.Surface.TaskView, root.screenName)
            }

            TaskbarButton {
                visible: !root.centered && root.taskbarSettings.showWidgets && Features.enabled.widgets
                icon: Icons.Icon.weatherPartlyCloudyDay
                toolTip: Settings.values.text.taskbar.widgets
                checked: root.surfaceButtonChecked(Surfaces.Surface.Widgets)
                onActivated: ShellState.toggle(Surfaces.Surface.Widgets, root.screenName)
            }

            Repeater {
                model: root.items

                AppButton {
                    screenName: root.screenName
                }
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacing.xxSmall

            TaskbarButton {
                id: trayButton
                visible: Features.enabled.systemTray
                implicitWidth: Theme.size.trayCell
                icon: Icons.Icon.chevronUp
                toolTip: Settings.values.text.taskbar.showHiddenIcons
                checked: root.surfaceButtonChecked(Surfaces.Surface.TrayOverflow)
                onActivated: ShellState.toggleWith(Surfaces.Surface.TrayOverflow, root.screenName, { anchorX: root.anchorXOf(trayButton) })
            }

            SystemClusterButton {
                visible: Features.enabled.quickSettings
                checked: root.surfaceButtonChecked(Surfaces.Surface.QuickSettings)
                onActivated: ShellState.toggle(Surfaces.Surface.QuickSettings, root.screenName)
            }

            ClockButton {
                checked: root.surfaceButtonChecked(Surfaces.Surface.NotificationCenter)
                onActivated: ShellState.toggle(Surfaces.Surface.NotificationCenter, root.screenName)
            }

            Interactive {
                id: showDesktop
                visible: WindowSwitcher.canShowDesktop
                implicitWidth: Theme.size.showDesktopWidth
                implicitHeight: Theme.size.taskbarHeight
                onActivated: WindowSwitcher.toggleDesktop()

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: Theme.size.stroke
                    height: parent.height / 2
                    color: showDesktop.hovered ? Theme.colors.divider : Theme.colors.transparent
                }
            }
        }
    }
}
