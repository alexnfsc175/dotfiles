import QtQuick
import "../../components" as Components
import "../../services" as Services
import "../../theme" as Theme

Item {
    id: batteryWidget
    width: Theme.ThemeManager.widgetWidth
    height: Theme.ThemeManager.widgetHeight

    property bool isHovered: batMouseArea.containsMouse
    signal clicked()

    property int batPercent: Services.BatteryService?.percentage ?? 0
    property string batStatus: Services.BatteryService?.status ?? "unknown"
    property string batIcon: {
        if (batPercent > 90) return Components.Icons.batteryFull
        if (batPercent > 70) return Components.Icons.batteryThreeQuarter
        if (batPercent > 50) return Components.Icons.batteryHalf
        if (batPercent > 30) return Components.Icons.batteryQuarter
        return Components.Icons.batteryEmpty
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.radiusSmall
        color: batteryWidget.isHovered ? Theme.ThemeManager.surface0 : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

        Text {
            anchors.centerIn: parent
            text: batteryWidget.batIcon
            color: {
                if (batteryWidget.batPercent < 15) return Theme.ThemeManager.error
                if (batteryWidget.batPercent < 30) return Theme.ThemeManager.peach
                return Theme.ThemeManager.text
            }
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Theme.ThemeManager.fontFamily
            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationNormal } }
        }
    }

    MouseArea {
        id: batMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: batteryWidget.clicked()
    }
}
