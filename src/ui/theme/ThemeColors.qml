import QtQuick

QtObject {
    required property var palette

    readonly property color micaBase: palette.micaBase
    readonly property color taskbarBackground: palette.taskbarBackground
    readonly property color flyoutBackground: palette.flyoutBackground
    readonly property color cardBackground: palette.cardBackground
    readonly property color cardBackgroundSecondary: palette.cardBackgroundSecondary
    readonly property color smokeOverlay: palette.smokeOverlay
    readonly property color textPrimary: palette.textPrimary
    readonly property color textSecondary: palette.textSecondary
    readonly property color textTertiary: palette.textTertiary
    readonly property color textDisabled: palette.textDisabled
    readonly property color subtleFillHover: palette.subtleFillHover
    readonly property color subtleFillPressed: palette.subtleFillPressed
    readonly property color controlFill: palette.controlFill
    readonly property color controlFillHover: palette.controlFillHover
    readonly property color controlFillPressed: palette.controlFillPressed
    readonly property color controlFillDisabled: palette.controlFillDisabled
    readonly property color controlStrongFill: palette.controlStrongFill
    readonly property color controlStroke: palette.controlStroke
    readonly property color controlStrongStroke: palette.controlStrongStroke
    readonly property color cardStroke: palette.cardStroke
    readonly property color surfaceStroke: palette.surfaceStroke
    readonly property color divider: palette.divider
    readonly property color focusStroke: palette.focusStroke
    readonly property color success: palette.success
    readonly property color caution: palette.caution
    readonly property color critical: palette.critical
    readonly property color attention: palette.attention
    readonly property color edgeHighlight: palette.edgeHighlight
    readonly property color shadow: palette.shadow
    readonly property color contactShadow: palette.contactShadow
    readonly property color accent: palette.accent
    readonly property color accentHover: palette.accentHover
    readonly property color accentPressed: palette.accentPressed
    readonly property color accentDisabled: palette.accentDisabled
    readonly property color accentText: palette.accentText
    readonly property color textOnAccent: palette.textOnAccent
    readonly property color taskbarBackgroundOpaque: palette.taskbarBackgroundOpaque
    readonly property color flyoutBackgroundOpaque: palette.flyoutBackgroundOpaque
    readonly property color transparent: "transparent"
}
