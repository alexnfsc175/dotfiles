import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../theme" as Theme
import "../../services" as Services
import "../../i18n" as I18n

Components.BasePopup {
    id: wifiPopup

    popupWidth: 360
    popupHeight: 480

    property string currentView: "list"
    property var selectedNetwork: null
    property string forgetTargetSsid: ""

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: I18n.I18n.t("popup.wifi.title")
                color: Theme.ThemeManager.text
                font.pixelSize: Theme.ThemeManager.fontSizeLg
                font.family: Theme.ThemeManager.fontFamily
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Components.Icons.scanning
                color: Theme.ThemeManager.accent
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Components.Icons.fontFamily
                visible: Services.WifiService?.scanning ?? false

                NumberAnimation on rotation {
                    from: 0; to: 360
                    duration: 1000
                    loops: Animation.Infinite
                    running: Services.WifiService?.scanning ?? false
                }
            }

            Rectangle {
                width: 48
                height: 26
                radius: 13
                color: Services.WifiService?.enabled ?? false ? Theme.ThemeManager.accent : Theme.ThemeManager.surface1

                Rectangle {
                    width: 22
                    height: 22
                    radius: 11
                    color: Theme.ThemeManager.crust
                    anchors.verticalCenter: parent.verticalCenter
                    x: Services.WifiService?.enabled ?? false ? parent.width - width - 2 : 2
                    Behavior on x { NumberAnimation { duration: Theme.ThemeManager.durationNormal } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Services.WifiService?.toggleWifi()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: listView
                anchors.fill: parent
                spacing: Theme.ThemeManager.spacingMd
                visible: wifiPopup.currentView === "list" && (Services.WifiService?.enabled ?? false)

                Rectangle {
                    Layout.fillWidth: true
                    height: connectedColumn.implicitHeight + Theme.ThemeManager.spacingMd * 2
                    radius: Theme.ThemeManager.radiusMedium
                    color: Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.5)
                    visible: Services.WifiService?.connected ?? false

                    ColumnLayout {
                        id: connectedColumn
                        anchors.fill: parent
                        anchors.margins: Theme.ThemeManager.spacingMd
                        spacing: 2

                        Text {
                            text: Services.WifiService?.ssid ?? ""
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeMd
                            font.family: Theme.ThemeManager.fontFamily
                            font.bold: true
                        }

                        Text {
                            text: {
                                var details = Services.WifiService?.connectionDetails ??({})
                                var parts = []
                                if (details.ipv4) parts.push(details.ipv4)
                                if (details.linkSpeed) parts.push(details.linkSpeed)
                                return parts.join(" · ")
                            }
                            color: Theme.ThemeManager.subtext0
                            font.pixelSize: Theme.ThemeManager.fontSizeXs
                            font.family: Theme.ThemeManager.fontFamily
                        }

                        RowLayout {
                            spacing: Theme.ThemeManager.spacingSm

                            Rectangle {
                                width: disconnectLabel.implicitWidth + Theme.ThemeManager.spacingMd * 2
                                height: 28
                                radius: Theme.ThemeManager.radiusSmall
                                color: disconnectMa.containsMouse ? Theme.ThemeManager.surface1 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.5)

                                Text {
                                    id: disconnectLabel
                                    anchors.centerIn: parent
                                    text: Services.WifiService?.connectionState === "disconnecting" ? I18n.I18n.t("popup.wifi.disconnecting") : I18n.I18n.t("popup.wifi.disconnect")
                                    color: Theme.ThemeManager.subtext0
                                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                                    font.family: Theme.ThemeManager.fontFamily
                                }

                                MouseArea {
                                    id: disconnectMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Services.WifiService?.disconnect()
                                }
                            }

                            Rectangle {
                                width: forgetLabel.implicitWidth + Theme.ThemeManager.spacingMd * 2
                                height: 28
                                radius: Theme.ThemeManager.radiusSmall
                                color: forgetMa.containsMouse ? Theme.ThemeManager.surface1 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.5)

                                Text {
                                    id: forgetLabel
                                    anchors.centerIn: parent
                                    text: I18n.I18n.t("popup.wifi.forget")
                                    color: Theme.ThemeManager.subtext0
                                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                                    font.family: Theme.ThemeManager.fontFamily
                                }

                                MouseArea {
                                    id: forgetMa
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        wifiPopup.forgetTargetSsid = Services.WifiService?.ssid ?? ""
                                        wifiPopup.currentView = "forgetConfirm"
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    text: I18n.I18n.t("popup.wifi.networks")
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: Theme.ThemeManager.spacingXs

                    model: Services.WifiService?.networks ?? null

                    delegate: Components.WifiNetworkCard {
                        onClicked: {
                            if (modelData.active) return
                            if (Services.WifiService.isNetworkSecured(modelData.security)) {
                                wifiPopup.selectedNetwork = modelData
                                wifiPopup.currentView = "password"
                            } else {
                                Services.WifiService?.connect(modelData.ssid)
                            }
                        }
                        onForgetRequested: {
                            wifiPopup.forgetTargetSsid = modelData.ssid
                            wifiPopup.currentView = "forgetConfirm"
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: I18n.I18n.t("popup.wifi.no.networks")
                        color: Theme.ThemeManager.overlay0
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                        visible: parent.count === 0 && !(Services.WifiService?.scanning ?? false)
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 32
                    radius: Theme.ThemeManager.radiusMedium
                    color: refreshMa.containsMouse ? Theme.ThemeManager.surface0 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)

                    Text {
                        anchors.centerIn: parent
                        text: I18n.I18n.t("popup.wifi.refresh")
                        color: Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                    }

                    MouseArea {
                        id: refreshMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Services.WifiService?.refresh()
                    }
                }
            }

            ColumnLayout {
                id: disabledView
                anchors.fill: parent
                spacing: Theme.ThemeManager.spacingMd
                visible: wifiPopup.currentView === "list" && !(Services.WifiService?.enabled ?? false)

                Item { Layout.fillHeight: true }

                Text {
                    text: Components.Icons.wifiOff
                    color: Theme.ThemeManager.overlay0
                    font.pixelSize: 48
                    font.family: Components.Icons.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: I18n.I18n.t("popup.wifi.disabled")
                    color: Theme.ThemeManager.overlay0
                    font.pixelSize: Theme.ThemeManager.fontSizeMd
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    width: enableLabel.implicitWidth + Theme.ThemeManager.spacingLg * 2
                    height: 36
                    radius: Theme.ThemeManager.radiusMedium
                    color: enableMa.containsMouse ? Theme.ThemeManager.accent : Qt.rgba(Theme.ThemeManager.accent.r, Theme.ThemeManager.accent.g, Theme.ThemeManager.accent.b, 0.2)
                    Layout.alignment: Qt.AlignHCenter

                    Text {
                        id: enableLabel
                        anchors.centerIn: parent
                        text: I18n.I18n.t("popup.wifi.toggle")
                        color: Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                    }

                    MouseArea {
                        id: enableMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Services.WifiService?.toggleWifi()
                    }
                }

                Item { Layout.fillHeight: true }
            }

            ColumnLayout {
                id: passwordView
                anchors.fill: parent
                spacing: Theme.ThemeManager.spacingMd
                visible: wifiPopup.currentView === "password"

                Text {
                    text: I18n.I18n.t("popup.wifi.password.title")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeLg
                    font.family: Theme.ThemeManager.fontFamily
                    font.bold: true
                }

                Text {
                    text: wifiPopup.selectedNetwork ? (wifiPopup.selectedNetwork.ssid || I18n.I18n.t("popup.wifi.hidden")) : ""
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: Theme.ThemeManager.radiusMedium
                    color: Theme.ThemeManager.surface0

                    TextInput {
                        id: passwordInput
                        anchors.fill: parent
                        anchors.margins: Theme.ThemeManager.spacingSm
                        color: Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeMd
                        font.family: Theme.ThemeManager.fontFamily
                        clip: true
                        echoMode: showPasswordToggle.checked ? TextInput.Normal : TextInput.Password
                        enabled: Services.WifiService?.connectionState !== "connecting"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: I18n.I18n.t("popup.wifi.password.placeholder")
                            color: Theme.ThemeManager.overlay0
                            font.pixelSize: Theme.ThemeManager.fontSizeMd
                            font.family: Theme.ThemeManager.fontFamily
                            visible: passwordInput.text.length === 0 && passwordInput.enabled
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: showPasswordToggle.checked ? I18n.I18n.t("popup.wifi.password.hide") : I18n.I18n.t("popup.wifi.password.show")
                        color: Theme.ThemeManager.subtext0
                        font.pixelSize: Theme.ThemeManager.fontSizeXs
                        font.family: Theme.ThemeManager.fontFamily

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: showPasswordToggle.checked = !showPasswordToggle.checked
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: Components.Icons.wifiConnecting
                        color: Theme.ThemeManager.accent
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Components.Icons.fontFamily
                        visible: Services.WifiService?.connectionState === "connecting"

                        NumberAnimation on rotation {
                            from: 0; to: 360
                            duration: 1000
                            loops: Animation.Infinite
                            running: Services.WifiService?.connectionState === "connecting"
                        }
                    }

                    Text {
                        text: Services.WifiService?.connectionState === "connecting" ? I18n.I18n.t("popup.wifi.connecting") : ""
                        color: Theme.ThemeManager.accent
                        font.pixelSize: Theme.ThemeManager.fontSizeXs
                        font.family: Theme.ThemeManager.fontFamily
                    }
                }

                Text {
                    text: Services.WifiService?.lastError ?? ""
                    color: Theme.ThemeManager.error
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    visible: Services.WifiService?.connectionState === "failed" && (Services.WifiService?.lastError ?? "").length > 0
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.ThemeManager.spacingSm

                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: Theme.ThemeManager.radiusMedium
                        color: cancelPwMa.containsMouse ? Theme.ThemeManager.surface1 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)

                        Text {
                            anchors.centerIn: parent
                            text: I18n.I18n.t("popup.wifi.password.cancel")
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                        }

                        MouseArea {
                            id: cancelPwMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                wifiPopup.currentView = "list"
                                wifiPopup.selectedNetwork = null
                                passwordInput.text = ""
                                Services.WifiService.lastError = ""
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: Theme.ThemeManager.radiusMedium
                        color: connectPwMa.containsMouse ? Qt.rgba(Theme.ThemeManager.accent.r, Theme.ThemeManager.accent.g, Theme.ThemeManager.accent.b, 0.8) : Theme.ThemeManager.accent
                        enabled: passwordInput.text.length > 0 && Services.WifiService?.connectionState !== "connecting"

                        Text {
                            anchors.centerIn: parent
                            text: I18n.I18n.t("popup.wifi.password.connect")
                            color: Theme.ThemeManager.base
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                            font.bold: true
                        }

                        MouseArea {
                            id: connectPwMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (wifiPopup.selectedNetwork) {
                                    Services.WifiService?.connect(wifiPopup.selectedNetwork.ssid, passwordInput.text)
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }

            ColumnLayout {
                id: forgetConfirmView
                anchors.fill: parent
                spacing: Theme.ThemeManager.spacingMd
                visible: wifiPopup.currentView === "forgetConfirm"

                Item { Layout.fillHeight: true }

                Text {
                    text: Components.Icons.wifiLock
                    color: Theme.ThemeManager.warning
                    font.pixelSize: 36
                    font.family: Components.Icons.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: I18n.I18n.t("popup.wifi.forget.confirm")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeMd
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: wifiPopup.forgetTargetSsid
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.ThemeManager.spacingSm

                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: Theme.ThemeManager.radiusMedium
                        color: cancelForgetMa.containsMouse ? Theme.ThemeManager.surface1 : Qt.rgba(Theme.ThemeManager.surface0.r, Theme.ThemeManager.surface0.g, Theme.ThemeManager.surface0.b, 0.3)

                        Text {
                            anchors.centerIn: parent
                            text: I18n.I18n.t("popup.wifi.password.cancel")
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                        }

                        MouseArea {
                            id: cancelForgetMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                wifiPopup.currentView = "list"
                                wifiPopup.forgetTargetSsid = ""
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: Theme.ThemeManager.radiusMedium
                        color: confirmForgetMa.containsMouse ? Qt.rgba(Theme.ThemeManager.error.r, Theme.ThemeManager.error.g, Theme.ThemeManager.error.b, 0.8) : Theme.ThemeManager.error

                        Text {
                            anchors.centerIn: parent
                            text: I18n.I18n.t("popup.wifi.forget")
                            color: Theme.ThemeManager.base
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                            font.bold: true
                        }

                        MouseArea {
                            id: confirmForgetMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (Services.WifiService?.connected && Services.WifiService?.ssid === wifiPopup.forgetTargetSsid) {
                                    Services.WifiService?.disconnect()
                                }
                                Services.WifiService?.forget(wifiPopup.forgetTargetSsid)
                                wifiPopup.currentView = "list"
                                wifiPopup.forgetTargetSsid = ""
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        property bool showPasswordToggle: false
    }

    property bool showPasswordToggle: false

    QtObject {
        id: showPasswordToggle
        property bool checked: false
    }

    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (wifiPopup.currentView !== "list") {
                wifiPopup.currentView = "list"
                wifiPopup.selectedNetwork = null
                wifiPopup.forgetTargetSsid = ""
            } else {
                wifiPopup.visible = false
            }
        }
    }

    onVisibleChanged: {
        if (!wifiPopup.visible) {
            wifiPopup.currentView = "list"
            wifiPopup.selectedNetwork = null
            wifiPopup.forgetTargetSsid = ""
            showPasswordToggle.checked = false
        }
    }

    Connections {
        target: Services.WifiService

        function onConnectionSucceeded() {
            if (wifiPopup.currentView === "password") {
                wifiPopup.currentView = "list"
                wifiPopup.selectedNetwork = null
                showPasswordToggle.checked = false
            }
        }

        function onConnectionFailed() {
            passwordInput.forceActiveFocus()
        }
    }
}
