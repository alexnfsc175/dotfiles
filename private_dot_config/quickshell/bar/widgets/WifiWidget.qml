import QtQuick
import "../../components" as Components
import "../../services" as Services
import "../../theme" as Theme

Item {
    id: wifiWidget
    width: Theme.ThemeManager.widgetWidth
    height: Theme.ThemeManager.widgetHeight

    property bool isHovered: wifiMouseArea.containsMouse
    property bool isConnected: Services.WifiService?.connected ?? false
    property int currentSignal: Services.WifiService?.signal ?? 0
    property string connectionState: Services.WifiService?.connectionState ?? "disconnected"
    signal clicked()
    signal hoverEntered()
    signal hoverExited()

    Timer {
        id: hoverOpenTimer
        interval: 500
        onTriggered: wifiWidget.hoverEntered()
    }

    Timer {
        id: hoverCloseTimer
        interval: 200
        onTriggered: wifiWidget.hoverExited()
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.radiusSmall
        color: wifiWidget.isHovered ? Theme.ThemeManager.surface0 : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

        Text {
            anchors.centerIn: parent
            text: {
                if (!wifiWidget.isConnected) return Components.Icons.wifiOff
                return Components.Icons.wifiHigh
            }
            color: {
                if (wifiWidget.connectionState === "connecting") return Theme.ThemeManager.accent
                if (wifiWidget.connectionState === "failed") return Theme.ThemeManager.error
                if (!wifiWidget.isConnected) return Theme.ThemeManager.overlay0
                if (wifiWidget.currentSignal < 25) return Theme.ThemeManager.warning
                return Theme.ThemeManager.text
            }
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Components.Icons.fontFamily

            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationNormal } }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: wifiWidget.connectionState === "connecting"
                NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
            }
        }
    }

    MouseArea {
        id: wifiMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: hoverOpenTimer.start()
        onExited: {
            hoverOpenTimer.stop()
            hoverCloseTimer.start()
        }
        onClicked: {
            hoverOpenTimer.stop()
            hoverCloseTimer.stop()
            wifiWidget.hoverExited()
            wifiWidget.clicked()
        }
    }
}
