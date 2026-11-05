pragma Singleton
import QtQuick
import Quickshell
import qs.src.config
import "../domain/time/format.mjs" as TimeFormat

Singleton {
    id: root

    readonly property var clockSettings: Settings.values.clock
    readonly property bool showSeconds: clockSettings.showSeconds && Appearance.clockSeconds
    readonly property var date: ({ year: clock.date.getFullYear(), month: clock.date.getMonth(), day: clock.date.getDate(), weekday: clock.date.getDay() })
    readonly property string timeText: TimeFormat.formatClockTime({ hours: clock.hours, minutes: clock.minutes, seconds: clock.seconds }, clockSettings.use24Hour, root.showSeconds, Settings.values.text.time)
    readonly property string shortDateText: TimeFormat.formatShortDate(date)
    readonly property string longDateText: TimeFormat.formatLongDate(date, Settings.values.text.time)
    readonly property int hours: clock.hours
    readonly property int minutes: clock.minutes
    readonly property real nowMs: clock.date.getTime()

    SystemClock {
        id: clock
        precision: root.showSeconds ? SystemClock.Seconds : SystemClock.Minutes
    }
}
