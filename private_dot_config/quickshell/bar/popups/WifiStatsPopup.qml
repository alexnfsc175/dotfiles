import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components" as Components
import "../../theme" as Theme
import "../../services" as Services
import "../../i18n" as I18n

PopupWindow {
    id: statsPopup

    required property var barWindow
    property int popupWidth: 280
    property int anchorX: barWindow.width - popupWidth - Theme.ThemeManager.popupAnchorMargin
    property int anchorY: barWindow.height + Theme.ThemeManager.popupAnchorY

    implicitWidth: popupWidth
    implicitHeight: statsContent.implicitHeight + Theme.ThemeManager.spacingLg * 2
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
        rect.x: statsPopup.anchorX
        rect.y: statsPopup.anchorY
    }

    property bool isConnected: Services.WifiService?.connected ?? false

    function formatUptime(ts) {
        return Services.WifiService?.formatUptime(ts) ?? ""
    }

    ColumnLayout {
        id: statsContent
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingSm

        Text {
            text: I18n.I18n.t("popup.wifi.stats.title")
            color: Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeMd
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Qt.rgba(Theme.ThemeManager.text.r, Theme.ThemeManager.text.g, Theme.ThemeManager.text.b, 0.1)
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.ThemeManager.spacingXs
            visible: statsPopup.isConnected

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.ssid")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.ssid ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.signal")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: {
                        var sig = Services.WifiService?.signal ?? 0
                        return sig + "% — " + I18n.I18n.t("popup.wifi.signal." + Services.WifiService?.signalLevel(sig))
                    }
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.frequency ?? 0) > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.frequency")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: {
                        var freq = Services.WifiService?.connectionDetails?.frequency ?? 0
                        return freq > 0 ? freq + " MHz" : ""
                    }
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.band ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.band")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.band ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.generation ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.generation")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.generation ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(Theme.ThemeManager.text.r, Theme.ThemeManager.text.g, Theme.ThemeManager.text.b, 0.05)
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.ipv4 ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.ipv4")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.ipv4 ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.ipv6 ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.ipv6")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.ipv6 ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                    elide: Text.ElideMiddle
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.gateway ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.gateway")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.gateway ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.dns ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.dns")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.dns ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.linkSpeed ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.speed")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.linkSpeed ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.interface ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.interface")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.interface ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.mac ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.mac")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.connectionDetails?.mac ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.security ?? "").length > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.security")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: Services.WifiService?.securityLabel(Services.WifiService?.connectionDetails?.security ?? "") ?? ""
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.ThemeManager.spacingMd
                visible: (Services.WifiService?.connectionDetails?.uptime ?? 0) > 0
                Text {
                    text: I18n.I18n.t("popup.wifi.stats.uptime")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.preferredWidth: 100
                }
                Text {
                    text: statsPopup.formatUptime(Services.WifiService?.connectionDetails?.uptime ?? 0)
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.fillWidth: true
                }
            }
        }

        Text {
            text: I18n.I18n.t("popup.wifi.disabled")
            color: Theme.ThemeManager.overlay0
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            visible: !statsPopup.isConnected && !(Services.WifiService?.enabled ?? false)
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: I18n.I18n.t("popup.wifi.no.networks")
            color: Theme.ThemeManager.overlay0
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            visible: !statsPopup.isConnected && (Services.WifiService?.enabled ?? false)
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
