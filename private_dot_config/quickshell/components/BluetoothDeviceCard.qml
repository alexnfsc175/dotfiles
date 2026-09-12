import QtQuick
import QtQuick.Layouts
import "../theme" as Theme
import "../components" as Components
import "../services" as Services
import "../i18n" as I18n

Rectangle {
    id: root

    property var device: null
    property bool isHovered: deviceMouseArea.containsMouse
    property bool isMenuOpen: false

    signal connectRequested()
    signal disconnectRequested()
    signal forgetRequested()
    signal pairRequested()
    signal menuRequested(Item buttonItem)

    width: parent ? parent.width : 300
    height: 64
    radius: Theme.ThemeManager.radiusMedium
    color: isHovered ? Theme.ThemeManager.surface0 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)

    Behavior on color { ColorAnimation { duration: Theme.ThemeManager.durationFast } }

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingMd
        anchors.rightMargin: 40
        spacing: Theme.ThemeManager.spacingSm

        Components.BluetoothDeviceIcon {
            deviceType: root.device ? root.device.deviceType : "device"
            size: 24
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.device ? (root.device.name || I18n.I18n.t("popup.bluetooth.unknown")) : ""
                color: Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeMd
                font.family: Theme.ThemeManager.fontFamily
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: Theme.ThemeManager.spacingSm

                Components.BluetoothStatusBadge {
                    state: root.device ? root.device.state : "idle"
                    size: 10
                }

                Text {
                    text: {
                        if (!root.device) return ""
                        switch (root.device.state) {
                            case "connected": return I18n.I18n.t("popup.bluetooth.connected")
                            case "connecting": return I18n.I18n.t("popup.bluetooth.connecting")
                            case "paired": return I18n.I18n.t("popup.bluetooth.paired")
                            case "pairing": return I18n.I18n.t("popup.bluetooth.pairing")
                            case "failed": return I18n.I18n.t("popup.bluetooth.failed")
                            default: return I18n.I18n.t("popup.bluetooth.available")
                        }
                    }
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                }

                Components.BluetoothBatteryIndicator {
                    level: root.device ? root.device.battery : -1
                    size: 14
                    visible: root.device && root.device.battery >= 0
                    Layout.leftMargin: Theme.ThemeManager.spacingSm
                }
            }
        }
    }

    Rectangle {
        id: ellipsisButton
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        width: 28
        height: 28
        radius: 14
        color: root.isMenuOpen ? Theme.ThemeManager.surface1 : "transparent"

        Text {
            anchors.centerIn: parent
            text: Components.Icons.ellipsis
            color: Theme.ThemeManager.overlay1
            font.pixelSize: Theme.ThemeManager.fontSizeMd
            font.family: Components.Icons.fontFamily
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.menuRequested(ellipsisButton)
        }
    }

    MouseArea {
        id: deviceMouseArea
        anchors.fill: parent
        anchors.rightMargin: 40
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (!root.device) return
            if (root.device.paired) {
                if (root.device.connected) {
                    root.disconnectRequested()
                } else {
                    root.connectRequested()
                }
            } else {
                root.pairRequested()
            }
        }
    }
}
