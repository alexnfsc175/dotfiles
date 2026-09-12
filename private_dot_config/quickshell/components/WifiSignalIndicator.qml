import QtQuick
import "../theme" as Theme
import "../components" as Components

Item {
    id: root

    property int signal: 0

    width: Theme.ThemeManager.fontSizeLg
    height: Theme.ThemeManager.fontSizeLg

    Text {
        anchors.centerIn: parent
        text: {
            if (root.signal < 25) return Components.Icons.wifiWeak
            if (root.signal < 50) return Components.Icons.wifiLow
            if (root.signal < 75) return Components.Icons.wifiMedium
            return Components.Icons.wifiHigh
        }
        color: {
            if (root.signal < 25) return Theme.ThemeManager.warning
            if (root.signal < 50) return Theme.ThemeManager.overlay1
            return Theme.ThemeManager.text
        }
        font.pixelSize: Theme.ThemeManager.fontSizeLg
        font.family: Components.Icons.fontFamily

        Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }
    }
}
