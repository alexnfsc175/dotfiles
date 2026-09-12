import QtQuick
import Quickshell
import "../theme" as Theme
import "../components" as Components

Item {
    id: root

    property int level: -1
    property real size: 16

    width: level >= 0 ? size : 0
    height: size
    visible: level >= 0

    Row {
        anchors.centerIn: parent
        spacing: 2

        Text {
            font.family: Components.Icons.fontFamily
            font.pixelSize: root.size * 0.7
            color: {
                if (root.level > 50) return Theme.ThemeManager.accent
                if (root.level > 20) return Theme.ThemeManager.warning
                return Theme.ThemeManager.error
            }
            text: {
                if (root.level > 75) return Components.Icons.batteryFull
                if (root.level > 50) return Components.Icons.batteryThreeQuarter
                if (root.level > 25) return Components.Icons.batteryHalf
                if (root.level > 10) return Components.Icons.batteryQuarter
                return Components.Icons.batteryEmpty
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            font.family: Theme.ThemeManager.fontFamily
            font.pixelSize: root.size * 0.6
            color: Theme.ThemeManager.subtext0
            text: root.level + "%"
        }
    }
}
