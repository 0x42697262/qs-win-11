import QtQuick
import QtQuick.Effects
import Quickshell
import qs.src.config
import qs.src.services
import qs.src.ui.theme

Item {
    id: root

    property point windowOffset: Qt.point(0, 0)
    property point origin: Qt.point(0, 0)
    readonly property var backdrop: Settings.values.backdrop
    readonly property var shellScreen: (root.QsWindow.window as QsWindow)?.screen as ShellScreen

    function updateOrigin(): void {
        const mapped = root.mapToItem(null, 0, 0);
        origin = Qt.point(mapped.x + windowOffset.x, mapped.y + windowOffset.y);
    }

    clip: true
    onWidthChanged: updateOrigin()
    onHeightChanged: updateOrigin()
    onWindowOffsetChanged: updateOrigin()
    Component.onCompleted: {
        updateOrigin();
        settle.start();
    }

    Timer {
        id: settle
        interval: Theme.motion.slower
        onTriggered: root.updateOrigin()
    }

    Image {
        id: wallpaper
        x: -root.origin.x
        y: -root.origin.y
        width: root.shellScreen ? root.shellScreen.width : root.width
        height: root.shellScreen ? root.shellScreen.height : root.height
        source: Wallpaper.source
        fillMode: Wallpaper.fillMode
        asynchronous: true
        cache: true
        visible: false
    }

    MultiEffect {
        anchors.fill: wallpaper
        source: wallpaper
        blurEnabled: true
        blur: root.backdrop.micaBlur
        blurMax: root.backdrop.micaBlurRadius
        saturation: root.backdrop.micaSaturation
        brightness: root.backdrop.micaBrightness
        autoPaddingEnabled: false
    }
}
