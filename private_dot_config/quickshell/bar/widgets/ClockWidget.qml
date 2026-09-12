import QtQuick
import Quickshell
import "../../theme" as Theme

Item {
    id: clockWidget
    width: clockText.implicitWidth + Theme.ThemeManager.spacingMd * 2
    height: clockText.implicitHeight + Theme.ThemeManager.spacingSm * 2

    property date currentTime: new Date()
    property bool isHovered: clockMouseArea.containsMouse
    signal clicked()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockWidget.currentTime = new Date()
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: Qt.formatDateTime(clockWidget.currentTime, "HH:mm  dd/MM/yyyy")
        color: Theme.ThemeManager.text
        font.pixelSize: Theme.ThemeManager.fontSizeMd
        font.family: Theme.ThemeManager.fontFamily
    }

    MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: clockWidget.clicked()
    }
}
