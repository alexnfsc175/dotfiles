import QtQuick
import QtQuick.Layouts
import "sections" as Sections

Item {
    id: bar

    property string monitorName: ""

    signal togglePowerMenu()
    signal toggleCalendar()
    signal toggleVolumePopup()
    signal toggleBatteryPopup()
    signal toggleBluetoothPopup()
    signal toggleWifiPopup()
    signal wifiHoverEntered()
    signal wifiHoverExited()
    signal bluetoothHoverEntered()
    signal bluetoothHoverExited()

    Sections.LeftSection {
        id: leftSection
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        monitorName: bar.monitorName
    }

    Sections.CenterSection {
        id: centerSection
        anchors.centerIn: parent
        onToggleCalendar: bar.toggleCalendar()
    }

    Sections.RightSection {
        id: rightSection
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        onTogglePowerMenu: bar.togglePowerMenu()
        onToggleVolumePopup: bar.toggleVolumePopup()
        onToggleBatteryPopup: bar.toggleBatteryPopup()
        onToggleBluetoothPopup: bar.toggleBluetoothPopup()
        onToggleWifiPopup: bar.toggleWifiPopup()
        onWifiHoverEntered: bar.wifiHoverEntered()
        onWifiHoverExited: bar.wifiHoverExited()
        onBluetoothHoverEntered: bar.bluetoothHoverEntered()
        onBluetoothHoverExited: bar.bluetoothHoverExited()
    }
}
