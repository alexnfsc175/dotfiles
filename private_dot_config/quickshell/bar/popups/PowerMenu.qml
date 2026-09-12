import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components" as Components
import "../../theme" as Theme
import "../../i18n" as I18n

Components.BasePopup {
    id: powerMenu

    popupWidth: 280
    popupHeight: 320
    anchorX: barWindow.width - popupWidth - Theme.ThemeManager.popupAnchorMargin

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        Text {
            text: I18n.I18n.t("popup.powermenu.title")
            color: Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeXl
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            columns: 3
            columnSpacing: Theme.ThemeManager.spacingMd
            rowSpacing: Theme.ThemeManager.spacingMd
            Layout.fillWidth: true

            Repeater {
                model: [
                    { label: I18n.I18n.t("popup.powermenu.lock"), icon: Components.Icons.powerLock, action: "hyprlock" },
                    { label: I18n.I18n.t("popup.powermenu.logout"), icon: Components.Icons.powerLogout, action: "loginctl terminate-user $USER" },
                    { label: I18n.I18n.t("popup.powermenu.suspend"), icon: Components.Icons.powerSuspend, action: "systemctl suspend" },
                    { label: I18n.I18n.t("popup.powermenu.reboot"), icon: Components.Icons.powerReboot, action: "systemctl reboot" },
                    { label: I18n.I18n.t("popup.powermenu.hibernate"), icon: Components.Icons.powerHibernate, action: "systemctl hibernate" },
                    { label: I18n.I18n.t("popup.powermenu.shutdown"), icon: Components.Icons.powerShutdown, action: "systemctl poweroff" }
                ]

                delegate: Rectangle {
                    id: powerOption
                    required property var modelData
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    radius: Theme.ThemeManager.radiusLarge
                    color: optionMouseArea.containsMouse ? Theme.ThemeManager.surface0 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)

                    scale: optionMouseArea.containsMouse ? 1.05 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: Theme.ThemeManager.durationNormal }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: Theme.ThemeManager.durationNormal
                            easing.type: Easing.OutBack
                        }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: Theme.ThemeManager.spacingXs

                        Text {
                            text: powerOption.modelData.icon
                            color: optionMouseArea.containsMouse ? Theme.ThemeManager.accent : Theme.ThemeManager.text
                            font.pixelSize: 24
                            font.family: Components.Icons.fontFamily
                            Layout.alignment: Qt.AlignHCenter

                            Behavior on color {
                                ColorAnimation { duration: Theme.ThemeManager.durationNormal }
                            }
                        }

                        Text {
                            text: powerOption.modelData.label
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    MouseArea {
                        id: optionMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            let cmd = powerOption.modelData.action
                            Quickshell.execDetached(["bash", "-c", cmd])
                            powerMenu.visible = false
                        }
                    }
                }
            }
        }
    }
}
