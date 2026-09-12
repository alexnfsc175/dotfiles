import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../components" as Components
import "../../theme" as Theme
import "../../services" as Services
import "../../i18n" as I18n

Components.BasePopup {
    id: bluetoothPopup

    popupWidth: 320
    popupHeight: 400

    property bool showForgetConfirm: false
    property string forgetAddress: ""

    property string contextMenuDeviceAddress: ""
    property bool contextMenuVisible: false
    property real contextMenuX: 0
    property real contextMenuY: 0

    function closeContextMenu() {
        contextMenuVisible = false
        contextMenuDeviceAddress = ""
    }

    function openContextMenu(address, buttonItem) {
        var pos = buttonItem.mapToItem(bluetoothPopup.contentItem, 0, 0)
        contextMenuX = pos.x - 187 + buttonItem.width
        contextMenuY = pos.y - 4
        contextMenuDeviceAddress = address
        contextMenuVisible = true
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: 1
        focus: true
        Keys.onEscapePressed: {
            if (contextMenuVisible) closeContextMenu()
            else if (showForgetConfirm) { showForgetConfirm = false; forgetAddress = "" }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                if (contextMenuVisible) closeContextMenu()
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.ThemeManager.spacingLg
            spacing: Theme.ThemeManager.spacingMd

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: I18n.I18n.t("popup.bluetooth.title")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeLg
                    font.family: Theme.ThemeManager.fontFamily
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: Services.BluetoothService?.scanning ? I18n.I18n.t("popup.bluetooth.scanning") : ""
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    visible: Services.BluetoothService?.scanning ?? false

                    SequentialAnimation on opacity {
                        running: Services.BluetoothService?.scanning ?? false
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }

                Rectangle {
                    width: 28
                    height: 28
                    radius: 14
                    color: "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: Components.Icons.scanning
                        color: Services.BluetoothService?.scanning ? Theme.ThemeManager.accent : Theme.ThemeManager.overlay1
                        font.pixelSize: Theme.ThemeManager.fontSizeMd
                        font.family: Components.Icons.fontFamily

                        SequentialAnimation on rotation {
                            running: Services.BluetoothService?.scanning ?? false
                            loops: Animation.Infinite
                            NumberAnimation { from: 0; to: 360; duration: 2000 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Services.BluetoothService?.scan()
                    }
                }

                Rectangle {
                    width: 48
                    height: 26
                    radius: 13
                    color: Services.BluetoothService?.powered ?? false ? Theme.ThemeManager.accent : Theme.ThemeManager.surface1

                    Rectangle {
                        width: 22
                        height: 22
                        radius: 11
                        color: Theme.ThemeManager.crust
                        anchors.verticalCenter: parent.verticalCenter
                        x: Services.BluetoothService?.powered ?? false ? parent.width - width - 2 : 2

                        Behavior on x {
                            NumberAnimation { duration: Theme.ThemeManager.durationNormal }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Services.BluetoothService?.toggle()
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: {
                        var count = Services.BluetoothService?.devices?.length ?? 0
                        return I18n.I18n.t("popup.bluetooth.devices") + " (" + count + ")"
                    }
                    color: Theme.ThemeManager.subtext0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: I18n.I18n.t("popup.bluetooth.scanning")
                    color: Theme.ThemeManager.accent
                    font.pixelSize: Theme.ThemeManager.fontSizeXs
                    font.family: Theme.ThemeManager.fontFamily
                    visible: Services.BluetoothService?.scanning ?? false
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: Theme.ThemeManager.spacingSm

                model: Services.BluetoothService?.devices ?? []

                delegate: Components.BluetoothDeviceCard {
                    required property var modelData
                    required property int index
                    device: modelData
                    isMenuOpen: bluetoothPopup.contextMenuDeviceAddress === modelData.address && bluetoothPopup.contextMenuVisible
                    width: ListView.view.width

                    onConnectRequested: {
                        bluetoothPopup.closeContextMenu()
                        Services.BluetoothService?.connect(modelData.address)
                    }
                    onDisconnectRequested: {
                        bluetoothPopup.closeContextMenu()
                        Services.BluetoothService?.disconnect(modelData.address)
                    }
                    onForgetRequested: {
                        bluetoothPopup.closeContextMenu()
                        bluetoothPopup.forgetAddress = modelData.address
                        bluetoothPopup.showForgetConfirm = true
                    }
                    onPairRequested: {
                        bluetoothPopup.closeContextMenu()
                        Services.BluetoothService?.pair(modelData.address)
                    }
                    onMenuRequested: function(buttonItem) {
                        if (bluetoothPopup.contextMenuDeviceAddress === modelData.address && bluetoothPopup.contextMenuVisible) {
                            bluetoothPopup.closeContextMenu()
                        } else {
                            bluetoothPopup.openContextMenu(modelData.address, buttonItem)
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: I18n.I18n.t("popup.bluetooth.no-devices")
                    color: Theme.ThemeManager.overlay0
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                    visible: parent.count === 0
                }
            }

            Text {
                text: I18n.I18n.t("popup.bluetooth.disabled")
                color: Theme.ThemeManager.overlay0
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Theme.ThemeManager.fontFamily
                Layout.alignment: Qt.AlignHCenter
                visible: !(Services.BluetoothService?.powered ?? false)
            }

            Text {
                text: I18n.I18n.t("popup.bluetooth.no-adapter")
                color: Theme.ThemeManager.error
                font.pixelSize: Theme.ThemeManager.fontSizeSm
                font.family: Theme.ThemeManager.fontFamily
                Layout.alignment: Qt.AlignHCenter
                visible: !(Services.BluetoothService?.available ?? true)
            }
        }

        Rectangle {
            id: contextMenuRect
            x: bluetoothPopup.contextMenuX
            y: bluetoothPopup.contextMenuY
            width: 160
            height: contextMenuColumn.height + 12
            radius: Theme.ThemeManager.radiusMedium
            color: Theme.ThemeManager.surface1
            border.color: Theme.ThemeManager.surface2
            border.width: 1
            visible: bluetoothPopup.contextMenuVisible
            z: 300

            Column {
                id: contextMenuColumn
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 6
                spacing: 2

                property var menuDevice: {
                    var addr = bluetoothPopup.contextMenuDeviceAddress
                    var model = Services.BluetoothService?.devices
                    if (!model) return null
                    for (var i = 0; i < model.count; i++) {
                        var d = model.get(i)
                        if (d.address === addr) return d
                    }
                    return null
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: Theme.ThemeManager.radiusSmall
                    color: connectMa.containsMouse ? Theme.ThemeManager.surface0 : "transparent"
                    visible: contextMenuColumn.menuDevice && contextMenuColumn.menuDevice.paired

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: contextMenuColumn.menuDevice && contextMenuColumn.menuDevice.connected ? I18n.I18n.t("popup.bluetooth.disconnect") : I18n.I18n.t("popup.bluetooth.connect")
                        color: Theme.ThemeManager.text
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                    }

                    MouseArea {
                        id: connectMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            bluetoothPopup.closeContextMenu()
                            if (contextMenuColumn.menuDevice.connected) {
                                Services.BluetoothService?.disconnect(bluetoothPopup.contextMenuDeviceAddress)
                            } else {
                                Services.BluetoothService?.connect(bluetoothPopup.contextMenuDeviceAddress)
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: Theme.ThemeManager.radiusSmall
                    color: forgetMa.containsMouse ? Theme.ThemeManager.surface0 : "transparent"
                    visible: contextMenuColumn.menuDevice && contextMenuColumn.menuDevice.paired

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: I18n.I18n.t("popup.bluetooth.forget")
                        color: Theme.ThemeManager.error
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                    }

                    MouseArea {
                        id: forgetMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            bluetoothPopup.closeContextMenu()
                            bluetoothPopup.forgetAddress = bluetoothPopup.contextMenuDeviceAddress
                            bluetoothPopup.showForgetConfirm = true
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 32
                    radius: Theme.ThemeManager.radiusSmall
                    color: pairMa.containsMouse ? Theme.ThemeManager.surface0 : "transparent"
                    visible: contextMenuColumn.menuDevice && !contextMenuColumn.menuDevice.paired

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: I18n.I18n.t("popup.bluetooth.pair")
                        color: Theme.ThemeManager.accent
                        font.pixelSize: Theme.ThemeManager.fontSizeSm
                        font.family: Theme.ThemeManager.fontFamily
                    }

                    MouseArea {
                        id: pairMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            bluetoothPopup.closeContextMenu()
                            Services.BluetoothService?.pair(bluetoothPopup.contextMenuDeviceAddress)
                        }
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: Theme.ThemeManager.radiusMedium
            color: Qt.rgba(Theme.ThemeManager.crust.r, Theme.ThemeManager.crust.g, Theme.ThemeManager.crust.b, 0.95)
            visible: showForgetConfirm
            z: 400

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Theme.ThemeManager.spacingMd

                Text {
                    text: I18n.I18n.t("popup.bluetooth.forget.confirm")
                    color: Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeMd
                    font.family: Theme.ThemeManager.fontFamily
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
                            text: I18n.I18n.t("popup.bluetooth.cancel")
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                showForgetConfirm = false
                                forgetAddress = ""
                            }
                        }
                    }

                    Rectangle {
                        width: 100
                        height: 36
                        radius: Theme.ThemeManager.radiusSmall
                        color: Theme.ThemeManager.error

                        Text {
                            anchors.centerIn: parent
                            text: I18n.I18n.t("popup.bluetooth.forget")
                            color: Theme.ThemeManager.text
                            font.pixelSize: Theme.ThemeManager.fontSizeSm
                            font.family: Theme.ThemeManager.fontFamily
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Services.BluetoothService?.remove(forgetAddress)
                                showForgetConfirm = false
                                forgetAddress = ""
                            }
                        }
                    }
                }
            }
        }
    }

    onVisibleChanged: {
        if (!visible) {
            closeContextMenu()
        }
    }
}
