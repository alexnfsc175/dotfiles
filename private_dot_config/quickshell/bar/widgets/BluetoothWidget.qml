import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../services" as Services
import "../../theme" as Theme
import "../../i18n" as I18n

Item {
    id: bluetoothWidget
    width: Theme.ThemeManager.widgetWidth
    height: Theme.ThemeManager.widgetHeight

    property bool isHovered: btMouseArea.containsMouse
    signal clicked()
    signal hoverEntered()
    signal hoverExited()

    property bool isEnabled: Services.BluetoothService?.powered ?? false
    property int connectedCount: Services.BluetoothService?.connectedDevices?.length ?? 0

    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.radiusSmall
        color: bluetoothWidget.isHovered ? Theme.ThemeManager.surface0 : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

        Text {
            id: btIcon
            anchors.centerIn: parent
            text: bluetoothWidget.isEnabled ? Components.Icons.bluetoothOn : Components.Icons.bluetoothOff
            color: bluetoothWidget.isEnabled ? Theme.ThemeManager.text : Theme.ThemeManager.overlay0
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Components.Icons.fontFamily
        }

        Text {
            anchors.left: btIcon.left
            anchors.bottom: btIcon.bottom
            anchors.leftMargin: 9
            anchors.bottomMargin: -2
            text: bluetoothWidget.connectedCount.toString()
            color: Theme.ThemeManager.accent
            font.pixelSize: 7
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
            visible: bluetoothWidget.connectedCount > 0
        }
    }

    MouseArea {
        id: btMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: bluetoothWidget.clicked()
        onHoveredChanged: {
            if (containsMouse) {
                hoverOpenTimer.start()
                hoverCloseTimer.stop()
            } else {
                hoverCloseTimer.start()
                hoverOpenTimer.stop()
            }
        }
    }

    Timer {
        id: hoverOpenTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            if (btMouseArea.containsMouse) {
                bluetoothWidget.hoverEntered()
            }
        }
    }

    Timer {
        id: hoverCloseTimer
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            if (!btMouseArea.containsMouse) {
                bluetoothWidget.hoverExited()
            }
        }
    }
}
