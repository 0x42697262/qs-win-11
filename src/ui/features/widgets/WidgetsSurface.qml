pragma ComponentBehavior: Bound
import QtQuick
import qs.src.config
import QtQuick.Layouts
import qs.src.services
import qs.src.ui.theme
import qs.src.ui.components
import qs.src.ui.features.quickSettings
import qs.src.ui.features.notifications
import "../../../domain/weather/weather.mjs" as WeatherRules
import "../../../domain/time/format.mjs" as TimeFormat
import "../../../domain/system/indicators.mjs" as Indicators
import "../../../domain/catalog/uiEnums.mjs" as UiEnums

FocusScope {
    id: root

    readonly property var text: Settings.values.text.widgets

    Component.onCompleted: SystemStats.watching = true
    Component.onDestruction: SystemStats.watching = false

    FlyoutPanel {
        anchors.left: parent.left
        anchors.leftMargin: Theme.spacing.medium
        anchors.top: parent.top
        anchors.topMargin: Theme.spacing.medium
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacing.medium
        width: Theme.size.widgetsWidth

        Flickable {
            anchors.fill: parent
            anchors.margins: Theme.spacing.xLarge
            contentHeight: content.implicitHeight
            clip: true

            ColumnLayout {
                id: content
                width: parent.width
                spacing: Theme.spacing.large

                RowLayout {
                    Layout.fillWidth: true

                    Label { text: Clock.timeText; variant: UiEnums.TextVariant.Subtitle }
                    Item { Layout.fillWidth: true }
                    Label { text: Clock.longDateText; tone: UiEnums.TextTone.Secondary }
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacing.large

                    WidgetCard {
                        visible: Features.enabled.weather
                        width: Theme.size.widgetCard
                        title: Weather.location && Weather.location.placeName !== "" ? Weather.location.placeName : root.text.weather

                        Label {
                            visible: !Weather.available
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            text: Weather.location === null ? root.text.noLocation : Weather.failed ? root.text.weatherFailed : ""
                            tone: UiEnums.TextTone.Secondary
                        }

                        RowLayout {
                            visible: Weather.available
                            spacing: Theme.spacing.large

                            FluentIcon {
                                glyph: Weather.current ? Weather.current.icon : null
                                size: Theme.iconSize.hero
                            }

                            ColumnLayout {
                                spacing: 0
                                Label { text: Weather.temperatureText; variant: UiEnums.TextVariant.TitleLarge }
                                Label { text: Weather.current ? Weather.current.text : ""; tone: UiEnums.TextTone.Secondary }
                            }
                        }

                        RowLayout {
                            visible: Weather.available
                            Layout.fillWidth: true
                            spacing: 0

                            Repeater {
                                model: Weather.forecast ? Weather.forecast.days : []

                                ColumnLayout {
                                    id: day

                                    required property var modelData

                                    Layout.preferredWidth: Theme.size.forecastDay
                                    spacing: Theme.spacing.xxSmall

                                    Label { Layout.alignment: Qt.AlignHCenter; text: TimeFormat.shortWeekdayFromIso(day.modelData.dateIso, Settings.values.text.time); variant: UiEnums.TextVariant.Caption }
                                    FluentIcon { Layout.alignment: Qt.AlignHCenter; glyph: WeatherRules.describeWeather(day.modelData.code, Settings.values.text.weather).icon }
                                    Label { Layout.alignment: Qt.AlignHCenter; text: WeatherRules.formatTemperature(day.modelData.high); variant: UiEnums.TextVariant.Caption }
                                    Label { Layout.alignment: Qt.AlignHCenter; text: WeatherRules.formatTemperature(day.modelData.low); variant: UiEnums.TextVariant.Caption; tone: UiEnums.TextTone.Secondary }
                                }
                            }
                        }

                        Label {
                            visible: Weather.available && Location.source !== WeatherRules.LocationSource.Manual
                            text: root.text.approximateLocation
                            variant: UiEnums.TextVariant.Caption
                            tone: UiEnums.TextTone.Tertiary
                        }
                    }

                    WidgetCard {
                        width: Theme.size.widgetCard
                        title: root.text.system

                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: root.text.cpu; Layout.preferredWidth: Theme.size.forecastDay }
                            ProgressBar { Layout.fillWidth: true; value: SystemStats.cpu }
                            Label { text: `${Indicators.toPercent(SystemStats.cpu)}%`; Layout.preferredWidth: Theme.size.forecastDay; horizontalAlignment: Text.AlignRight }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Label { text: root.text.memory; Layout.preferredWidth: Theme.size.forecastDay }
                            ProgressBar { Layout.fillWidth: true; value: SystemStats.memory }
                            Label { text: `${Indicators.toPercent(SystemStats.memory)}%`; Layout.preferredWidth: Theme.size.forecastDay; horizontalAlignment: Text.AlignRight }
                        }
                    }

                    WidgetCard {
                        visible: Media.player !== null
                        width: Theme.size.widgetCard
                        title: root.text.media

                        Loader {
                            active: Media.player !== null
                            Layout.fillWidth: true
                            sourceComponent: MediaCard {
                                player: Media.player
                                color: Theme.colors.transparent
                                borderWidth: 0
                            }
                        }
                    }

                    WidgetCard {
                        width: Theme.size.widgetCard
                        title: root.text.calendar

                        CalendarView { Layout.fillWidth: true }
                    }
                }
            }
        }
    }
}
