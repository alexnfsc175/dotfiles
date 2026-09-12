import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../theme" as Theme
import "../../services" as Services
import "../../i18n" as I18n

Components.BasePopup {
    id: volumePopup

    popupWidth: 300
    popupHeight: 160

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.ThemeManager.spacingSm

            Text {
                text: Services.VolumeService?.muted ?? false ? Components.Icons.volumeMuted : Components.Icons.volumeHigh
                color: Services.VolumeService?.muted ?? false ? Theme.ThemeManager.error : Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeXl
                font.family: Theme.ThemeManager.fontFamily

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.VolumeService?.toggleMute()
                }
            }

            Text {
                text: I18n.I18n.t("popup.volume.device")
                color: Theme.ThemeManager.subtext0
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Theme.ThemeManager.fontFamily
                Layout.fillWidth: true
            }

            Text {
                text: (Services.VolumeService?.volume ?? 0) + "%"
                color: Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Theme.ThemeManager.fontFamily
                font.bold: true
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: Theme.ThemeManager.surface0

            Rectangle {
                width: parent.width * ((Services.VolumeService?.volume ?? 0) / 100)
                height: parent.height
                radius: parent.radius
                color: Services.VolumeService?.muted ?? false ? Theme.ThemeManager.error : Theme.ThemeManager.accent

                Behavior on width {
                    NumberAnimation { duration: Theme.ThemeManager.durationFast }
                }

                Behavior on color {
                    ColorAnimation { duration: Theme.ThemeManager.durationNormal }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: function(event) {
                    let ratio = event.x / width
                    Services.VolumeService?.setVolume(Math.round(ratio * 100))
                }
                onPositionChanged: function(event) {
                    if (pressed) {
                        let ratio = Math.max(0, Math.min(1, event.x / width))
                        Services.VolumeService?.setVolume(Math.round(ratio * 100)) 
                    }
                }
            }
        }
    }
}
