pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/capture/snip.mjs" as SnipRules
import "../../../domain/catalog/enums.mjs" as Enums
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums
import "../../../domain/catalog/features.mjs" as FeatureCatalog
import "../../../domain/catalog/compositor.mjs" as CompositorCatalog

PanelWindow {
    id: root

    required property ShellScreen modelData
    readonly property var text: Settings.values.text.capture
    readonly property bool picking: Capture.kind === Enums.SnipKind.Color
    readonly property bool frozen: Settings.values.capture.freeze && Windows.capabilities.includes(FeatureCatalog.Capability.Screencopy)
    readonly property list<var> windowRects: Capture.mode === Enums.SnipMode.Window ? Capture.windowGeometries().map(rect => ({ id: rect.id, x: rect.x - modelData.x, y: rect.y - modelData.y, width: rect.width, height: rect.height })) : []
    property real startX: 0
    property real startY: 0
    property real pointerX: -1
    property real pointerY: -1
    property bool dragging: false
    readonly property var selection: dragging ? SnipRules.normalizeRect(startX, startY, pointerX, pointerY) : hoveredWindow
    readonly property var hoveredWindow: windowRects.length > 0 ? SnipRules.windowAt(windowRects, pointerX, pointerY) : null

    function screenInfo(): var {
        return { x: modelData.x, y: modelData.y, name: modelData.name };
    }

    function release(): void {
        if (picking) {
            Capture.finish({ x: pointerX, y: pointerY, width: 1, height: 1 }, screenInfo());
            return;
        }
        if (Capture.mode === Enums.SnipMode.Screen) {
            Capture.finish(null, screenInfo());
            return;
        }
        const rect = selection;
        if (rect && rect.width >= Settings.values.tuning.snipMinimumSize && rect.height >= Settings.values.tuning.snipMinimumSize) {
            Capture.finish(rect, screenInfo());
        }
    }

    screen: modelData
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    color: Theme.colors.transparent
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: CompositorCatalog.LayerNamespace.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    ScreencopyView {
        id: still
        visible: root.frozen
        anchors.fill: parent
        captureSource: root.frozen ? root.modelData : null
        live: false
    }

    Item {
        id: shade
        anchors.fill: parent

        readonly property var hole: root.selection

        Rectangle {
            visible: shade.hole === null
            anchors.fill: parent
            color: Settings.values.colors.dim
            opacity: Settings.values.effects.dimOpacity
        }

        Repeater {
            model: shade.hole ? [
                { x: 0, y: 0, width: shade.width, height: shade.hole.y },
                { x: 0, y: shade.hole.y + shade.hole.height, width: shade.width, height: shade.height - shade.hole.y - shade.hole.height },
                { x: 0, y: shade.hole.y, width: shade.hole.x, height: shade.hole.height },
                { x: shade.hole.x + shade.hole.width, y: shade.hole.y, width: shade.width - shade.hole.x - shade.hole.width, height: shade.hole.height },
            ] : []

            Rectangle {
                required property var modelData
                x: modelData.x
                y: modelData.y
                width: Math.max(0, modelData.width)
                height: Math.max(0, modelData.height)
                color: Settings.values.colors.dim
                opacity: Settings.values.effects.dimOpacity
            }
        }

        Rectangle {
            visible: shade.hole !== null
            x: shade.hole ? shade.hole.x : 0
            y: shade.hole ? shade.hole.y : 0
            width: shade.hole ? shade.hole.width : 0
            height: shade.hole ? shade.hole.height : 0
            color: Theme.colors.transparent
            border.width: Theme.size.stroke * 2
            border.color: Theme.colors.accent
            radius: Theme.size.stroke

            Label {
                visible: root.dragging
                anchors.top: parent.bottom
                anchors.topMargin: Theme.spacing.xSmall
                anchors.right: parent.right
                text: `${parent.width} × ${parent.height}`
                variant: UiEnums.TextVariant.Caption
            }
        }
    }

    Item {
        id: loupe
        visible: root.picking && root.pointerX >= 0 && root.frozen
        width: Theme.size.loupeSize
        height: Theme.size.loupeSize
        x: Math.min(root.width - width, root.pointerX + Theme.spacing.large)
        y: Math.min(root.height - height, root.pointerY + Theme.spacing.large)

        ShaderEffectSource {
            id: zoomed
            anchors.fill: parent
            sourceItem: still
            readonly property real span: Theme.size.loupeSize / Settings.values.tuning.pickerZoom
            sourceRect: Qt.rect(root.pointerX - span / 2, root.pointerY - span / 2, span, span)
            smooth: false
            visible: false
        }

        SmoothRectangle {
            id: loupeMask
            anchors.fill: parent
            radius: width / 2
            color: Theme.colors.accent
            visible: false
            layer.enabled: true
        }

        MultiEffect {
            anchors.fill: parent
            source: zoomed
            maskEnabled: true
            maskSource: loupeMask
        }

        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Theme.colors.transparent
            border.width: Theme.size.stroke * 2
            border.color: Theme.colors.accent
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        onPositionChanged: (mouse) => {
            root.pointerX = mouse.x;
            root.pointerY = mouse.y;
        }
        onPressed: (mouse) => {
            root.startX = mouse.x;
            root.startY = mouse.y;
            root.pointerX = mouse.x;
            root.pointerY = mouse.y;
            root.dragging = Capture.mode === Enums.SnipMode.Region && !root.picking;
        }
        onReleased: {
            root.release();
            root.dragging = false;
        }
    }

    AcrylicSurface {
        id: toolbar
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.spacing.xLarge
        width: tools.implicitWidth + Theme.spacing.small * 2
        height: Theme.size.snipToolbarHeight
        cornerRadius: Theme.radius.overlay
        fill: Theme.overlayFill

        RowLayout {
            id: tools
            anchors.centerIn: parent
            spacing: Theme.spacing.xSmall

            Repeater {
                model: root.picking ? [] : [
                    { mode: Enums.SnipMode.Region, icon: Icons.Icon.crop, label: root.text.region, shown: true },
                    { mode: Enums.SnipMode.Window, icon: Icons.Icon.window, label: root.text.window, shown: Capture.kind !== Enums.SnipKind.Recording && Windows.capabilities.includes(FeatureCatalog.Capability.WindowPlacement) },
                    { mode: Enums.SnipMode.Screen, icon: Icons.Icon.desktop, label: root.text.screen, shown: true },
                ]

                IconButton {
                    id: modeButton
                    required property var modelData
                    visible: modelData.shown
                    icon: modelData.icon
                    variant: Capture.mode === modelData.mode ? UiEnums.ButtonVariant.Accent : UiEnums.ButtonVariant.Subtle
                    onActivated: Capture.mode = modelData.mode

                    ToolTip {
                        target: modeButton
                        hovered: modeButton.hovered
                        text: modeButton.modelData.label
                    }
                }
            }

            Rectangle {
                visible: !root.picking && Features.enabled.screenRecording
                Layout.preferredWidth: Theme.size.stroke
                Layout.preferredHeight: Theme.size.taskbarIcon
                color: Theme.colors.divider
            }

            IconButton {
                id: shotButton
                visible: !root.picking && Features.enabled.screenRecording
                icon: Icons.Icon.screenshot
                variant: Capture.kind === Enums.SnipKind.Screenshot ? UiEnums.ButtonVariant.Accent : UiEnums.ButtonVariant.Subtle
                onActivated: Capture.kind = Enums.SnipKind.Screenshot

                ToolTip { target: shotButton; hovered: shotButton.hovered; text: root.text.screenshot }
            }

            IconButton {
                id: recordButton
                visible: !root.picking && Features.enabled.screenRecording
                icon: Icons.Icon.video
                variant: Capture.kind === Enums.SnipKind.Recording ? UiEnums.ButtonVariant.Accent : UiEnums.ButtonVariant.Subtle
                onActivated: {
                    Capture.kind = Enums.SnipKind.Recording;
                    if (Capture.mode === Enums.SnipMode.Window) {
                        Capture.mode = Enums.SnipMode.Region;
                    }
                }

                ToolTip { target: recordButton; hovered: recordButton.hovered; text: root.text.record }
            }

            Label {
                Layout.leftMargin: Theme.spacing.small
                Layout.rightMargin: Theme.spacing.small
                text: root.picking ? root.text.pickHint : root.text.hint
                tone: UiEnums.TextTone.Secondary
            }

            IconButton {
                id: closeButton
                icon: Icons.Icon.dismiss
                onActivated: Capture.close()

                ToolTip { target: closeButton; hovered: closeButton.hovered; text: root.text.close }
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Capture.close()
    }
}
