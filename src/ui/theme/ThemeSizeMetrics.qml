import QtQuick
import "../../domain/catalog/tokens.mjs" as Tokens

QtObject {
    required property real scale

    readonly property real taskbarHeight: Tokens.CONTROL_SIZE.taskbarHeight * scale
    readonly property real taskbarButton: Tokens.CONTROL_SIZE.taskbarButton * scale
    readonly property real taskbarIcon: Tokens.CONTROL_SIZE.taskbarIcon * scale
    readonly property real activeIndicatorWidth: Tokens.CONTROL_SIZE.activeIndicatorWidth * scale
    readonly property real openIndicatorWidth: Tokens.CONTROL_SIZE.openIndicatorWidth * scale
    readonly property real indicatorHeight: Tokens.CONTROL_SIZE.indicatorHeight * scale
    readonly property real buttonHeight: Tokens.CONTROL_SIZE.buttonHeight * scale
    readonly property real toggleWidth: Tokens.CONTROL_SIZE.toggleWidth * scale
    readonly property real toggleHeight: Tokens.CONTROL_SIZE.toggleHeight * scale
    readonly property real toggleKnob: Tokens.CONTROL_SIZE.toggleKnob * scale
    readonly property real toggleKnobPressed: Tokens.CONTROL_SIZE.toggleKnobPressed * scale
    readonly property real sliderTrack: Tokens.CONTROL_SIZE.sliderTrack * scale
    readonly property real sliderThumb: Tokens.CONTROL_SIZE.sliderThumb * scale
    readonly property real sliderThumbInner: Tokens.CONTROL_SIZE.sliderThumbInner * scale
    readonly property real sliderThumbInnerPressed: Tokens.CONTROL_SIZE.sliderThumbInnerPressed * scale
    readonly property real sliderThumbInnerHover: Tokens.CONTROL_SIZE.sliderThumbInnerHover * scale
    readonly property real quickTileWidth: Tokens.CONTROL_SIZE.quickTileWidth * scale
    readonly property real quickTileHeight: Tokens.CONTROL_SIZE.quickTileHeight * scale
    readonly property real focusStroke: Tokens.CONTROL_SIZE.focusStroke * scale
    readonly property real stroke: Tokens.CONTROL_SIZE.stroke * scale
    readonly property real flyoutWidth: Tokens.CONTROL_SIZE.flyoutWidth * scale
    readonly property real startMenuWidth: Tokens.CONTROL_SIZE.startMenuWidth * scale
    readonly property real startMenuHeight: Tokens.CONTROL_SIZE.startMenuHeight * scale
    readonly property real calendarCell: Tokens.CONTROL_SIZE.calendarCell * scale
    readonly property real toastWidth: Tokens.CONTROL_SIZE.toastWidth * scale
    readonly property real osdWidth: Tokens.CONTROL_SIZE.osdWidth * scale
    readonly property real osdHeight: Tokens.CONTROL_SIZE.osdHeight * scale
    readonly property real widgetsWidth: Tokens.CONTROL_SIZE.widgetsWidth * scale
    readonly property real sessionButton: Tokens.CONTROL_SIZE.sessionButton * scale
    readonly property real taskViewCard: Tokens.CONTROL_SIZE.taskViewCard * scale
    readonly property real contextMenuWidth: Tokens.CONTROL_SIZE.contextMenuWidth * scale
    readonly property real avatar: Tokens.CONTROL_SIZE.avatar * scale
    readonly property real avatarLarge: Tokens.CONTROL_SIZE.avatarLarge * scale
    readonly property real startTileWidth: Tokens.CONTROL_SIZE.startTileWidth * scale
    readonly property real startTileHeight: Tokens.CONTROL_SIZE.startTileHeight * scale
    readonly property real startFooterHeight: Tokens.CONTROL_SIZE.startFooterHeight * scale
    readonly property real searchResultsWidth: Tokens.CONTROL_SIZE.searchResultsWidth * scale
    readonly property real mediaArt: Tokens.CONTROL_SIZE.mediaArt * scale
    readonly property real clusterIconSpacing: Tokens.CONTROL_SIZE.clusterIconSpacing * scale
    readonly property real listMaxHeight: Tokens.CONTROL_SIZE.listMaxHeight * scale
    readonly property real notificationListHeight: Tokens.CONTROL_SIZE.notificationListHeight * scale
    readonly property real notificationImage: Tokens.CONTROL_SIZE.notificationImage * scale
    readonly property real toastStackSpacing: Tokens.CONTROL_SIZE.toastStackSpacing * scale
    readonly property real lockFieldWidth: Tokens.CONTROL_SIZE.lockFieldWidth * scale
    readonly property real taskViewCardHeight: Tokens.CONTROL_SIZE.taskViewCardHeight * scale
    readonly property real workspaceCard: Tokens.CONTROL_SIZE.workspaceCard * scale
    readonly property real altTabCard: Tokens.CONTROL_SIZE.altTabCard * scale
    readonly property real widgetCard: Tokens.CONTROL_SIZE.widgetCard * scale
    readonly property real forecastDay: Tokens.CONTROL_SIZE.forecastDay * scale
    readonly property real settingsWindowWidth: Tokens.CONTROL_SIZE.settingsWindowWidth * scale
    readonly property real settingsWindowHeight: Tokens.CONTROL_SIZE.settingsWindowHeight * scale
    readonly property real settingsSidebar: Tokens.CONTROL_SIZE.settingsSidebar * scale
    readonly property real settingsControl: Tokens.CONTROL_SIZE.settingsControl * scale
    readonly property real settingsTextField: Tokens.CONTROL_SIZE.settingsTextField * scale
    readonly property real swatch: Tokens.CONTROL_SIZE.swatch * scale
    readonly property real showDesktopWidth: Tokens.CONTROL_SIZE.showDesktopWidth * scale
    readonly property real clockWidth: Tokens.CONTROL_SIZE.clockWidth * scale
    readonly property real trayIcon: Tokens.CONTROL_SIZE.trayIcon * scale
    readonly property real trayCell: Tokens.CONTROL_SIZE.trayCell * scale
}
