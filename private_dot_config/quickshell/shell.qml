import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "bar" as Bar
import "bar/popups" as Popups
import "components" as Components
import "theme" as Theme

ShellRoot {
    id: root

    IpcHandler {
        target: "theme"

        function cycle() {
            Theme.ThemeManager.cycle()
        }

        function set(name: string) {
            Theme.ThemeManager.setTheme(name)
        }
    }

    GlobalShortcut {
        name: "theme-cycle"
        description: "Cycle to the next theme"
        onPressed: Theme.ThemeManager.cycle()
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: barWindow
                required property var modelData
                screen: modelData

                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.namespace: "quickshell-modern-bar"
                exclusionMode: ExclusionMode.Normal

                anchors {
                    top: true
                    left: true
                    right: true
                }

                exclusiveZone: 40
                color: "transparent"

                implicitHeight: 44

                Rectangle {
                    id: barBackground
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    color: Qt.rgba(Theme.ThemeManager.mantle.r, Theme.ThemeManager.mantle.g, Theme.ThemeManager.mantle.b, Theme.ThemeManager.bgTransparency)
                    radius: Theme.ThemeManager.radiusLarge

                    border.width: 1
                    border.color: Qt.rgba(Theme.ThemeManager.text.r, Theme.ThemeManager.text.g, Theme.ThemeManager.text.b, 0.08)

                    Bar.Bar {
                        id: bar
                        anchors.fill: parent
                        anchors.leftMargin: Theme.ThemeManager.spacingLg
                        anchors.rightMargin: Theme.ThemeManager.spacingLg
                        monitorName: barWindow.modelData.name

                        onTogglePowerMenu: powerMenu.visible = !powerMenu.visible
                        onToggleCalendar: calendarPopup.visible = !calendarPopup.visible
                        onToggleVolumePopup: volumePopup.visible = !volumePopup.visible
                        onToggleBatteryPopup: batteryPopup.visible = !batteryPopup.visible
                        onToggleBluetoothPopup: bluetoothPopup.visible = !bluetoothPopup.visible
                        onToggleWifiPopup: wifiPopup.visible = !wifiPopup.visible
                        onWifiHoverEntered: wifiStatsPopup.visible = true
                        onWifiHoverExited: wifiStatsPopup.visible = false
                        onBluetoothHoverEntered: bluetoothStatsPopup.visible = true
                        onBluetoothHoverExited: bluetoothStatsPopup.visible = false
                    }
                }

                Popups.PowerMenu {
                    id: powerMenu
                    barWindow: barWindow
                }

                Popups.CalendarPopup {
                    id: calendarPopup
                    barWindow: barWindow
                }

                Popups.VolumePopup {
                    id: volumePopup
                    barWindow: barWindow
                }

                Popups.BatteryPopup {
                    id: batteryPopup
                    barWindow: barWindow
                }

                Popups.BluetoothPopup {
                    id: bluetoothPopup
                    barWindow: barWindow
                }

                Components.BluetoothStatsPopup {
                    id: bluetoothStatsPopup
                    barWindow: barWindow
                }

                Popups.WifiPopup {
                    id: wifiPopup
                    barWindow: barWindow
                    onVisibleChanged: {
                        if (visible && wifiStatsPopup.visible) {
                            wifiStatsPopup.visible = false
                        }
                    }
                }

                Popups.WifiStatsPopup {
                    id: wifiStatsPopup
                    barWindow: barWindow
                }
            }
        }
    }
}
