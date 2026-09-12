import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../services" as Services
import "../../theme" as Theme

Item {
    id: trayWidget

    property bool trayCollapsed: true

    Row {
        id: mainRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.ThemeManager.spacingXs

        Components.BaseWidget {
            id: expandButton
            icon: trayWidget.trayCollapsed ? Components.Icons.trayExpand : Components.Icons.trayCollapse
            onClicked: trayWidget.trayCollapsed = !trayWidget.trayCollapsed
        }

        Row {
            id: trayRow
            spacing: Theme.ThemeManager.spacingXs
            visible: !trayWidget.trayCollapsed

            Repeater {
                model: Services.TrayService?.items ?? []

                delegate: Item {
                    required property var modelData
                    width: Theme.ThemeManager.widgetWidth * 0.71
                    height: Theme.ThemeManager.widgetHeight * 0.71
    Layout.preferredWidth: width
    Layout.preferredHeight: height

                    Image {
                        anchors.centerIn: parent
                        source: modelData.icon
                        width: Theme.ThemeManager.fontSizeLg
                        height: Theme.ThemeManager.fontSizeLg
                        sourceSize: Qt.size(Theme.ThemeManager.fontSizeLg, Theme.ThemeManager.fontSizeLg)
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function(event) {
                            if (event.button === Qt.LeftButton) modelData.activate()
                            else if (event.button === Qt.RightButton) modelData.secondaryActivate()
                        }
                    }
                }
            }
        }
    }
}
