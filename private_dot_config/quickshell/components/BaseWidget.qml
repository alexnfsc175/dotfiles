import QtQuick
import "../theme" as Theme

Item {
    id: baseWidget

    property string icon: ""
    property string label: ""
    property bool isHovered: mouseArea.containsMouse
    signal clicked()

    width: Theme.ThemeManager.widgetWidth
    height: Theme.ThemeManager.widgetHeight

    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.radiusSmall
        color: baseWidget.isHovered ? Theme.ThemeManager.surface0 : "transparent"

        Behavior on color {
            ColorAnimation { duration: Theme.ThemeManager.durationFast }
        }

        Text {
            anchors.centerIn: parent
            text: baseWidget.icon
            color: Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Theme.ThemeManager.fontFamily

            Behavior on color {
                ColorAnimation { duration: Theme.ThemeManager.durationNormal }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: baseWidget.clicked()
    }
}
