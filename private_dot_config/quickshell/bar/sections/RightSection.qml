import QtQuick
import QtQuick.Layouts
import "../widgets" as Widgets
import "../../theme" as Theme

Item {
    id: rightSection

    signal togglePowerMenu()
    signal toggleVolumePopup()
    signal toggleBatteryPopup()
    signal toggleBluetoothPopup()
    signal toggleWifiPopup()
    signal wifiHoverEntered()
    signal wifiHoverExited()
    signal bluetoothHoverEntered()
    signal bluetoothHoverExited()

    implicitWidth: statusRow.implicitWidth
    implicitHeight: 28

    Row {
        id: statusRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: 12

        Widgets.VolumeWidget {
            onClicked: rightSection.toggleVolumePopup()
        }
        Widgets.BatteryWidget {
            onClicked: rightSection.toggleBatteryPopup()
        }
        Widgets.BluetoothWidget {
            onClicked: rightSection.toggleBluetoothPopup()
            onHoverEntered: rightSection.bluetoothHoverEntered()
            onHoverExited: rightSection.bluetoothHoverExited()
        }
        Widgets.WifiWidget {
            onClicked: rightSection.toggleWifiPopup()
            onHoverEntered: rightSection.wifiHoverEntered()
            onHoverExited: rightSection.wifiHoverExited()
        }
        Widgets.PowerButton {
            onClicked: rightSection.togglePowerMenu()
        }
    }
}
