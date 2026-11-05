pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import qs.src.services
import "../../domain/catalog/icons.mjs" as Icons

Singleton {
    id: root

    readonly property var themeSettings: Settings.values.theme
    readonly property string resolvedMode: ColorScheme.resolvedMode
    readonly property bool dark: ColorScheme.dark
    readonly property real scale: themeSettings.scale
    readonly property string fontFamily: themeSettings.fontFamily
    readonly property string iconFontRegular: regularIcons.name
    readonly property string iconFontFilled: filledIcons.name
    readonly property var sizes: Settings.values.sizes
    readonly property var effects: Settings.values.effects
    readonly property int weightRegular: sizes.fontWeight.regular
    readonly property int weightSemibold: sizes.fontWeight.semibold
    readonly property int weightBold: sizes.fontWeight.bold
    readonly property real pressScale: effects.pressScale
    readonly property var tracking: sizes.tracking
    readonly property real slideDistance: Appearance.slides ? Settings.values.motion.slideDistance.flyout * scale : 0
    readonly property var elevation: effects.elevation
    readonly property real overlaySmoothing: Settings.values.corners.overlaySmoothing
    readonly property real controlSmoothing: Settings.values.corners.controlSmoothing
    readonly property var backdropSettings: Settings.values.backdrop
    readonly property color surfaceFill: backdropFill(colors.flyoutBackground, colors.flyoutBackgroundOpaque)
    readonly property color overlayFill: Appearance.translucentOverlays && !Appearance.solid ? backdropFill(colors.flyoutBackground, colors.flyoutBackgroundOpaque) : colors.flyoutBackgroundOpaque
    readonly property color taskbarFill: backdropFill(colors.taskbarBackground, colors.taskbarBackgroundOpaque)

    function backdropFill(translucent: color, opaque: color): color {
        if (Appearance.solid) {
            return opaque;
        }
        if (Appearance.mica) {
            return Qt.alpha(opaque, backdropSettings.micaTintOpacity);
        }
        if (Appearance.acrylic) {
            return Qt.alpha(opaque, backdropSettings.acrylicTintOpacity);
        }
        return backdropSettings.tintOpacity >= 0 ? Qt.alpha(opaque, backdropSettings.tintOpacity) : translucent;
    }

    readonly property ThemeColors colors: ThemeColors {
        duration: root.motion.theme
        palette: ColorScheme.palette
    }
    readonly property ThemeSpacingMetrics spacing: ThemeSpacingMetrics { scale: root.scale; values: root.sizes.spacing }
    readonly property ThemeRadiusMetrics radius: ThemeRadiusMetrics { scale: root.scale; values: root.sizes.radius }
    readonly property ThemeFontSizeMetrics fontSize: ThemeFontSizeMetrics { scale: root.scale * root.themeSettings.fontScale; values: root.sizes.font }
    readonly property ThemeIconSizeMetrics iconSize: ThemeIconSizeMetrics { scale: root.scale; values: root.sizes.icon }
    readonly property ThemeSizeMetrics size: ThemeSizeMetrics { scale: root.scale; values: root.sizes.control }
    readonly property ThemeMotion motion: ThemeMotion { reduced: root.themeSettings.reduceMotion || !Appearance.animated; values: Settings.values.motion }

    FontLoader {
        id: regularIcons
        source: Paths.shellAsset(Icons.IconFontFile.Regular)
    }

    FontLoader {
        id: filledIcons
        source: Paths.shellAsset(Icons.IconFontFile.Filled)
    }
}
