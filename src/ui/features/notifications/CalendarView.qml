pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src.config
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import "../../../domain/time/calendar.mjs" as CalendarRules
import "../../../domain/time/format.mjs" as TimeFormat
import "../../../domain/catalog/icons.mjs" as Icons
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

ColumnLayout {
    id: root

    property int shownYear: Clock.date.year
    property int shownMonth: Clock.date.month
    readonly property string firstDayOfWeek: Settings.values.clock.firstDayOfWeek

    function shift(delta: int): void {
        const next = CalendarRules.addMonths(shownYear, shownMonth, delta);
        shownYear = next.year;
        shownMonth = next.month;
    }

    spacing: Theme.spacing.small

    RowLayout {
        Layout.fillWidth: true

        Label {
            Layout.fillWidth: true
            text: TimeFormat.formatMonthYear(root.shownYear, root.shownMonth)
            variant: UiEnums.TextVariant.BodyStrong
        }

        IconButton { icon: Icons.Icon.chevronUp; onActivated: root.shift(-1) }
        IconButton { icon: Icons.Icon.chevronDown; onActivated: root.shift(1) }
    }

    GridLayout {
        Layout.alignment: Qt.AlignHCenter
        columns: CalendarRules.DAYS_PER_WEEK
        columnSpacing: 0
        rowSpacing: 0

        Repeater {
            model: CalendarRules.weekdayHeaders(root.firstDayOfWeek)

            Label {
                required property string modelData
                Layout.preferredWidth: Theme.size.calendarCell
                Layout.preferredHeight: Theme.size.calendarCell
                horizontalAlignment: Text.AlignHCenter
                text: modelData
            }
        }

        Repeater {
            model: CalendarRules.monthGrid(root.shownYear, root.shownMonth, root.firstDayOfWeek)

            Item {
                id: cell

                required property var modelData
                readonly property bool today: modelData.year === Clock.date.year && modelData.month === Clock.date.month && modelData.day === Clock.date.day

                Layout.preferredWidth: Theme.size.calendarCell
                Layout.preferredHeight: Theme.size.calendarCell

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - Theme.spacing.xSmall
                    height: width
                    radius: width / 2
                    color: cell.today ? Theme.colors.accent : Theme.colors.transparent
                }

                Label {
                    anchors.centerIn: parent
                    text: cell.modelData.day
                    tone: cell.today ? UiEnums.TextTone.OnAccent : cell.modelData.inMonth ? UiEnums.TextTone.Primary : UiEnums.TextTone.Tertiary
                }
            }
        }
    }
}
