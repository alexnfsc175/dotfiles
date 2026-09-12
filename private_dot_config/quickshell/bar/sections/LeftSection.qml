import QtQuick
import "../widgets" as Widgets

Item {
    id: leftSection
    property string monitorName: ""

    implicitWidth: workspaceRow.width
    implicitHeight: 28

    Row {
        id: workspaceRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Widgets.WorkspaceIndicator {
            monitorName: leftSection.monitorName
        }
    }
}
