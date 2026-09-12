import QtQuick
import Quickshell
import "../theme" as Theme
import "../components" as Components

Item {
    id: root

    property string state: "idle"
    property real size: 12

    width: size
    height: size

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: {
            switch (root.state) {
                case "connected": return Theme.ThemeManager.accent
                case "connecting": return Theme.ThemeManager.accent
                case "paired": return Theme.ThemeManager.subtext0
                case "pairing": return Theme.ThemeManager.warning
                case "failed": return Theme.ThemeManager.error
                case "disconnecting": return Theme.ThemeManager.subtext0
                default: return "transparent"
            }
        }
        opacity: root.state === "connecting" || root.state === "pairing" ? 0.7 : 1.0

        SequentialAnimation on opacity {
            running: root.state === "connecting" || root.state === "pairing"
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 800 }
            NumberAnimation { to: 1.0; duration: 800 }
        }
    }

    Text {
        anchors.centerIn: parent
        font.family: Components.Icons.fontFamily
        font.pixelSize: root.size * 0.6
        color: Theme.ThemeManager.text
        visible: root.state === "connected" || root.state === "failed"
        text: {
            switch (root.state) {
                case "connected": return Components.Icons.check
                case "failed": return Components.Icons.xMark
                default: return ""
            }
        }
    }
}
