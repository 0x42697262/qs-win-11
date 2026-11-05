import QtQuick

QtObject {
    required property bool reduced
    required property var values

    readonly property var durations: values.durations
    readonly property int fast: pick(durations.fast)
    readonly property int normal: pick(durations.normal)
    readonly property int slow: pick(durations.slow)
    readonly property int slower: pick(durations.slower)
    readonly property int enter: pick(durations.enter)
    readonly property int exit: pick(durations.exit)
    readonly property int hover: pick(durations.hover)
    readonly property int press: pick(durations.press)
    readonly property int theme: pick(durations.theme)
    readonly property int toastEnter: pick(durations.toastEnter)
    readonly property int page: pick(durations.page)
    readonly property int stagger: reduced ? 0 : durations.stagger
    readonly property int staggerItem: pick(durations.staggerItem)
    readonly property int bounce: pick(durations.bounce)
    readonly property int dismiss: pick(durations.dismiss)
    readonly property list<real> decelerate: curve(values.easing.decelerate)
    readonly property list<real> pointToPoint: curve(values.easing.pointToPoint)
    readonly property list<real> accelerate: curve(values.easing.accelerate)
    readonly property list<real> emphasized: curve(values.easing.emphasized)
    readonly property list<real> exitCurve: curve(values.easing.exit)

    function pick(duration: int): int {
        return reduced ? durations.reduced : duration;
    }

    function curve(points: var): list<real> {
        return [points.x1, points.y1, points.x2, points.y2, 1, 1];
    }
}
