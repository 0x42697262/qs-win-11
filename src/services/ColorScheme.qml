pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/units.mjs" as Units
import "../domain/catalog/enums.mjs" as Enums
import "../domain/theme/palette.mjs" as PaletteRules
import "../domain/theme/themeMode.mjs" as ThemeModeRules

Singleton {
    id: root

    readonly property var themeSettings: Settings.values.theme
    readonly property int minutesNow: clock.hours * Units.MINUTES_PER_HOUR + clock.minutes
    readonly property string resolvedMode: ThemeModeRules.resolveThemeMode(themeSettings.mode, minutesNow, themeSettings.lightStartsAt, themeSettings.darkStartsAt)
    readonly property bool dark: resolvedMode === Enums.ResolvedThemeMode.Dark
    readonly property string accent: WallpaperAccent.active ? WallpaperAccent.accent : themeSettings.accentColor
    readonly property var palette: PaletteRules.buildPalette(resolvedMode, accent, themeSettings.transparency, Settings.values.colors, Settings.values.effects.accentShades, themeSettings.textContrast)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
