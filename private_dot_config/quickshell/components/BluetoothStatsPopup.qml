import QtQuick
import QtQuick.Layouts
import Quickshell
import "." as Components
import "../theme" as Theme
import "../services" as Services
import "../i18n" as I18n

PopupWindow {
    id: root

    required property var barWindow
    property bool isHovered: statsMouseArea.containsMouse

    property int popupWidth: 280
    property int popupHeight: contentLayout.implicitHeight + Theme.ThemeManager.spacingLg * 2
    property int anchorX: barWindow.width - popupWidth - Theme.ThemeManager.popupAnchorMargin - 50
    property int anchorY: barWindow.height + Theme.ThemeManager.popupAnchorY

    implicitWidth: popupWidth
    implicitHeight: popupHeight
    visible: false
    grabFocus: false
    color: Qt.rgba(
        Theme.ThemeManager.crust.r,
        Theme.ThemeManager.crust.g,
        Theme.ThemeManager.crust.b,
        Theme.ThemeManager.popupTransparency
    )

    anchor {
        window: barWindow
        rect.x: root.anchorX
        rect.y: root.anchorY
    }

    MouseArea {
        id: statsMouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        Text {
            text: I18n.I18n.t("popup.bluetooth.stats.title")
            color: Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
        }

        ColumnLayout {
            spacing: Theme.ThemeManager.spacingSm

            RowLayout {
                spacing: Theme.ThemeManager.spacingSm

                Text {
                    text: I18n.I18n.t("popup.bluetooth.stats.adapter") + ":"
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                Text {
                    text: Services.BluetoothService?.adapterName || I18n.I18n.t("popup.bluetooth.unknown")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            RowLayout {
                spacing: Theme.ThemeManager.spacingSm

                Text {
                    text: I18n.I18n.t("popup.bluetooth.stats.address") + ":"
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                Text {
                    text: Services.BluetoothService?.adapterAddress || I18n.I18n.t("popup.bluetooth.unknown")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Theme.ThemeManager.surface1
        }

        Text {
            text: I18n.I18n.t("popup.bluetooth.stats.connected")
            color: Theme.ThemeManager.subtext0
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
        }

        Repeater {
            model: Services.BluetoothService?.connectedDevices ?? []

            delegate: ColumnLayout {
                required property var modelData
                spacing: Theme.ThemeManager.spacingXs

                RowLayout {
                    spacing: Theme.ThemeManager.spacingSm

                    Components.BluetoothDeviceIcon {
                        deviceType: modelData.deviceType
                        size: 16
                    }

                    Text {
                        text: modelData.name || I18n.I18n.t("popup.bluetooth.unknown")
                        color: Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Components.BluetoothBatteryIndicator {
                        level: modelData.battery
                        size: 12
                        visible: modelData.battery >= 0
                    }
                }

                Text {
                    text: {
                        if (!modelData.profile) return ""
                        var profile = modelData.profile
                        if (modelData.codec) {
                            return profile + " (" + modelData.codec + ")"
                        }
                        return profile
                    }
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    visible: text.length > 0
                    Layout.leftMargin: 16 + Theme.ThemeManager.spacingSm
                }
            }
        }

        Text {
            text: I18n.I18n.t("popup.bluetooth.no-devices")
            color: Theme.ThemeManager.overlay0
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            Layout.alignment: Qt.AlignHCenter
            visible: (Services.BluetoothService?.connectedDevices?.length ?? 0) === 0
        }
    }
}
