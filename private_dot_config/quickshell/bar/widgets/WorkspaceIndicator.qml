import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../theme" as Theme

Item {
    id: workspaceIndicator
    property string monitorName: ""

    implicitWidth: row.width
    implicitHeight: 28

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                id: wsDelegate
                required property var modelData
                property int wsId: modelData.id
                property bool isActive: Hyprland.focusedWorkspace?.id === wsId
                property bool hasWindows: modelData.windows?.count > 0
                property bool isHovered: wsMouseArea.containsMouse

                visible: wsId > 0
                width: visible ? (isActive ? 26 : 20) : 0
                height: visible ? 22 : 0
                radius: Theme.ThemeManager.radiusSmall

                color: {
                    if (isActive) return Theme.ThemeManager.accent
                    if (isHovered) return Theme.ThemeManager.surface1
                    if (hasWindows) return Theme.ThemeManager.surface0
                    return "transparent"
                }

                Behavior on width {
                    NumberAnimation {
                        duration: Theme.ThemeManager.durationSlow
                        easing.type: Easing.OutBack
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.ThemeManager.durationNormal
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: parent.wsId.toString()
                    color: parent.isActive ? Theme.ThemeManager.crust : Theme.ThemeManager.text
                    font.pixelSize: Theme.ThemeManager.fontSizeSm
                    font.family: Theme.ThemeManager.fontFamily
                    font.bold: parent.isActive
                }

                MouseArea {
                    id: wsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = '" + parent.wsId + "' })"])
                    }

                    onWheel: function(event) {
                        if (event.angleDelta.y > 0) {
                            Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = 'm+1' })"])
                        } else {
                            Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ workspace = 'm-1' })"])
                        }
                    }
                }
            }
        }
    }
}
