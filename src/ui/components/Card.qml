import QtQuick
import qs.src.ui.theme

SmoothRectangle {
    radius: Theme.radius.overlay
    smoothingOverride: Theme.overlaySmoothing
    color: Theme.colors.cardBackground
    borderWidth: Theme.size.stroke
    borderColor: Theme.colors.cardStroke
}
