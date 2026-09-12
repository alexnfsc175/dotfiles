import QtQuick
import "../../components" as Components
import "../../services" as Services
import "../../theme" as Theme

Item {
    id: volumeWidget
    width: Theme.ThemeManager.widgetWidth
    height: Theme.ThemeManager.widgetHeight

    property bool isHovered: volMouseArea.containsMouse
    signal clicked()

    property int volValue: Services.VolumeService?.volume ?? 0
    property bool isMuted: Services.VolumeService?.muted ?? false

    Rectangle {
        anchors.fill: parent
        radius: Theme.ThemeManager.radiusSmall
        color: volumeWidget.isHovered ? Theme.ThemeManager.surface0 : "transparent"
        Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

        Text {
            anchors.centerIn: parent
            text: {
                if (volumeWidget.isMuted) return Components.Icons.volumeMuted
                if (volumeWidget.volValue < 33) return Components.Icons.volumeLow
                if (volumeWidget.volValue < 66) return Components.Icons.volumeMedium
                return Components.Icons.volumeHigh
            }
            color: volumeWidget.isMuted ? Theme.ThemeManager.error : Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Theme.ThemeManager.fontFamily
            Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationNormal } }
        }
    }

    MouseArea {
        id: volMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: volumeWidget.clicked()
        onWheel: function(event) {
            if (event.angleDelta.y > 0) Services.VolumeService?.increaseVolume()
            else Services.VolumeService?.decreaseVolume()
        }
    }
}
