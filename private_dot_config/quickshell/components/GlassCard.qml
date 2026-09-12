import QtQuick
import QtQuick.Layouts
import "../theme" as Theme

Rectangle {
    id: glassCard

    property int padding: Theme.ThemeManager.spacingMd

    radius: Theme.ThemeManager.radiusXl
    color: Qt.rgba(
        Theme.ThemeManager.crust.r,
        Theme.ThemeManager.crust.g,
        Theme.ThemeManager.crust.b,
        Theme.ThemeManager.popupTransparency
    )
    border.width: 1
    border.color: Qt.rgba(
        Theme.ThemeManager.text.r,
        Theme.ThemeManager.text.g,
        Theme.ThemeManager.text.b,
        0.1
    )

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: glassCard.padding
        spacing: Theme.ThemeManager.spacingMd
    }

    default property alias content: layout.data
}
