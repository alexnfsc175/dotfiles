import QtQuick
import QtQuick.Layouts
import "../theme" as Theme
import "../components" as Components
import "../services" as Services
import "../i18n" as I18n

Rectangle {
    id: root

    property string address: ""
    property string deviceName: ""
    property string pin: ""
    property string passkey: ""
    property bool showPin: false
    property bool showPasskey: false
    property string error: ""

    signal accepted()
    signal rejected()
    signal cancelled()

    anchors.fill: parent
    color: Qt.rgba(Theme.ThemeManager.crust.r, Theme.ThemeManager.crust.g, Theme.ThemeManager.crust.b, 0.95)
    visible: showPin || showPasskey
    z: 300

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.ThemeManager.spacingLg
        width: parent.width * 0.8

        Text {
            text: I18n.I18n.t("popup.bluetooth.pairing.title") + ": " + root.deviceName
            color: Theme.ThemeManager.text
            font.pixelSize: Theme.ThemeManager.fontSizeLg
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        ColumnLayout {
            spacing: Theme.ThemeManager.spacingSm
            visible: root.showPin

            Text {
                text: I18n.I18n.t("popup.bluetooth.pairing.pin")
                color: Theme.ThemeManager.subtext0
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Theme.ThemeManager.fontFamily
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 40
                radius: Theme.ThemeManager.radiusSmall
                color: Theme.ThemeManager.surface1
                border.color: Theme.ThemeManager.surface2
                border.width: 1

                TextInput {
                    id: pinInput
                    anchors.fill: parent
                    anchors.margins: Theme.ThemeManager.spacingSm
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeMd
                    font.family: Theme.ThemeManager.fontFamily
                    verticalAlignment: TextInput.AlignVCenter
                    maximumLength: 16
                    clip: true

                    onTextChanged: root.pin = text
                }
            }
        }

        ColumnLayout {
            spacing: Theme.ThemeManager.spacingSm
            visible: root.showPasskey

            Text {
                text: I18n.I18n.t("popup.bluetooth.pairing.passkey") + ": " + root.passkey
                color: Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Theme.ThemeManager.fontFamily
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Text {
            text: root.error
            color: Theme.ThemeManager.error
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            visible: root.error.length > 0
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            spacing: Theme.ThemeManager.spacingMd
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                width: 100
                height: 36
                radius: Theme.ThemeManager.radiusSmall
                color: Theme.ThemeManager.surface1

                Text {
                    anchors.centerIn: parent
                    text: I18n.I18n.t("popup.bluetooth.pairing.cancel")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.cancelled()
                }
            }

            Rectangle {
                width: 100
                height: 36
                radius: Theme.ThemeManager.radiusSmall
                color: Theme.ThemeManager.accent

                Text {
                    anchors.centerIn: parent
                    text: root.showPasskey ? I18n.I18n.t("popup.bluetooth.pairing.confirm") : I18n.I18n.t("popup.bluetooth.pairing.accept")
                    color: Theme.ThemeManager.fgPrimary
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.accepted()
                }
            }
        }
    }
}
