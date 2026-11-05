import QtQuick
import qs.src.ui.theme
import "../../domain/catalog/uiEnums.mjs" as UiEnums

Text {
    id: root

    property string variant: UiEnums.TextVariant.Body
    property string tone: UiEnums.TextTone.Primary

    readonly property var sizeByVariant: ({
        caption: Theme.fontSize.caption,
        body: Theme.fontSize.body,
        bodyStrong: Theme.fontSize.body,
        bodyLarge: Theme.fontSize.bodyLarge,
        subtitle: Theme.fontSize.subtitle,
        title: Theme.fontSize.title,
        titleLarge: Theme.fontSize.titleLarge,
        display: Theme.fontSize.display,
    })
    readonly property var colorByTone: ({
        primary: Theme.colors.textPrimary,
        secondary: Theme.colors.textSecondary,
        tertiary: Theme.colors.textTertiary,
        disabled: Theme.colors.textDisabled,
        onAccent: Theme.colors.textOnAccent,
        accent: Theme.colors.accentText,
        critical: Theme.colors.critical,
    })
    readonly property bool strong: variant !== UiEnums.TextVariant.Body && variant !== UiEnums.TextVariant.Caption && variant !== UiEnums.TextVariant.BodyLarge

    font.family: Theme.fontFamily
    font.pixelSize: sizeByVariant[variant]
    font.weight: strong ? Theme.weightSemibold : Theme.weightRegular
    color: colorByTone[tone]
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
    textFormat: Text.PlainText
}
