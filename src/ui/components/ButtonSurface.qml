import QtQuick
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

SmoothRectangle {
    required property string variant
    required property bool hovered
    required property bool pressed
    required property bool enabledState
    property bool checked: false

    readonly property bool accentLook: variant === UiEnums.ButtonVariant.Accent || checked

    radius: Theme.radius.control
    smoothingOverride: Theme.controlSmoothing
    borderWidth: variant === UiEnums.ButtonVariant.Subtle && !checked ? 0 : Theme.size.stroke
    borderColor: accentLook ? Theme.colors.transparent : Theme.colors.controlStroke
    color: {
        if (accentLook) {
            if (!enabledState) {
                return Theme.colors.accentDisabled;
            }
            return pressed ? Theme.colors.accentPressed : hovered ? Theme.colors.accentHover : Theme.colors.accent;
        }
        if (variant === UiEnums.ButtonVariant.Subtle) {
            return pressed ? Theme.colors.subtleFillPressed : hovered ? Theme.colors.subtleFillHover : Theme.colors.transparent;
        }
        if (!enabledState) {
            return Theme.colors.controlFillDisabled;
        }
        return pressed ? Theme.colors.controlFillPressed : hovered ? Theme.colors.controlFillHover : Theme.colors.controlFill;
    }

}
