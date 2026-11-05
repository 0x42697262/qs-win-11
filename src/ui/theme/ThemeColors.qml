import QtQuick

QtObject {
    id: root

    required property var palette
    required property int duration

    property color micaBase: palette.micaBase
    Behavior on micaBase { ColorAnimation { duration: root.duration } }
    property color taskbarBackground: palette.taskbarBackground
    Behavior on taskbarBackground { ColorAnimation { duration: root.duration } }
    property color flyoutBackground: palette.flyoutBackground
    Behavior on flyoutBackground { ColorAnimation { duration: root.duration } }
    property color cardBackground: palette.cardBackground
    Behavior on cardBackground { ColorAnimation { duration: root.duration } }
    property color cardBackgroundSecondary: palette.cardBackgroundSecondary
    Behavior on cardBackgroundSecondary { ColorAnimation { duration: root.duration } }
    property color smokeOverlay: palette.smokeOverlay
    Behavior on smokeOverlay { ColorAnimation { duration: root.duration } }
    property color textPrimary: palette.textPrimary
    Behavior on textPrimary { ColorAnimation { duration: root.duration } }
    property color textSecondary: palette.textSecondary
    Behavior on textSecondary { ColorAnimation { duration: root.duration } }
    property color textTertiary: palette.textTertiary
    Behavior on textTertiary { ColorAnimation { duration: root.duration } }
    property color textDisabled: palette.textDisabled
    Behavior on textDisabled { ColorAnimation { duration: root.duration } }
    property color subtleFillHover: palette.subtleFillHover
    Behavior on subtleFillHover { ColorAnimation { duration: root.duration } }
    property color subtleFillPressed: palette.subtleFillPressed
    Behavior on subtleFillPressed { ColorAnimation { duration: root.duration } }
    property color controlFill: palette.controlFill
    Behavior on controlFill { ColorAnimation { duration: root.duration } }
    property color controlFillHover: palette.controlFillHover
    Behavior on controlFillHover { ColorAnimation { duration: root.duration } }
    property color controlFillPressed: palette.controlFillPressed
    Behavior on controlFillPressed { ColorAnimation { duration: root.duration } }
    property color controlFillDisabled: palette.controlFillDisabled
    Behavior on controlFillDisabled { ColorAnimation { duration: root.duration } }
    property color controlStrongFill: palette.controlStrongFill
    Behavior on controlStrongFill { ColorAnimation { duration: root.duration } }
    property color controlStroke: palette.controlStroke
    Behavior on controlStroke { ColorAnimation { duration: root.duration } }
    property color controlStrongStroke: palette.controlStrongStroke
    Behavior on controlStrongStroke { ColorAnimation { duration: root.duration } }
    property color cardStroke: palette.cardStroke
    Behavior on cardStroke { ColorAnimation { duration: root.duration } }
    property color surfaceStroke: palette.surfaceStroke
    Behavior on surfaceStroke { ColorAnimation { duration: root.duration } }
    property color divider: palette.divider
    Behavior on divider { ColorAnimation { duration: root.duration } }
    property color focusStroke: palette.focusStroke
    Behavior on focusStroke { ColorAnimation { duration: root.duration } }
    property color success: palette.success
    Behavior on success { ColorAnimation { duration: root.duration } }
    property color caution: palette.caution
    Behavior on caution { ColorAnimation { duration: root.duration } }
    property color critical: palette.critical
    Behavior on critical { ColorAnimation { duration: root.duration } }
    property color attention: palette.attention
    Behavior on attention { ColorAnimation { duration: root.duration } }
    property color edgeHighlight: palette.edgeHighlight
    Behavior on edgeHighlight { ColorAnimation { duration: root.duration } }
    property color shadow: palette.shadow
    Behavior on shadow { ColorAnimation { duration: root.duration } }
    property color contactShadow: palette.contactShadow
    Behavior on contactShadow { ColorAnimation { duration: root.duration } }
    property color terminalBlack: palette.terminalBlack
    Behavior on terminalBlack { ColorAnimation { duration: root.duration } }
    property color terminalRed: palette.terminalRed
    Behavior on terminalRed { ColorAnimation { duration: root.duration } }
    property color terminalGreen: palette.terminalGreen
    Behavior on terminalGreen { ColorAnimation { duration: root.duration } }
    property color terminalYellow: palette.terminalYellow
    Behavior on terminalYellow { ColorAnimation { duration: root.duration } }
    property color terminalBlue: palette.terminalBlue
    Behavior on terminalBlue { ColorAnimation { duration: root.duration } }
    property color terminalMagenta: palette.terminalMagenta
    Behavior on terminalMagenta { ColorAnimation { duration: root.duration } }
    property color terminalCyan: palette.terminalCyan
    Behavior on terminalCyan { ColorAnimation { duration: root.duration } }
    property color terminalWhite: palette.terminalWhite
    Behavior on terminalWhite { ColorAnimation { duration: root.duration } }
    property color terminalBrightBlack: palette.terminalBrightBlack
    Behavior on terminalBrightBlack { ColorAnimation { duration: root.duration } }
    property color terminalBrightRed: palette.terminalBrightRed
    Behavior on terminalBrightRed { ColorAnimation { duration: root.duration } }
    property color terminalBrightGreen: palette.terminalBrightGreen
    Behavior on terminalBrightGreen { ColorAnimation { duration: root.duration } }
    property color terminalBrightYellow: palette.terminalBrightYellow
    Behavior on terminalBrightYellow { ColorAnimation { duration: root.duration } }
    property color terminalBrightBlue: palette.terminalBrightBlue
    Behavior on terminalBrightBlue { ColorAnimation { duration: root.duration } }
    property color terminalBrightMagenta: palette.terminalBrightMagenta
    Behavior on terminalBrightMagenta { ColorAnimation { duration: root.duration } }
    property color terminalBrightCyan: palette.terminalBrightCyan
    Behavior on terminalBrightCyan { ColorAnimation { duration: root.duration } }
    property color terminalBrightWhite: palette.terminalBrightWhite
    Behavior on terminalBrightWhite { ColorAnimation { duration: root.duration } }
    property color accent: palette.accent
    Behavior on accent { ColorAnimation { duration: root.duration } }
    property color accentHover: palette.accentHover
    Behavior on accentHover { ColorAnimation { duration: root.duration } }
    property color accentPressed: palette.accentPressed
    Behavior on accentPressed { ColorAnimation { duration: root.duration } }
    property color accentDisabled: palette.accentDisabled
    Behavior on accentDisabled { ColorAnimation { duration: root.duration } }
    property color accentText: palette.accentText
    Behavior on accentText { ColorAnimation { duration: root.duration } }
    property color textOnAccent: palette.textOnAccent
    Behavior on textOnAccent { ColorAnimation { duration: root.duration } }
    property color taskbarBackgroundOpaque: palette.taskbarBackgroundOpaque
    Behavior on taskbarBackgroundOpaque { ColorAnimation { duration: root.duration } }
    property color flyoutBackgroundOpaque: palette.flyoutBackgroundOpaque
    Behavior on flyoutBackgroundOpaque { ColorAnimation { duration: root.duration } }
    readonly property color transparent: "transparent"
}
