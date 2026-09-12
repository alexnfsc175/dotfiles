import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../theme" as Theme
import "../../i18n" as I18n

Components.BasePopup {
    id: calendarPopup

    popupWidth: 320
    popupHeight: 380
    anchorX: barWindow.width / 2 - popupWidth / 2

    property date displayDate: new Date()
    property int currentMonth: displayDate.getMonth()
    property int currentYear: displayDate.getFullYear()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: Components.Icons.chevronLeft
                color: Theme.ThemeManager.overlay1
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Components.Icons.fontFamily

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calendarPopup.currentMonth--
                        if (calendarPopup.currentMonth < 0) {
                            calendarPopup.currentMonth = 11
                            calendarPopup.currentYear--
                        }
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: {
                    var monthKey = "popup.calendar.month." + calendarPopup.currentMonth
                    return I18n.I18n.t(monthKey) + " " + calendarPopup.currentYear
                }
                color: Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Theme.ThemeManager.fontFamily
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Components.Icons.chevronRight
                color: Theme.ThemeManager.overlay1
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Components.Icons.fontFamily

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        calendarPopup.currentMonth++
                        if (calendarPopup.currentMonth > 11) {
                            calendarPopup.currentMonth = 0
                            calendarPopup.currentYear++
                        }
                    }
                }
            }
        }

        GridLayout {
            columns: 7
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: [
                    I18n.I18n.t("popup.calendar.day.0"),
                    I18n.I18n.t("popup.calendar.day.1"),
                    I18n.I18n.t("popup.calendar.day.2"),
                    I18n.I18n.t("popup.calendar.day.3"),
                    I18n.I18n.t("popup.calendar.day.4"),
                    I18n.I18n.t("popup.calendar.day.5"),
                    I18n.I18n.t("popup.calendar.day.6")
                ]
                delegate: Text {
                    required property var modelData
                    text: modelData
                    color: Theme.ThemeManager.overlay1
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Repeater {
                model: 42

                delegate: Rectangle {
                    required property int index
                    property date firstDay: new Date(calendarPopup.currentYear, calendarPopup.currentMonth, 1)
                    property int startDay: (firstDay.getDay() + 6) % 7
                    property int daysInMonth: new Date(calendarPopup.currentYear, calendarPopup.currentMonth + 1, 0).getDate()
                    property int dayNum: index - startDay + 1
                    property bool isValid: dayNum > 0 && dayNum <= daysInMonth
                    property bool isToday: isValid && dayNum === new Date().getDate() &&
                                         calendarPopup.currentMonth === new Date().getMonth() &&
                                         calendarPopup.currentYear === new Date().getFullYear()

                    visible: isValid
                    width: 36
                    height: 36
                    radius: Theme.ThemeManager.radiusMedium
                    color: isToday ? Theme.ThemeManager.accent : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: parent.dayNum.toString()
                        color: parent.isToday ? Theme.ThemeManager.crust : Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                        font.bold: parent.isToday
                    }
                }
            }
        }
    }
}
