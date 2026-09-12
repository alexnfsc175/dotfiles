import QtQuick
import QtQuick.Layouts
import "../theme" as Theme
import "../components" as Components
import "../services" as Services
import "../i18n" as I18n

Rectangle {
    id: root

    required property var modelData
    property bool isHovered: hoverArea.containsMouse
    property bool isActive: modelData.active || false
    property bool isSecured: modelData.security && modelData.security.length > 0
    property string displayName: modelData.ssid || I18n.I18n.t("popup.wifi.hidden")

    signal clicked()
    signal forgetRequested()

    width: ListView.view ? ListView.view.width : 300
    height: 52
    radius: Theme.ThemeManager.radiusMedium
    color: {
        if (root.isActive) return Qt.rgba(Theme.ThemeManager.accent.r, Theme.ThemeManager.accent.g, Theme.ThemeManager.accent.b, 0.15)
        if (root.isHovered) return Theme.ThemeManager.surface0
        return Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)
    }

    Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.ThemeManager.spacingMd
        anchors.rightMargin: Theme.ThemeManager.spacingMd
        spacing: Theme.ThemeManager.spacingSm

        Components.WifiSignalIndicator {
            signal: modelData.signal || 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 1

            Text {
                text: root.displayName
                color: root.isActive ? Theme.ThemeManager.accent : Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Theme.ThemeManager.fontFamily
                font.bold: root.isActive
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: Theme.ThemeManager.spacingXs

                Text {
                    text: root.isSecured ? Components.Icons.wifiLock : Components.Icons.lockOpen
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Components.Icons.fontFamily
                }

                Text {
                    text: root.isSecured ? Services.WifiService.securityLabel(modelData.security || "") : I18n.I18n.t("popup.wifi.security.open")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                }

                Text {
                    text: root.isActive ? I18n.I18n.t("popup.wifi.connected") : ""
                    color: Theme.ThemeManager.accent
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    visible: root.isActive
                }
            }
        }

        Text {
            text: modelData.signal + "%"
            color: Theme.ThemeManager.subtext0
            font.pixelSize: Theme.ThemeManager.fontSizeXs
            font.family: Theme.ThemeManager.fontFamily
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                if (modelData.saved) {
                    root.forgetRequested()
                }
            } else {
                root.clicked()
            }
        }
    }
}
