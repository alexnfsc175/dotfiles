import QtQuick
import QtQuick.Layouts
import "../widgets" as Widgets

Item {
    id: centerSection

    signal toggleCalendar()

    implicitWidth: clockWidget.implicitWidth
    implicitHeight: clockWidget.implicitHeight

    Widgets.ClockWidget {
        id: clockWidget
        anchors.centerIn: parent
        onClicked: centerSection.toggleCalendar()
    }
}
