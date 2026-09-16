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
                id: barPanel
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
                        monitorName: barPanel.modelData.name

                        onTogglePowerMenu: barPanel.togglePopup(powerMenuLoader)
                        onToggleCalendar: barPanel.togglePopup(calendarPopupLoader)
                        onToggleVolumePopup: barPanel.togglePopup(volumePopupLoader)
                        onToggleBatteryPopup: barPanel.togglePopup(batteryPopupLoader)
                        onToggleBluetoothPopup: barPanel.togglePopup(bluetoothPopupLoader)
                        onToggleWifiPopup: barPanel.togglePopup(wifiPopupLoader)
                        onWifiHoverEntered: barPanel.showHoverPopup(wifiStatsPopupLoader)
                        onWifiHoverExited: barPanel.hideHoverPopup(wifiStatsPopupLoader)
                        onBluetoothHoverEntered: barPanel.showHoverPopup(bluetoothStatsPopupLoader)
                        onBluetoothHoverExited: barPanel.hideHoverPopup(bluetoothStatsPopupLoader)
                    }
                }

                function togglePopup(loader) {
                    if (!loader.active) {
                        loader.active = true
                    } else if (loader.item) {
                        loader.item.visible = !loader.item.visible
                    }
                }

                function showHoverPopup(loader) {
                    if (!loader.active) {
                        loader.active = true
                    } else if (loader.item) {
                        loader.item.visible = true
                    }
                }

                function hideHoverPopup(loader) {
                    if (loader.active && loader.item) {
                        loader.item.visible = false
                    }
                }

                Loader {
                    id: powerMenuLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.PowerMenu {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: calendarPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.CalendarPopup {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: volumePopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.VolumePopup {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: batteryPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.BatteryPopup {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: bluetoothPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.BluetoothPopup {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: bluetoothStatsPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Components.BluetoothStatsPopup {
                            barWindow: barPanel
                        }
                    }
                }

                Loader {
                    id: wifiPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.WifiPopup {
                            barWindow: barPanel
                            onVisibleChanged: {
                                if (visible && wifiStatsPopupLoader.active && wifiStatsPopupLoader.item) {
                                    wifiStatsPopupLoader.item.visible = false
                                }
                            }
                        }
                    }
                }

                Loader {
                    id: wifiStatsPopupLoader
                    active: false
                    onLoaded: if (item) item.visible = true
                    sourceComponent: Component {
                        Popups.WifiStatsPopup {
                            barWindow: barPanel
                        }
                    }
                }
            }
        }
    }
}
