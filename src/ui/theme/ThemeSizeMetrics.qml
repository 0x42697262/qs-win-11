import QtQuick

QtObject {
    required property real scale
    required property var values

    readonly property real taskbarHeight: values.taskbarHeight * scale
    readonly property real taskbarButton: values.taskbarButton * scale
    readonly property real taskbarIcon: values.taskbarIcon * scale
    readonly property real activeIndicatorWidth: values.activeIndicatorWidth * scale
    readonly property real openIndicatorWidth: values.openIndicatorWidth * scale
    readonly property real indicatorHeight: values.indicatorHeight * scale
    readonly property real buttonHeight: values.buttonHeight * scale
    readonly property real toggleWidth: values.toggleWidth * scale
    readonly property real toggleHeight: values.toggleHeight * scale
    readonly property real toggleKnob: values.toggleKnob * scale
    readonly property real toggleKnobPressed: values.toggleKnobPressed * scale
    readonly property real sliderTrack: values.sliderTrack * scale
    readonly property real sliderThumb: values.sliderThumb * scale
    readonly property real sliderThumbInner: values.sliderThumbInner * scale
    readonly property real sliderThumbInnerPressed: values.sliderThumbInnerPressed * scale
    readonly property real sliderThumbInnerHover: values.sliderThumbInnerHover * scale
    readonly property real quickTileWidth: values.quickTileWidth * scale
    readonly property real quickTileHeight: values.quickTileHeight * scale
    readonly property real focusStroke: values.focusStroke * scale
    readonly property real stroke: values.stroke * scale
    readonly property real flyoutWidth: values.flyoutWidth * scale
    readonly property real startMenuWidth: values.startMenuWidth * scale
    readonly property real startMenuHeight: values.startMenuHeight * scale
    readonly property real calendarCell: values.calendarCell * scale
    readonly property real toastWidth: values.toastWidth * scale
    readonly property real osdWidth: values.osdWidth * scale
    readonly property real osdHeight: values.osdHeight * scale
    readonly property real widgetsWidth: values.widgetsWidth * scale
    readonly property real sessionButton: values.sessionButton * scale
    readonly property real taskViewCard: values.taskViewCard * scale
    readonly property real contextMenuWidth: values.contextMenuWidth * scale
    readonly property real avatar: values.avatar * scale
    readonly property real avatarLarge: values.avatarLarge * scale
    readonly property real startTileWidth: values.startTileWidth * scale
    readonly property real startTileHeight: values.startTileHeight * scale
    readonly property real startFooterHeight: values.startFooterHeight * scale
    readonly property real searchResultsWidth: values.searchResultsWidth * scale
    readonly property real mediaArt: values.mediaArt * scale
    readonly property real clusterIconSpacing: values.clusterIconSpacing * scale
    readonly property real listMaxHeight: values.listMaxHeight * scale
    readonly property real notificationListHeight: values.notificationListHeight * scale
    readonly property real notificationImage: values.notificationImage * scale
    readonly property real toastStackSpacing: values.toastStackSpacing * scale
    readonly property real lockFieldWidth: values.lockFieldWidth * scale
    readonly property real taskViewCardHeight: values.taskViewCardHeight * scale
    readonly property real workspaceCard: values.workspaceCard * scale
    readonly property real altTabCard: values.altTabCard * scale
    readonly property real widgetCard: values.widgetCard * scale
    readonly property real forecastDay: values.forecastDay * scale
    readonly property real settingsWindowWidth: values.settingsWindowWidth * scale
    readonly property real settingsWindowHeight: values.settingsWindowHeight * scale
    readonly property real settingsSidebar: values.settingsSidebar * scale
    readonly property real settingsControl: values.settingsControl * scale
    readonly property real settingsTextField: values.settingsTextField * scale
    readonly property real swatch: values.swatch * scale
    readonly property real snapPreviewWidth: values.snapPreviewWidth * scale
    readonly property real snapPreviewHeight: values.snapPreviewHeight * scale
    readonly property real thumbnailWidth: values.thumbnailWidth * scale
    readonly property real thumbnailHeight: values.thumbnailHeight * scale
    readonly property real showDesktopWidth: values.showDesktopWidth * scale
    readonly property real clockWidth: values.clockWidth * scale
    readonly property real trayIcon: values.trayIcon * scale
    readonly property real trayCell: values.trayCell * scale
}
