pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../../domain/catalog/tokens.mjs" as Tokens
import "../../domain/catalog/icons.mjs" as Icons
import "../../domain/catalog/tuning.mjs" as Tuning
import "../../domain/catalog/enums.mjs" as Enums
import "../../domain/theme/palette.mjs" as PaletteRules
import "../../domain/theme/themeMode.mjs" as ThemeModeRules

Singleton {
    id: root

    readonly property var themeSettings: Settings.values.theme
    readonly property int minutesNow: clock.hours * Tuning.MINUTES_PER_HOUR + clock.minutes
    readonly property string resolvedMode: ThemeModeRules.resolveThemeMode(themeSettings.mode, minutesNow, themeSettings.lightStartsAt, themeSettings.darkStartsAt)
    readonly property bool dark: resolvedMode === Enums.ResolvedThemeMode.Dark
    readonly property real scale: themeSettings.scale
    readonly property string fontFamily: themeSettings.fontFamily
    readonly property string iconFontRegular: regularIcons.name
    readonly property string iconFontFilled: filledIcons.name
    readonly property int weightRegular: Tokens.FONT_WEIGHT.regular
    readonly property int weightSemibold: Tokens.FONT_WEIGHT.semibold
    readonly property int weightBold: Tokens.FONT_WEIGHT.bold

    readonly property ThemeColors colors: ThemeColors {
        palette: PaletteRules.buildPalette(root.resolvedMode, root.themeSettings.accentColor, root.themeSettings.transparency)
    }
    readonly property ThemeSpacingMetrics spacing: ThemeSpacingMetrics { scale: root.scale }
    readonly property ThemeRadiusMetrics radius: ThemeRadiusMetrics { scale: root.scale }
    readonly property ThemeFontSizeMetrics fontSize: ThemeFontSizeMetrics { scale: root.scale }
    readonly property ThemeIconSizeMetrics iconSize: ThemeIconSizeMetrics { scale: root.scale }
    readonly property ThemeSizeMetrics size: ThemeSizeMetrics { scale: root.scale }
    readonly property ThemeMotion motion: ThemeMotion { reduced: root.themeSettings.reduceMotion }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    FontLoader {
        id: regularIcons
        source: Paths.shellAsset(Icons.IconFontFile.Regular)
    }

    FontLoader {
        id: filledIcons
        source: Paths.shellAsset(Icons.IconFontFile.Filled)
    }
}
