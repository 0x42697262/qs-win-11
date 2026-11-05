import QtQuick
import qs.src.ui.theme

Canvas {
    id: root

    property list<real> values: []
    property real maximum: 1
    property color lineColor: Theme.colors.accent
    property real fillOpacity: Theme.elevation.sparklineFillOpacity

    implicitWidth: Theme.size.sparklineWidth
    implicitHeight: Theme.size.sparklineHeight
    onValuesChanged: requestPaint()
    onLineColorChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const context = getContext("2d");
        context.reset();
        if (values.length < 2) {
            return;
        }
        const peak = Math.max(maximum, Math.max.apply(null, values));
        const step = width / (values.length - 1);
        const yOf = value => height - (peak > 0 ? value / peak : 0) * (height - Theme.size.stroke * 2) - Theme.size.stroke;
        context.beginPath();
        context.moveTo(0, yOf(values[0]));
        values.forEach((value, index) => context.lineTo(index * step, yOf(value)));
        context.lineWidth = Theme.size.stroke * 2;
        context.lineJoin = "round";
        context.strokeStyle = lineColor;
        context.stroke();
        context.lineTo(width, height);
        context.lineTo(0, height);
        context.closePath();
        context.globalAlpha = fillOpacity;
        context.fillStyle = lineColor;
        context.fill();
    }
}
